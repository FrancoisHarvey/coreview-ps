function Write-WarningMsg {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$MsgKey,

		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]
		$Substitutions = [System.Collections.ArrayList]::new(),

		[parameter(mandatory = $false, position = 2)]
		[switch]$Stop = $false
	)

	$warningAction = if ($Stop) { 'Stop' } else { 'Continue' }
	Write-Warning (Add-PeriodIfNecessary (Get-Msg -MsgKey $MsgKey @Substitutions)) -WarningAction $warningAction
}
