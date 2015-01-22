<#
    . Copy files into VMGuest
#>

Connect-VIserver -server "linuxvcenter3.irvineqa.local" -username "root" -password "changeme"
$vm = Get-VM -Name 'win7-stax-1'
Get-Item "z:\Kevin\staf-stax\STAXV3511.zip" | Copy-VMGuestFile -Destination "c:\Users\qauser" -VM $vm -LocalToGuest -GuestUser qauser -GuestPassword P3t3rPan
Disconnect-VIServer -server * -Confirm:$FALSE