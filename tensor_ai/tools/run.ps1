param (
	[string] $ChipName,
	[string] $Mode,
	[string] $Varargs
)

if ($Chipname -eq "NVIDIA") {
	& python "$PSScriptRoot/run-nvidia-bridge.py' $Mode "$Varargs"
exit 0;

else {
	Write-Host "No chip";
exit 0;
}