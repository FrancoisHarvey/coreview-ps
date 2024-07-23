function ConvertTo-Base64 {
	[CmdletBinding()]
	[OutputType([String])]
	param(
		[Parameter(Mandatory = $true)]
		[string]$String
	)

	return [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($String))
}
