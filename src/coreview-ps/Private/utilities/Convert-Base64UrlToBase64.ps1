function Convert-Base64UrlToBase64 {
	[CmdletBinding()]
	[OutputType([String])]
	param(
		[Parameter(Mandatory = $true)]
		[string]$B64Url
	)

	return $B64Url.Replace('-', '+').Replace('_', '/')
}
