$script:CV_ENVIRONMENT_JSON = 'https://app.coreview.com/assets/configuration/environment.json'
$script:COREVIEW_REGION = 'CAE'


function Get-CvEnvironment {
	<#
	.SYNOPSIS
		Obtient la configuration statique d'environnement de CoreView

	.DESCRIPTION
		Cette configuration permet d'obtenir les URLs à utiliser pour les APIs.
	#>
	[CmdletBinding()]
	[OutputType([hashtable])]
	param ()

	process {
		if (-not (CacheExiste)) {
			ObtenirEnvironnementJSON
			ConvertirEnHashtable
			ValiderSchema
			ConvertirUrlsEnObjetsUri
			CreerCache
		}
	}

	end {
		RetournerJson
	}

	begin {
		$mutable = @{
			ContenuJson = $null
		}

		function CacheExiste {
			return (Test-Path Variable:script:CacheEnvironnementCv)
		}

		function ObtenirEnvironnementJSON {
			$req = @{
				Uri              = $CV_ENVIRONMENT_JSON
				Method           = 'GET'
				UseBasicParsing  = $true
				DisableKeepAlive = $true
				TimeoutSec       = 10
			}
			$reponse = (Invoke-WebRequest @req -ErrorAction Stop)

			if (-not $reponse) {
				Write-Error 'Impossible d''obtenir le fichier de configuration d''environnement CoreView' -ErrorAction Stop
			}

			$mutable.ContenuJson = $reponse.Content
		}

		function ConvertirEnHashtable {
			$ht = $mutable.ContenuJson | Convert-JsonToHashtable -ErrorAction Stop

			if (-not $ht) {
				Write-Error 'Le fichier de configuration d''environnement CoreView est malformé' -ErrorAction Stop
			}

			$mutable.ContenuJson = $ht
		}

		function ValiderSchema {
			Test-HtSchema -ErrorAction Stop -Obj $mutable.ContenuJson -Schema @{
				baseAuthUrl   = [String]
				workflowUrlV2 = @{
					CAE = [String]
				}
			} -Contexte "Validation du fichier d'environnement CoreView: ${CV_ENVIRONMENT_JSON}" | Out-Null
		}

		function ConvertirUrlsEnObjetsUri {
			foreach ($kv in $mutable.ContenuJson.Clone().GetEnumerator()) {
				if ($kv.Value -is [String] -and $kv.Value.StartsWith('https:')) {
					$mutable.ContenuJson.($kv.Name) = [Uri]::New($kv.Value)
				}
				elseif ($kv.Value -is [Hashtable]) {
					$kv.Value.Clone().GetEnumerator() | ForEach-Object {
						if ($_.Value -is [String] -and $_.Value.StartsWith('https:')) {
							$mutable.ContenuJson.($kv.Name).($_.Name) = [Uri]::New($_.Value)
						}
					}
				}
			}
		}

		function CreerCache {
			$script:CacheEnvironnementCv = $mutable.ContenuJson
		}

		function RetournerJson {
			if (-not $script:CacheEnvironnementCv) {
				Write-Error 'Le cache d''environnement CoreView est vide' -ErrorAction Stop
			}

			return $script:CacheEnvironnementCv
		}
	}
}
