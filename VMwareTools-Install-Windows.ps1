<#
    Silent install VMwareTools on Windows
#>

Connect-VIServer -server "linuxvcenter3.irvineqa.local" -username "root" -password "changeme"
$GuestCred = Get-Credential Administrator
$VM = Get-VM 'win10-stax-1'

# Mount vmware tools iso
Mount-Tools -VM $VM

# Find the drive letter of the mounted media
# $DrvLetter = Get-WmiObject -Class 'Win32_CDROMDrive' `
#                            -ComputerName $VM.Name `
#                            -Credential $GuestCred |
#                            Where-Object ($_.VolumeName -match "VMware") |
#                            Select-Object -ExpandProperty Drive
# Build our cmd 
# $cmd = "$($DrvLetter)\setup.exe /S /v`"/qn
$cmd = "d:\setup.exe /S /v`"/qn
REBOOT=ReallySuppress ADDLOCAL=ALL`""
# spaw a new process on the remote VM and execute setup
$go = Invoke-WMIMethod -path win32_process `
    -Name Create `
    -Credential $GuestCred `
    -ComputerName $VM.Name `
    -ArgumentList $cmd

if ($go.ReturnValue -ne 0)
{
    Write-Warning "Installer return code $($go.ReturnValue) unmouting media!"
    Dismount-Tools -VM $VM
}
Else
{
    Write-Verbose "Tools installation successfully triggered on $($VM.Name) media will be ejected upon completion."
}
Disconnect-VIServer -server * -Confirm:$False