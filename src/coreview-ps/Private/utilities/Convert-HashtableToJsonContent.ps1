$script:JsonUtf8MediaType = [System.Net.Http.Headers.MediaTypeHeaderValue]::new('application/json')
$script:JsonUtf8MediaType.CharSet = 'utf-8'
$script:DefaultJsonOptions = [System.Text.Json.JsonSerializerOptions]::new()

function Convert-HashtableToJsonContent {
	[CmdletBinding()]
	[OutputType([System.Net.Http.Json.JsonContent])]
	param (
		[Parameter(Mandatory = $true)]
		[Hashtable]$Hashtable
	)

	return [System.Net.Http.Json.JsonContent]::Create($Hashtable, [hashtable], $JsonUtf8MediaType, $DefaultJsonOptions)
}
