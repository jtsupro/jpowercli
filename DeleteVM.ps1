<#
. delete VM with disk
#>

#Connect-VIServer -server "linuxvcenter3.irvineqa.local" -username "root" -password "changeme" 
Connect-VIServer -server "winvcenter2.irvineqa.local" -username "administrator@vsphere.local" -password "P3t3rPan@1" 
Get-VM "restore*" | Stop-VM
Get-VM "restore*" | Remove-VM -DeletePermanently
Disconnect-VIServer -server * -Confirm:$False
