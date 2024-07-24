function Add-PeriodIfNecessary {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$Msg
	)

	if (($msg.ToCharArray() | Select-Object -Last 1) -notin '?', '.', '!') {
		$msg += '.'
	}

	return $msg
}
