function Expand-JWTClaims {
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([Hashtable])]
	param(
		[Parameter(Mandatory = $true)]
		[string]$JWT
	)

	process {
		KeepOnlyClaimsPart
		ConvertFromBase64UrlToBase64
		DecodeBase64
		ConvertJsonToHashtable
	}

	end {
		ReturnClaims
	}

	begin {
		$mutable = @{}

		function KeepOnlyClaimsPart {
			$mutable.base64 = $JWT.Trim().Split('.')[1]
		}

		function ConvertFromBase64UrlToBase64 {
			$mutable.base64 = Convert-Base64UrlToBase64 $mutable.base64
		}

		function DecodeBase64 {
			$mutable.claims = ConvertFrom-Base64 $mutable.base64
		}

		function ConvertJsonToHashtable {
			$mutable.claimsHt = ConvertFrom-Json $mutable.claims -AsHashtable -Depth 3 -ErrorAction Stop
		}

		function ReturnClaims {
			return [Hashtable]$mutable.claimsHt
		}
	}
}
