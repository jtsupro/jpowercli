$choice = Read-Host 'Press 1 to select a VM, Press 2 to select a Cluster, press 3 to choose a Folder'

switch ($choice)
{
    1 {
        $vmName = Read-Host 'Please type in a VM name to reset CBT on'

        $vmInfo = Get-vm $vmName
        $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
        $spec.ChangeTrackingEnabled = $false

        $vmInfo.ExtensionData.ReconfigVM($spec)
        $snap = $vmInfo | New-Snapshot -Name 'Disable CBT'
        $snap | Remove-Snapshot -confirm:$False
    }

    2 {
        $vmName = Read-Host 'Please type in a cluster name to reset CBT on'

        $vmInfo = Get-Cluster $vmName | Get-vm
        $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
        $spec.ChangeTrackingEnabled = $false

        $vmInfo.ExtensionData.ReconfigVM($spec)
        $snap = $vmInfo | New-Snapshot -Name 'Disable CBT'
        $snap | Remove-Snapshot -confirm:$false
    }

    3 {
        $vmName = Read-Host 'Please type in a Folder name to reset CBT on.'

        $vmInfo = get-Folder $vmName | Get-vm
        $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
        $spec.ChangeTrackingEnabled = $false

        $vmInfo.ExtensionData.ReconfigVM($spec)
        $snap = $vmInfo | New-Snapshot -name 'Disable CBT'
        $snap | Remove-Snapshot -confirm:$False
    }
    default {Write-Host 'Invalid input, exiting ...'}
}