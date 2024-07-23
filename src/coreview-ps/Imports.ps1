Set-StrictMode -Version 3.0
$script:ErrorActionPreference = 'Stop'
$OutputEncoding = [System.Text.Encoding]::UTF8

$msgTable = Data {
	ConvertFrom-StringData @'
ContextInfoCompanyId = Company ID
ContextInfoCompanyName = Company name
ContextInfoCoreViewSection = CoreView Info
ContextInfoEnvironmentSection = Environment Info
ContextInfoModuleName = Module name
ContextInfoModuleVersion = Module version
ContextInfoOperatorName = Display name
ContextInfoOperatorRoles = Assigned roles
ContextInfoOperatorSection = Operator Info
ContextInfoOperatorUserId = User ID
ContextInfoOperatorUserName = User name
ContextInfoPortalAppName = Management portal name
ContextInfoPortalAppVersion = Management portal version
ContextInfoPSHostVersion = PowerShell host version
ContextInfoSessionAudience = Audience
ContextInfoSessionExpiry = Expiry
ContextInfoSessionId = Session ID
ContextInfoSessionSection = Session Info
CoreViewCredentialsRefused = The credentials provided to CoreView were refused by the API. Please ensure your API key is valid.
CoreViewDidNotGenerateJWT = Error while obtaining JWT from CoreView: the response does not contain a valid JWT
CoreViewEnvFileIsEmpty = The CoreView environment configuration file is empty
FetchingEnvironmentFileFromCoreView = Fetching the CoreView environment configuration file
LoginShouldProcess = Disconnecting any previous API connection and logging in to CoreView with the API key '{0}'
LoginSuccess = Successfully logged in to CoreView as '{0}'
MsgKeyNotFound = The message key '{0}' does not exist in the message table
OperationCancelled = The operation was cancelled by the user
RunCvContextForInfo = You may run the 'Get-CvSessionInfo' command to obtain details about the current session
SendingLoginRequestToCoreView = Sending a login request to CoreView
SessionNotInitialized = The session has not been initialized. Please run the 'Connect-CvAPI' command to log in to CoreView
UnableToObtainEnvFileFromCoreView = Unable to obtain the CoreView environment configuration file from the management portal
UnexpectedDataInCoreViewEnvFile = Unexpected data in the CoreView environment configuration file. Please update the JSON schema
'@
}
Import-LocalizedData -FileName 'i18n.psd1' -BindingVariable msgTable

function Get-Msg {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$MsgKey,

		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]
		$Substitutions = [System.Collections.ArrayList]::new()
	)

	if (-not $msgTable.ContainsKey($MsgKey)) {
		Write-ErrorMsg 'MsgKeyNotFound' $MsgKey
	}

	return $msgTable.$MsgKey -f ($Substitutions.ToArray())
}

function Add-PeriodIfNecessary {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$Msg
	)

	if (($msg.ToCharArray() | Select-Object -Last 1) -notin '?', '.', '!') {
		$msg += '.'
	}

	return $msg
}

function Write-ErrorMsg {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$MsgKey,

		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]
		$Substitutions = [System.Collections.ArrayList]::new()
	)

	Write-Error (Add-PeriodIfNecessary (Get-Msg -MsgKey $MsgKey @Substitutions)) -ErrorAction Stop
}

function Write-WarningMsg {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$MsgKey,

		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]
		$Substitutions = [System.Collections.ArrayList]::new(),

		[parameter(mandatory = $false, position = 2)]
		[switch]$Stop = $false
	)

	$warningAction = if ($Stop) { 'Stop' } else { 'Continue' }
	Write-Warning (Add-PeriodIfNecessary (Get-Msg -MsgKey $MsgKey @Substitutions)) -WarningAction $warningAction
}

function Write-InfoMsg {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$MsgKey,

		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]
		$Substitutions = [System.Collections.ArrayList]::new()
	)

	Write-Information (Add-PeriodIfNecessary (Get-Msg -MsgKey $MsgKey @Substitutions)) -InformationAction Continue
}

function Write-VerboseMsg {
	[CmdletBinding(ConfirmImpact = 'None')]
	Param
	(
		[parameter(mandatory = $true, position = 0)]
		[string]$MsgKey,

		[parameter(mandatory = $false, position = 1, ValueFromRemainingArguments = $true)]
		$Substitutions = [System.Collections.ArrayList]::new()
	)

	Write-Verbose (Add-PeriodIfNecessary (Get-Msg -MsgKey $MsgKey @Substitutions))
}
