function tensor_ai($action, $varargs)
{
	&((Get-Item .).FullName + ".\tools\run.ps1) "$env:CHIPSETMODE" "$action"
"$varargs":
}