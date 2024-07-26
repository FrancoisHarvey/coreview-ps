function Invoke-CvRestMethod {
	[OutputType([hashtable], ParameterSetName = 'AsHashtable')]
	[OutputType([string], ParameterSetName = 'AsText')]
	[CmdletBinding(ConfirmImpact = 'Low', DefaultParameterSetName = 'AsHashtable')]
	param (
		[Parameter(Mandatory)]
		[string]$Endpoint,

		[Parameter()]
		[Microsoft.PowerShell.Commands.WebRequestMethod]$Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get,

		[Parameter()]
		[Hashtable]$SearchParams,

		[Parameter()]
		[Hashtable]$Body,

		[Parameter(ParameterSetName = 'AsText')]
		[switch]$AsText
	)

	$session = Get-CvSessionObject

	$params = @{
		Endpoint   = [Uri]::new($session.ApiURL, $Endpoint)
		HttpClient = $session.httpClient
		Method     = $Method
	}

	if ($SearchParams) { $params.SearchParams = $SearchParams }
	if ($Body) { $params.Body = $Body }
	if ($AsText) { $params.ReturnRawResponse = $true }

	$response = Invoke-CvRequest @params

	if ($AsText) {
		$response = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
	}

	return $response
}
