#requires -Version 1 -Modules Pester
#requires -PSSnapin VMware.VimAutomation.Core

Describe -Name 'NTP Servers' -Fixture {
    foreach ($_ in (Get-VMHost)) 
    {
        It -name $($_.name) -test {
            $test = @('0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org', '3.pool.ntp.org')
            $value = Get-VMHostNtpServer -VMHost $_
            Compare-Object -ReferenceObject $test -DifferenceObject $value | Should Be $null
        }
    }
}