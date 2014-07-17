<#
.SYNOPSIS
Shutdown-VM power off all powered on VMs on specific vCenter.
.DESCRIPTION
Shutdown-VM looks for all powered on VMs and shut them down.
Notes
Author: VMware Avamar QA
Date: 7/15/14
.PARAMETER vcenter
.PARAMETER username
.PARAMETER password
.EXAMPLE
Shutdown-VM
#>

param (
    [parameter(mandatory=$true,HelpMessage="Enter FQDN vCenter name or ip")]$vCenter,
    [parameter(mandatory=$true,HelpMessage="Enter vCenter username")]$username
)

$password = Read-Host -assecurestring "Enter admin or root vCenter password"

# need to convert secure string to string
$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

Connect-VIServer -server $vCenter -username $username -password $decodedpassword

# Get list powered on VM and shut them down
Get-VM | where {$_.PowerState -eq "PoweredOn"}


Disconnect-VIServer -server * -confirm:$FALSE