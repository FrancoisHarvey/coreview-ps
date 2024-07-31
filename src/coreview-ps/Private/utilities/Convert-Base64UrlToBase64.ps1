function Convert-Base64UrlToBase64 {
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([String])]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline)]
		[ValidateNotNullOrWhiteSpace()]
		[string]$B64Url
	)

	process {
		return $B64Url.Replace('-', '+').Replace('_', '/')
	}
}
