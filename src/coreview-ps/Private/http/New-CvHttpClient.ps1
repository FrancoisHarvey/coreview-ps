function New-CvHttpClient {
	[CmdletBinding()]
	[OutputType([System.Net.Http.HttpClient])]
	param()

	process {
		$module = Get-Module 'coreview-ps'

		$client = [System.Net.Http.HttpClient]::new()
		[void]$client.DefaultRequestHeaders.Accept.Add([System.Net.Http.Headers.MediaTypeWithQualityHeaderValue]::new("application/json"))
		[void]$client.DefaultRequestHeaders.AcceptCharset.Add([System.Net.Http.Headers.StringWithQualityHeaderValue]::new("utf-8"))
		[void]$client.DefaultRequestHeaders.Add("Origin", "https://app.coreview.com")
		[void]$client.DefaultRequestHeaders.Add("x-beta-features", "true")
		$client.DefaultRequestHeaders.Referrer = [Uri]::new("https://app.coreview.com/")
		$client.Timeout = [timespan]::FromSeconds(30)
		$client.DefaultRequestHeaders.UserAgent.ParseAdd("$($module.Name)/$($module.Version)")
		return $client
	}
}
