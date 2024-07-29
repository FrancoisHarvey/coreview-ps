function Get-Msg {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$MsgKey,

		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]
		$Substitutions = [System.Collections.ArrayList]::new(),

		[parameter()]
		[switch]$AllowNotFound = $false
	)

	if (-not $msgTable.ContainsKey($MsgKey) -and -not $AllowNotFound) {
		Write-ErrorMsg 'MsgKeyNotFound' $MsgKey
	}

	return $msgTable.$MsgKey -f ($Substitutions.ToArray())
}
