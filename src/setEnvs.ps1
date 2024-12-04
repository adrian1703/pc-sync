$dev = "C:\Development"
$git = "PortableGit"
$scripts = "SetupScripts"

setx DEV "$dev"
setx SCRIPTS "$dev\$scripts"
setx Path "%Path%;$dev\$git"
setx Path "%Path%;$dev\$git\cmd"