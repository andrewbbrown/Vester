function Invoke-LabConfig-NTP
{
    <#  
            .SYNOPSIS
            !!!Fill Me In!!!
            .DESCRIPTION
            !!!Fill Me In!!!
            .NOTES
            Written by Chris Wahl for community usage
            Twitter: @ChrisWahl
            GitHub: chriswahl
            .LINK
            https://github.com/WahlNetwork/lab-config
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,Position = 0,HelpMessage = 'Pester Test')]
        [ValidateNotNullorEmpty()]
        $PesterResult
    )

    Process {

        foreach ($_ in $PesterResult.TestResult)
        {
            if ($_.Passed -eq $false)
            {
                $Server = Get-VMHost -Name $_.name
                Get-VMHostNtpServer -VMHost $Server | ForEach-Object -Process {
                    Remove-VMHostNtpServer -VMHost $Server -NtpServer $_ -Confirm:$false
                }
                Add-VMHostNtpServer -VMHost $Server -NtpServer @('0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org', '3.pool.ntp.org')
                $ntpclient = Get-VMHostService -VMHost $Server | Where-Object -FilterScript {
                    $_.Key -match 'ntpd'
                }
                $ntpclient | Set-VMHostService -Policy:On -Confirm:$false -ErrorAction:Stop
                $ntpclient | Restart-VMHostService -Confirm:$false -ErrorAction:Stop
            }
        }
    } # End of process
} # End of function