Set-StrictMode -Version 3.0
$script:ErrorActionPreference = 'Stop'
$OutputEncoding = [System.Text.Encoding]::UTF8

$msgTable = Data {
	ConvertFrom-StringData @'
CoreViewCredentialsRefused = The credentials provided to CoreView were refused by the API. Please ensure your API key is valid.
CoreViewDidNotGenerateJWT = Error while obtaining JWT from CoreView: the response does not contain a valid JWT
CoreViewEnvFileIsEmpty = The CoreView environment configuration file is empty
FetchingEnvironmentFileFromCoreView = Fetching the CoreView environment configuration file
LoginSuccess = Successfully logged in to CoreView as '{0}'
MsgKeyNotFound = The message key '{0}' does not exist in the message table
RunCvContextForInfo = You may run the 'Get-CvContext' command to obtain details about the current session
SendingLoginRequestToCoreView = Sending a login request to CoreView
SessionNotInitialized = The session has not been initialized. Please run the 'Connect-CvAPI' command to log in to CoreView
UnableToObtainEnvFileFromCoreView = Unable to obtain the CoreView environment configuration file from the management portal
UnexpectedDataInCoreViewEnvFile = Unexpected data in the CoreView environment configuration file. Please update the JSON schema
'@
}
Import-LocalizedData -FileName 'i18n.psd1' -BindingVariable msgTable

function Get-Msg {
	[CmdletBinding()]
	Param
	(
		[parameter(mandatory = $true, position = 0)][string]$MsgKey,
		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]$Substitutions
	)

	if (-not $msgTable.ContainsKey($MsgKey)) {
		Write-ErrorMsg 'MsgKeyNotFound' $MsgKey
	}

	$msg = $msgTable.$MsgKey -f ($Substitutions.ToArray())

	if (($msg.ToCharArray() | Select-Object -Last 1) -notin '?', '.', '!') {
		$msg += '.'
	}

	return $msg
}

function Write-ErrorMsg {
	[CmdletBinding()]
	Param
	(
		[parameter(mandatory = $true, position = 0)][string]$MsgKey,
		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]$Substitutions
	)

	Write-Error (Get-Msg -MsgKey $MsgKey @Substitutions) -ErrorAction Stop
}

function Write-InfoMsg {
	[CmdletBinding()]
	Param
	(
		[parameter(mandatory = $true, position = 0)][string]$MsgKey,
		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]$Substitutions
	)

	Write-Host (Get-Msg -MsgKey $MsgKey @Substitutions) -ForegroundColor Green
}

function Write-VerboseMsg {
	[CmdletBinding()]
	Param
	(
		[parameter(mandatory = $true, position = 0)][string]$MsgKey,
		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]$Substitutions
	)

	Write-Verbose (Get-Msg -MsgKey $MsgKey @Substitutions)
}
