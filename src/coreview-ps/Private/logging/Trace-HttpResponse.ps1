function Trace-HttpResponse {
	[CmdletBinding(ConfirmImpact = 'None')]
	param (
		[Parameter(Mandatory)]
		[System.Net.Http.HttpResponseMessage]$Response
	)

	$debugMessage = [System.Text.StringBuilder]::new()
	[void]$debugMessage.AppendLine("Received response:")
	[void]$debugMessage.AppendLine("$([int]$Response.StatusCode) $($Response.StatusCode) $($Response.ReasonPhrase)")

	foreach ($header in $Response.Headers.GetEnumerator()) {
		[void]$debugMessage.AppendLine("$($header.Key): $($header.Value -join '; ')")
	}

	if ($Response.Content) {
		if ($Response.Content.Headers) {
			foreach ($header in $Response.Content.Headers.GetEnumerator()) {
				[void]$debugMessage.AppendLine("$($header.Key): $($header.Value -join '; ')")
			}
		}

		$stringContent = $Response.Content.ReadAsStringAsync().GetAwaiter().GetResult()

		if ($stringContent) {
			[void]$debugMessage.AppendLine()
			[void]$debugMessage.Append($stringContent)
		}
	}

	[void]$debugMessage.AppendLine()
	Write-Debug $debugMessage.ToString()
}
