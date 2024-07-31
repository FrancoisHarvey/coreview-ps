function Write-ErrorMsg {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[ValidateNotNullOrWhiteSpace()]
		[string]$MsgKey,

		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]
		$Substitutions = [System.Collections.ArrayList]::new()
	)

	Write-Error (Add-PeriodIfNecessary (Get-Msg -MsgKey $MsgKey @Substitutions)) -ErrorAction Stop
}
