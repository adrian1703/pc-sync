#!/bin/bash

cat <<EEF
==================================================================================
                           MAC ZOOM CHANGER V1.0
 Change the display scaling by percentage by creating a custom resolution override.
 This script assumes your monitor supports HiDPI.
==================================================================================
EEF

currentDir="$(cd $(dirname -- $0) && pwd)"
is_applesilicon=$([[ "$(uname -m)" == "arm64" ]] && echo true || echo false)

function get_edid() {
  local index=0
  local selection=0

  gDisplayInf=($(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e "/[^<]*</s///" -e "s/\>//"))

  if [[ "${#gDisplayInf[@]}" -ge 2 ]]; then

    echo ""
    echo "                      Displays                      "
    echo "--------------------------------------------------------"
    echo "   Index   |   VendorID   |   ProductID   |   MonitorName   "
    echo "--------------------------------------------------------"

    for display in "${gDisplayInf[@]}"; do
      let index++
      MonitorName=("$(echo ${display:190:24} | xxd -p -r)")
      VendorID=${display:16:4}
      ProductID=${display:22:2}${display:20:2}

      printf "    %d    |    ${VendorID}    |     ${ProductID}    |  ${MonitorName}\n" ${index}
    done

    echo "--------------------------------------------------------"

    read -p "Select a display: " selection
    case $selection in
    [[:digit:]]*)
      if ((selection < 1 || selection > index)); then
        echo "Invalid selection."
        exit 1
      fi
      let selection-=1
      gMonitor=${gDisplayInf[$selection]}
      ;;

    *)
      echo "Invalid selection."
      exit 1
      ;;
    esac
  else
    gMonitor=${gDisplayInf}
  fi

  EDID=${gMonitor}
  VendorID=$((0x${gMonitor:16:4}))
  ProductID=$((0x${gMonitor:22:2}${gMonitor:20:2}))
  Vid=($(printf '%x\n' ${VendorID}))
  Pid=($(printf '%x\n' ${ProductID}))
}

function get_vidpid_applesilicon() {
  local index=0
  local prodnamesindex=0
  local selection=0

  local appleDisplClass='AppleCLCD2'

  local value="/following-sibling::*[1]"
  local get="/text()"

  local displattr="/key[.='DisplayAttributes']"
  local prodattr="/key[.='ProductAttributes']"
  local vendid="/key[.='LegacyManufacturerID']"
  local prodid="/key[.='ProductID']"
  local prodname="/key[.='ProductName']"

  local prodAttrsQuery="/$displattr$value$prodattr$value"
  local vendIDQuery="$prodAttrsQuery$vendid$value$get"
  local prodIDQuery="$prodAttrsQuery$prodid$value$get"
  local prodNameQuery="$prodAttrsQuery$prodname$value$get"

  local vends=($(ioreg -l | grep "DisplayAttributes" | sed -n 's/.*"LegacyManufacturerID"=\([0-9]*\).*/\1/p'))
  local prods=($(ioreg -l | grep "DisplayAttributes" | sed -n 's/.*"ProductID"=\([0-9]*\).*/\1/p'))

  set -o noglob
  IFS=$'\n' prodnames=($(ioreg -l | grep "DisplayAttributes" | sed -n 's/.*"ProductName"="\([^"]*\)".*/\1/p'))
  set +o noglob

  if [[ "${#prods[@]}" -ge 2 ]]; then

    echo ""
    echo "                      Displays                      "
    echo "------------------------------------------------------------"
    echo "   Index   |   VendorID   |   ProductID   |   MonitorName  "
    echo "------------------------------------------------------------"

    for prod in "${prods[@]}"; do
      MonitorName=${prodnames[$prodnamesindex]}
      VendorID=$(printf "%04x" ${vends[$index]})
      ProductID=$(printf "%04x" ${prods[$index]})

      let index++
      let prodnamesindex++

      vendor_id_lc="$(echo "${VendorID}" | tr '[:upper:]' '[:lower:]')"
      case "${vendor_id_lc}" in
      0610)
        MonitorName="Apple Display"
        let prodnamesindex--
        ;;

      esac

      printf "    %-3d    |     ${VendorID}     |  %-12s |  ${MonitorName}\n" ${index} ${ProductID}
    done

    echo "------------------------------------------------------------"

    read -p "Select a display: " selection
    case $selection in
    [[:digit:]]*)
      if ((selection < 1 || selection > index)); then
        echo "Invalid selection."
        exit 1
      fi
      let selection-=1
      dispid=$selection
      ;;

    *)
      echo "Invalid selection."
      exit 1
      ;;
    esac
  else
    dispid=0
  fi

  VendorID=${vends[$dispid]}
  ProductID=${prods[$dispid]}
  Vid=($(printf '%x\n' ${VendorID}))
  Pid=($(printf '%x\n' ${ProductID}))
}

function init() {
  rm -rf ${currentDir}/tmp/
  mkdir -p ${currentDir}/tmp/

  libDisplaysDir="/Library/Displays"
  targetDir="${libDisplaysDir}/Contents/Resources/Overrides"
  sysDisplayDir="/System${targetDir}"
  Overrides="\/Library\/Displays\/Contents\/Resources\/Overrides"
  sysOverrides="\/System${Overrides}"

  if [[ ! -d "${targetDir}" ]]; then
    sudo mkdir -p "${targetDir}"
  fi

  if [[ $is_applesilicon == true ]]; then
    get_vidpid_applesilicon
  else
    get_edid
  fi

  if [[ -z $VendorID || -z $ProductID || $VendorID == 0 || $ProductID == 0 ]]; then
    echo "No displays were found. Exiting..."
    exit 2
  fi

  echo "Selected display VID:PID: $Vid:$Pid"

}

function end() {
  sudo chown -R root:wheel ${currentDir}/tmp/
  sudo chmod -R 0755 ${currentDir}/tmp/
  sudo chmod 0644 ${currentDir}/tmp/DisplayVendorID-${Vid}/*
  sudo cp -r ${currentDir}/tmp/* ${targetDir}/
  sudo rm -rf ${currentDir}/tmp
  sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool YES
  echo "Done. Reboot for the changes to take effect."
  echo "Note: After the reboot, go to System Preferences > Displays > Select the display you want to change the scaling for and then set the Scale Display to the desired percentage."
}

function create_res() {
  for res in $@; do
    width=$(echo ${res} | cut -d x -f 1)
    height=$(echo ${res} | cut -d x -f 2)
    hidpi=$(printf '%08x %08x' $((${width} * 2)) $((${height} * 2)) | xxd -r -p | base64)
    cat <<OOO >>${dpiFile}
                <data>${hidpi:0:11}AAAAB</data>
                <data>${hidpi:0:11}AAAABACAAAA==</data>
OOO
  done
}

function get_display_resolutions_json() {
  local vid_hex="0x${Vid}"
  local pid_hex="0x${Pid}"
  /usr/sbin/system_profiler SPDisplaysDataType -json 2>/dev/null | /usr/bin/python3 - "$vid_hex" "$pid_hex" <<'PY'
import json, re, sys

vid = sys.argv[1].lower()
pid = sys.argv[2].lower()

def norm_id(s: str) -> str:
    if not s:
        return ""
    s = str(s).strip().lower()
    if s.startswith("0x"):
        return s
    if re.fullmatch(r"[0-9a-f]+", s):
        return "0x" + s
    return s

def parse_res(s):
    if not s:
        return ""
    s = str(s)
    m = re.search(r"(\d+)\s*[x×]\s*(\d+)", s)
    return f"{m.group(1)}x{m.group(2)}" if m else ""

def iter_items(obj):
    if isinstance(obj, dict):
        if "_items" in obj and isinstance(obj["_items"], list):
            for it in obj["_items"]:
                yield it
        for v in obj.values():
            yield from iter_items(v)
    elif isinstance(obj, list):
        for it in obj:
            yield from iter_items(it)

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

physical = ""
looks = ""

for it in iter_items(data):
    if not isinstance(it, dict):
        continue
    v = norm_id(it.get("spdisplays_vendor-id") or it.get("spdisplays_vendor_id") or it.get("spdisplays_vendorid") or it.get("spdisplays_vendor"))
    p = norm_id(it.get("spdisplays_product-id") or it.get("spdisplays_product_id") or it.get("spdisplays_productid") or it.get("spdisplays_product"))
    if v != vid or p != pid:
        continue
    physical = parse_res(it.get("spdisplays_resolution") or it.get("spdisplays_pixels") or it.get("spdisplays_display-res") or it.get("spdisplays_display_resolution"))
    looks = parse_res(it.get("spdisplays_ui_resolution") or it.get("spdisplays_ui-looks-like") or it.get("spdisplays_ui_looks_like") or it.get("spdisplays_ui_looks_like_resolution") or it.get("spdisplays_looks_like"))
    break

sys.stdout.write((physical or "") + "\n" + (looks or "") + "\n")
PY
}

function apply_zoom() {
  local physical looks
  echo ""
  echo "----------------------"
  echo "Display: ${MonitorName:-Unknown}"
  echo "VID:PID: ${Vid}:${Pid}"
  echo "----------------------"
  echo ""

  local manual=""
  while true; do
    read -p "Enter the display native resolution (e.g. 3440x1440): " manual
    manual="${manual// /}"
    manual="${manual/X/x}"
    if [[ "$manual" =~ ^[0-9]+x[0-9]+$ ]]; then
      physical="$manual"
      break
    fi
    echo "Invalid format. Use WIDTHxHEIGHT (example: 3440x1440)."
  done
  echo "Using native resolution: $physical"
  echo ""

  local input percent
  read -p "Enter zoom percentage (example: 125 or 125%): " input
  percent="${input// /}"
  percent="${percent%\%}"

  if [[ ! "$percent" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
    echo "Invalid percentage. Use a number like 125 or 125%."
    exit 1
  fi

  if [[ -z "$physical" || "$physical" != *x* ]]; then
    echo "Native resolution is missing or invalid. Aborting."
    exit 1
  fi

  local native_w native_h
  native_w="${physical%x*}"
  native_h="${physical#*x}"

  local w h
  w=$(echo "scale=6; ($native_w*100/$percent)+0.5" | /usr/bin/bc -l | /usr/bin/cut -d. -f1)
  h=$(echo "scale=6; ($native_h*100/$percent)+0.5" | /usr/bin/bc -l | /usr/bin/cut -d. -f1)

  if [[ -z "$w" || -z "$h" || "$w" -le 0 || "$h" -le 0 ]]; then
    echo "Computed resolution is invalid. Aborting."
    exit 1
  fi

  echo ""
  echo "Target HiDPI resolution: ${w}x${h} (from ${native_w}x${native_h} at ${percent}%)"
  echo ""

  read -p "Apply HiDPI scaling now? [y/N]: " yn
  case "$yn" in
  y | Y | yes | YES)
    ;;
  *)
    echo "Canceled."
    exit 0
    ;;
  esac

  main_percent "${w}x${h}"
  sed -i "" "/.*IODisplayEDID/d" ${dpiFile}
  sed -i "" "/.*EDid/d" ${dpiFile}
  end
}

function main_percent() {
  local res="$1"

  sudo mkdir -p ${currentDir}/tmp/DisplayVendorID-${Vid}
  dpiFile=${currentDir}/tmp/DisplayVendorID-${Vid}/DisplayProductID-${Pid}
  sudo chmod -R 777 ${currentDir}/tmp/

  cat >"${dpiFile}" <<-\CCC
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>DisplayProductID</key>
            <integer>PID</integer>
        <key>DisplayVendorID</key>
            <integer>VID</integer>
        <key>IODisplayEDID</key>
            <data>EDid</data>
        <key>scale-resolutions</key>
            <array>
CCC

  create_res "$res"

  cat >>"${dpiFile}" <<-\FFF
            </array>
        <key>target-default-ppmm</key>
            <real>10.0699301</real>
    </dict>
</plist>
FFF

  /usr/bin/sed -i "" "s/VID/$VendorID/g" ${dpiFile}
  /usr/bin/sed -i "" "s/PID/$ProductID/g" ${dpiFile}
}

init
apply_zoom
