#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'coreview-ps'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
	#if the module is already in memory, remove it
	Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'coreview-ps' {
	#-------------------------------------------------------------------------
	$WarningPreference = "SilentlyContinue"
	#-------------------------------------------------------------------------
	Describe 'Add-PeriodIfNecessary Private Function Tests' -Tag Unit {
		BeforeAll {
			$WarningPreference = 'SilentlyContinue'
			$ErrorActionPreference = 'SilentlyContinue'
		}
		Context 'Error' {
			It 'should not add periods to strings ending with a period' {
				$msg = Add-PeriodIfNecessary 'foo.'
				$msg | Should -BeExactly 'foo.'
			}
			It 'should not add periods to strings ending with a question mark' {
				$msg = Add-PeriodIfNecessary 'foo?'
				$msg | Should -BeExactly 'foo?'
			}
			It 'should not add periods to strings ending with an exclamation mark' {
				$msg = Add-PeriodIfNecessary 'foo!'
				$msg | Should -BeExactly 'foo!'
			}
			It 'should not add periods to strings ending with a period and then whitespace' {
				$msg = Add-PeriodIfNecessary 'foo. '
				$msg | Should -BeExactly 'foo. '
			}
		}
		Context 'Success' {
			It 'should a period to strings without terminating punctuation' {
				$msg = Add-PeriodIfNecessary 'foo'
				$msg | Should -BeExactly 'foo.'
			}
		}
	}
}
