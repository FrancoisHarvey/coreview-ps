$script:CoreViewSupportedLanguages = 'en', 'de', 'es', 'fr', 'it', 'ja'

function Get-CvLanguage {
	[CmdletBinding()]
	param (
	)

	# We could use the OperatorPreferredLanguage from the session, but it makes
	# more sense to use the ui culture language, since the translation system
	# already uses it

	$uiCulture = (Get-UICulture).TwoLetterISOLanguageName

	if ($script:CoreViewSupportedLanguages -inotcontains $uiCulture) {
		$uiCulture = 'en'
	}

	return $uiCulture
}
