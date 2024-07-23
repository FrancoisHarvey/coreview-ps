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
	Describe 'ConvertTo-Hashtable Private Function Tests' -Tag Unit {
		BeforeAll {
			$WarningPreference = 'SilentlyContinue'
			$ErrorActionPreference = 'SilentlyContinue'
		}
		Context 'Error' {
		}
		Context 'Success' {
			It 'should should return a Hashtable when given a PSCustomObject' {
				$PSO = [PSCustomObject]@{
					foo = 123
				}
				Should -ActualValue (ConvertTo-Hashtable $PSO) -BeOfType System.Collections.Hashtable
			}

			It 'should should return a string when given a string' {
				Should -ActualValue (ConvertTo-Hashtable 'abc') -BeOfType System.String
			}

			It 'should should return an integer when given an integer' {
				(ConvertTo-Hashtable 123).GetType().Name -in 'Int32', 'Int64' | Should -BeTrue
			}

			It 'should should return an array when given an array' {
				Should -ActualValue (ConvertTo-Hashtable @(,123)) -BeOfType System.Array
			}

			It 'should should return an array when given an arraylist' {
				Should -ActualValue (ConvertTo-Hashtable ([System.Collections.ArrayList]@(,123))) -BeOfType System.Array
			}

			It 'should return an array when given a Set' {
				$Set = [System.Collections.Generic.HashSet[string]]::new()
				$Set.Add('foo')
				$Set.Add('bar')
				Should -ActualValue (ConvertTo-Hashtable $Set) -BeOfType System.Array
			}

			It 'should return an array when given a List' {
				$List = [System.Collections.Generic.List[string]]::new()
				$List.Add('foo')
				$List.Add('bar')
				Should -ActualValue (ConvertTo-Hashtable $List) -BeOfType System.Array
			}

			It 'should return a hashtable when given a dictionary' {
				$Dict = [System.Collections.Generic.Dictionary[string,string]]::new()
				$Dict.Add('foo', 'bar')
				Should -ActualValue (ConvertTo-Hashtable $Dict) -BeOfType System.Collections.Hashtable
			}

			It 'should return a hashtable when given a hashtable' {
				$HT = @{}
				$HT.Add('foo', 'bar')
				Should -ActualValue (ConvertTo-Hashtable $HT) -BeOfType System.Collections.Hashtable
			}

			It 'should recursively convert to a hashtable when given a nested object' {
				$PSO = [PSCustomObject]@{
					foo = [PSCustomObject]@{
						bar = 123
					}
				}
				$HT = ConvertTo-Hashtable $PSO
				Should -ActualValue $HT['foo'] -BeOfType System.Collections.Hashtable
			}

			It 'should converted nested objects of a hashtable' {
				$HT = @{}
				$HT.Add('foo', [PSCustomObject]@{
					bar = 123
				})
				$HT = ConvertTo-Hashtable $HT
				Should -ActualValue $HT['foo'] -BeOfType System.Collections.Hashtable
			}

			It 'should convert nested objects of a dictionary' {
				$Dict = [System.Collections.Generic.Dictionary[string,object]]::new()
				$Dict.Add('foo', [PSCustomObject]@{
					bar = 123
				})
				$Dict = ConvertTo-Hashtable $Dict
				Should -ActualValue $Dict['foo'] -BeOfType System.Collections.Hashtable
			}

			It 'should convert nested objects of a list' {
				$List = [System.Collections.Generic.List[object]]::new()
				$List.Add([PSCustomObject]@{
					bar = 123
				})
				$List = ConvertTo-Hashtable $List
				Should -ActualValue $List[0] -BeOfType System.Collections.Hashtable
			}

			It 'should leave a date object as is' {
				$Date = Get-Date
				Should -ActualValue (ConvertTo-Hashtable $Date) -Be $Date
			}
		}
	}
}
