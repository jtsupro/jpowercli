<#
    Move VM to specific folder
#>

Connect-VIServer -server "linuxvcenter3.irvineqa.local" -username "root" -password "changeme"
# Get-VM -name *stax* | Move-VM -Destination "STAF/STAX-experiment"
# Get-VM -name "proxy*" | Move-VM -Destination "proxy"
Get-VM -name proxy* | Move-VM -Destination "proxyFolder"

Disconnect-VIServer -server * -Confirm:$False