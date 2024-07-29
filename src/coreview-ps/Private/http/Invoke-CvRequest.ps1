function Invoke-CvRequest {
	[CmdletBinding()]
	param(
		[Microsoft.PowerShell.Commands.WebRequestMethod]$Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get,
		[Parameter(Mandatory)]
		[Uri]$Endpoint,
		[Hashtable]$SearchParams,
		[Parameter(Mandatory)]
		[System.Net.Http.HttpClient]$HttpClient,
		[Hashtable]$Body,
		[Hashtable]$ExtraHeaders,
		[switch]$ReturnRawResponse
	)

	process {
		# Handle SearchParams
		if ($SearchParams -and $SearchParams.Count -gt 0) {
			$uriBuilder = [System.UriBuilder]::new($Endpoint)
			$query = [System.Web.HttpUtility]::ParseQueryString($uriBuilder.Query)
			foreach ($param in $SearchParams.GetEnumerator()) {
				if ($null -ne $param.Value) {
					[void]$query.Add($param.Key, $param.Value.ToString())
				}
			}
			$uriBuilder.Query = $query.ToString()
			$Endpoint = $uriBuilder.Uri
		}

		# Create HttpRequestMessage
		$httpMethod = [System.Net.Http.HttpMethod]::Parse($Method.ToString())
		$request = [System.Net.Http.HttpRequestMessage]::new($httpMethod, $Endpoint)

		# Handle Body
		if ($Body -and $Body.Count -gt 0) {
			$request.Content = Convert-HashtableToJsonContent $Body
		}

		# Log request
		Trace-HttpRequest -Request $request -DefaultRequestHeaders $HttpClient.DefaultRequestHeaders

		# Send request and get response
		$response = $HttpClient.SendAsync($request).GetAwaiter().GetResult()

		# Handle cookies
		$cookieHeader = [string[]]''
		if ($response.Headers.TryGetValues("Set-Cookie", [ref]$cookieHeader)) {
			[void]$HttpClient.DefaultRequestHeaders.Remove("Cookie")
			[void]$HttpClient.DefaultRequestHeaders.Add("Cookie", $cookieHeader)
		}

		# Handle HTTP error codes
		if ($response.StatusCode -ge 400 -and $response.StatusCode -lt 600) {
			$statusCode = [int]$response.StatusCode
			$statusDescription = $response.StatusCode.ToString()
			$errorMessage = "HTTP ${statusCode}: $statusDescription"
			if ($response.Content) {
				$content = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
				$errorMessage += "`n$content"
			}
			Trace-HttpResponse -Response $response -Debug
			throw [System.Net.Http.HttpRequestException]::new($errorMessage)
		}

		# Log response
		Trace-HttpResponse -Response $response

		if ($ReturnRawResponse) {
			return $response
		}

		# Parse and return response
		$content = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
		$result = $content | ConvertFrom-Json -AsHashtable -Depth 30

		return $result
	}
}
