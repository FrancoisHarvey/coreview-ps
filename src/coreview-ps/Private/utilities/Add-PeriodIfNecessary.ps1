function Add-PeriodIfNecessary {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$Msg
	)

	$trimmedMsg = $msg.TrimEnd()

	if (($trimmedMsg.ToCharArray() | Select-Object -Last 1) -notin '?', '.', '!') {
		$msg = $trimmedMsg + '.' + $msg.Substring($trimmedMsg.Length)
	}

	return $msg
}
