function Get-CvTranslationString {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]$Key
	)

	$allStrings = Get-CvTranslations

	if (-not $allStrings.ContainsKey($Key)) {
		return $null
	}

	return $allStrings[$Key]
}
