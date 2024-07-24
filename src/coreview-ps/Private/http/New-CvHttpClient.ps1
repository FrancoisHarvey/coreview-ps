function New-CvHttpClient {
	[CmdletBinding()]
	[OutputType([System.Net.Http.HttpClient])]
	param()

	process {
		try {
			$client = [System.Net.Http.HttpClient]::new()
			[void]$client.DefaultRequestHeaders.Accept.Add([System.Net.Http.Headers.MediaTypeWithQualityHeaderValue]::new("application/json"))
			[void]$client.DefaultRequestHeaders.AcceptCharset.Add([System.Net.Http.Headers.StringWithQualityHeaderValue]::new("utf-8"))
			[void]$client.DefaultRequestHeaders.Add("Origin", "https://app.coreview.com")
			$client.DefaultRequestHeaders.Referrer = [Uri]::new("https://app.coreview.com/")

			return $client
		}
		catch {
			Write-Error $_
		}
	}
}
