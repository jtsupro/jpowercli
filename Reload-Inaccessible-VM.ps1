<#
.SYNOPSIS
Reload-Inaccessible-VM finds inaccessible VM and reload them in vCenter
.DESCRIPTION
Reload-Inaccessible-VM find inaccessible VM and reload them in vCenter
.Notes
Author: VMware Avamar QA
Date: 7/15/14
.PARAMETER vCenter
.PARAMETER username
.EXAMPLE
Reload-Inaccessible-VM
#>

param (
    [parameter(mandatory=$true,HelpMessage="Enter FQDN vCenter name or ip")]$vcenter,
    [parameter(mandatory=$true,HelpMessage="Enter vCenter username")]$username
)

# read password star out
$password = Read-Host -assecurestring "Enter adminstrator or root vCenter password"

#need to convert secure string to string
$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

Connect-VIServer -server $vcenter -username $username -password $decodedpassword

$VMs = Get-View -ViewType VirtualMachine | ? {$_.Runtime.ConnectionState -eq "invalid" -or $_.Runtime.ConnectionState -eq "inaccessible"} | 
select name,@{Name="GuestConnectionState";E={$_.Runtime.ConnectionState}}

Write-Host "-------------------"
Write-Host "Inaccessible VM"
Write-Host "-------------------"

$VMs

#Reload VMs into the inventory
Get-View -ViewType VirtualMachine | ?{$VMs} | %{$_.reload()}

Disconnect-VIServer -server * -confirm:$FALSE