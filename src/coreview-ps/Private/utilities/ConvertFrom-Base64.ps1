function ConvertFrom-Base64 {
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([String])]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline)]
		[ValidateNotNullOrWhiteSpace()]
		[string]$Base64
	)

	process {
		# C# can only decode Base64 strings that are a multiple of 4 in length.
		# If the input string is not a multiple of 4, we need to pad it with '=':

		$paddingRequired = $Base64.Length % 4

		if ($paddingRequired -gt 0) {
			$Base64 += [String]::New('=', 4 - $paddingRequired)
		}

		return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Base64))
	}
}
