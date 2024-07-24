function Write-VerboseMsg {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$MsgKey,

		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]
		$Substitutions = [System.Collections.ArrayList]::new()
	)

	Write-Verbose (Add-PeriodIfNecessary (Get-Msg -MsgKey $MsgKey @Substitutions))
}
