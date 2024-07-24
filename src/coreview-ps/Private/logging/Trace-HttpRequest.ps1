function Trace-HttpRequest {
	[CmdletBinding(ConfirmImpact = 'None')]
	param (
		[Parameter(Mandatory)]
		[System.Net.Http.HttpRequestMessage]$Request,

		[Parameter()]
		[System.Net.Http.Headers.HttpRequestHeaders]$DefaultRequestHeaders
	)

	$debugMessage = [System.Text.StringBuilder]::new()
	[void]$debugMessage.AppendLine("Sending request:")
	[void]$debugMessage.AppendLine("$($Request.Method) $($Request.RequestUri)")

	$headers = $Request.Headers.GetEnumerator()
	if ($DefaultRequestHeaders) {
		$headers += $DefaultRequestHeaders.GetEnumerator()
	}
	foreach ($header in $headers) {
		[void]$debugMessage.AppendLine("$($header.Key): $($header.Value -join '; ')")
	}

	if ($Request.Content) {
		if ($Request.Content.Headers) {
			foreach ($header in $Request.Content.Headers.GetEnumerator()) {
				[void]$debugMessage.AppendLine("$($header.Key): $($header.Value -join '; ')")
			}
		}
		[void]$debugMessage.AppendLine()
		[void]$debugMessage.Append($Request.Content.ReadAsStringAsync().GetAwaiter().GetResult())
	}

	[void]$debugMessage.AppendLine()
	Write-Debug $debugMessage.ToString()
}
