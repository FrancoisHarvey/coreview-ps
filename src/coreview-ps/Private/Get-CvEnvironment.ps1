$script:CV_ENVIRONMENT_JSON = 'https://app.coreview.com/assets/configuration/environment.json'
$script:COREVIEW_REGION = 'CAE'

$script:CV_ENVIRONMENT_SCHEMA = @'
{
    "$schema": "http://json-schema.org/draft-06/schema#",
    "$ref": "#/definitions/CoreViewEnv",
    "definitions": {
        "CoreViewEnv": {
            "type": "object",
            "additionalProperties": true,
            "properties": {
                "name": {
                    "type": "string"
                },
                "baseAuthUrl": {
                    "type": "string",
                    "format": "uri",
                    "qt-uri-protocols": [
                        "https"
                    ]
                },
                "baseCommunicationUrl": {
                    "$ref": "#/definitions/BaseCommunicationURL"
                },
                "workflowUrlV2": {
                    "$ref": "#/definitions/BaseCommunicationURL"
                },
                "baseCentralUrl": {
                    "type": "string",
                    "format": "uri",
                    "qt-uri-protocols": [
                        "https"
                    ]
                },
                "appVersion": {
                    "type": "string"
                }
            },
            "required": [
                "appVersion",
                "baseAuthUrl",
                "baseCentralUrl",
                "baseCommunicationUrl",
                "name",
                "workflowUrlV2"
            ],
            "title": "CoreViewEnv"
        },
        "BaseCommunicationURL": {
            "type": "object",
            "additionalProperties": true,
            "properties": {
                "EU": {
                    "type": "string",
                    "format": "uri",
                    "qt-uri-protocols": [
                        "https"
                    ]
                },
                "EUS": {
                    "type": "string",
                    "format": "uri",
                    "qt-uri-protocols": [
                        "https"
                    ]
                },
                "CAE": {
                    "type": "string",
                    "format": "uri",
                    "qt-uri-protocols": [
                        "https"
                    ]
                },
                "AUS": {
                    "type": "string",
                    "format": "uri",
                    "qt-uri-protocols": [
                        "https"
                    ]
                }
            },
            "required": [
                "CAE",
                "EU",
                "EUS"
            ],
            "title": "BaseCommunicationURL"
        }
    }
}
'@

function Get-CvEnvironment {
	<#
	.SYNOPSIS
		Obtains the static environment configuration for CoreView.
	#>
	[CmdletBinding()]
	[OutputType([hashtable])]
	param ()

	process {
		if (-not (CacheExists)) {
			FetchEnvFromManagementPortal
			ValidateAgainstSchema
			ConvertToHashtable
			ConvertURLsToUriObjects
			CreateCache
		}
	}

	end {
		ReturnAsHashtable
	}

	begin {
		$mutable = @{
			JsonContent = $null
		}

		function CacheExists {
			return (Test-Path Variable:script:CvEnvironmentCache)
		}

		function FetchEnvFromManagementPortal {
			Write-VerboseMsg FetchingEnvironmentFileFromCoreView

			$req = @{
				Uri              = $CV_ENVIRONMENT_JSON
				Method           = 'GET'
				UseBasicParsing  = $true
				DisableKeepAlive = $true
				TimeoutSec       = 10
			}
			$reponse = (Invoke-WebRequest @req -ErrorAction Stop)

			if (-not $reponse -or $reponse.StatusCode -notin 200..299) {
				Write-ErrorMsg UnableToObtainEnvFileFromCoreView
			}

			$mutable.JsonContent = $reponse.Content
		}

		function ConvertToHashtable {
			$ht = $mutable.JsonContent | Convert-JsonToHashtable -ErrorAction Stop

			if (-not $ht) {
				Write-ErrorMsg UnexpectedDataInCoreViewEnvFile
			}

			$mutable.JsonContent = $ht
		}

		function ValidateAgainstSchema {
			Test-Json -ErrorAction Stop -Json $mutable.JsonContent -Schema $CV_ENVIRONMENT_SCHEMA | Out-Null
		}

		function ConvertURLsToUriObjects {
			foreach ($kv in $mutable.JsonContent.Clone().GetEnumerator()) {
				if ($kv.Value -is [String] -and $kv.Value.StartsWith('https:')) {
					$mutable.JsonContent.($kv.Name) = [Uri]::New($kv.Value)
				}
				elseif ($kv.Value -is [Hashtable]) {
					$kv.Value.Clone().GetEnumerator() | ForEach-Object {
						if ($_.Value -is [String] -and $_.Value.StartsWith('https:')) {
							$mutable.JsonContent.($kv.Name).($_.Name) = [Uri]::New($_.Value)
						}
					}
				}
			}
		}

		function CreateCache {
			$script:CvEnvironmentCache = $mutable.JsonContent
		}

		function ReturnAsHashtable {
			if (-not $script:CvEnvironmentCache) {
				Write-ErrorMsg CoreViewEnvFileIsEmpty
			}

			return $script:CvEnvironmentCache
		}
	}
}
