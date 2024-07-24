function Write-InfoMsg {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$MsgKey,

		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]
		$Substitutions = [System.Collections.ArrayList]::new()
	)

	Write-Information (Add-PeriodIfNecessary (Get-Msg -MsgKey $MsgKey @Substitutions)) -InformationAction Continue
}
