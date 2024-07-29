$script:CvTranslationsCache = @{}

function Get-CvTranslations {
	[CmdletBinding()]
	[OutputType([hashtable])]
	param (
	)

	process {
		ObtainLanguageCode

		if (CacheExists) {
			return ReturnTranslationsFromCache
		}

		ObtainTranslationsFromCoreView
		AddTranslationsToCache
		ReturnTranslationsFromCache
	}

	begin {
		$mutable = @{}

		function ObtainLanguageCode {
			$mutable.Language = Get-CvLanguage
		}

		function CacheExists {
			return $script:CvTranslationsCache.ContainsKey($mutable.Language)
		}

		function ReturnTranslationsFromCache {
			return $script:CvTranslationsCache[$mutable.Language]
		}

		function ObtainTranslationsFromCoreView {
			$translations = Invoke-CvRestMethod -Endpoint "api/v2/translations/all/$($mutable.Language)"
			$mutable.Translations = $translations.translation.translationItems
		}

		function AddTranslationsToCache {
			$script:CvTranslationsCache[$mutable.Language] = $mutable.Translations
		}
	}
}
