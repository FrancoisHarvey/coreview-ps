function Format-Hyperlink {
	[CmdletBinding()]
	[OutputType([string])]
	param(
		[Parameter(ValueFromPipeline = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[Uri] $Uri,

		[Parameter(Mandatory = $false, Position = 1)]
		[ValidateNotNullOrWhiteSpace()]
		[string] $Label
	)

	process {
		if (-not $Label) {
			$Label = $Uri
		}

		if ($Env:WT_SESSION) {
			$escapeSequence = [char]27
			return "${escapeSequence}]8;;${Uri}${escapeSequence}\${Label}${escapeSequence}]8;;${escapeSequence}\"
		}
		return (Get-Msg UriWithLabel $Uri $Label)
	}
}
