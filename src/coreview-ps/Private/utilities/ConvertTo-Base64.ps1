function ConvertTo-Base64 {
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([String])]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline)]
		[ValidateNotNullOrWhiteSpace()]
		[string]$String
	)

	process {
		return [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($String))
	}
}
