$dev = "C:\development"
$git = "PortableGit"
$scripts = "SetupScripts"

setx DEV "$dev"
setx SCRIPTS "$dev\$scripts"
setx Path "%Path%;$dev\$git"
setx Path "%Path%;$dev\$git\cmd"