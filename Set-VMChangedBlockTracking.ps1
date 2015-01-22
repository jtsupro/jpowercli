function Load-PowerCLISnapin{
    #Load Required VMware Snapin if not already loaded
    if (!(Get-PSSnapin VMware.vimautomation.core -erroraction SilentlyContinue)) {
        #Throw error if not installed
        if (!(Get-pssnapin -registered vmware.vimautomation.core)) {
            write-error "VMware PowerCLI not installed. Please install VMware PowerCLI and try again"
            exit
        }
        #Load the Snapin
        Add-PSSnapin vmware.vimautomation.core

    }
}

Connect-VIServer -Server vcenter-server.domain.local -Protocol https

function Set-VMChangedBlockTracking {
<#
.SYNOPSIS
     Enables or disables Changed Block Tracking on a Virtual Machine
.DESCRIPTION
     This function will enable or disable CBT on a VM, and optionally apply the change by stunning the VM with a snapshot. It is useful when CBT needs to be reset or disabled en masse. 

.EXAMPLE 
     Disable CBT on virtual machine and apply it, confirming the action first.

set-vmchangedblocktracking VM-NAME -enabled:$false -applynow -confirm:$true

.EXAMPLE 
     Get all virtual machines with CBT disabled, enable it, and apply it.

Get-VM | where {$_.ExtensionData.config.ChangeTrackingEnabled} | Set-VMChangedBlockTracking -enabled:$true -applynow

.LINK
     http://www.robertwmartin.com/?p=274
.PARAMETER VMNames
     The Virtual Machines to set CBT on. Accepts Virtual Machine Objects or one or more virtual machine names.
.PARAMETER Disabled
Specifies whether to enable or disable CBT. CBT does not apply until a VM stun action such as a snapshot or restart occurs unless the -applynow option is specified
.PARAMETER ApplyNow
Specifies whether to enable CBT immediately stun the VM by creating and subsequently deleting a VM snapshot on the VM 
#>

[CmdletBinding(SupportsShouldProcess)]

Param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$True,Position=0)]
    [string[]]$VMNames,

    #Enable or Disable CBT on the VM
    [Parameter(Mandatory=$true)]
    [Boolean] $Enabled,

    #Apply the setting by taking a snapshot and removing it.
    [Parameter(Mandatory=$false)]
    [Switch] $ApplyNow
)

BEGIN {
    #Load Required VMware Snapin if not already loaded
    if (!(Get-PSSnapin VMware.vimautomation.core -erroraction SilentlyContinue)) {
        #Throw error if not installed
        if (!(Get-pssnapin -registered vmware.vimautomation.core)) {
            write-error "VMware PowerCLI not installed. Please install VMware PowerCLI and try again"
            exit
        }
        #Load the Snapin
        Add-PSSnapin vmware.vimautomation.core
    }

    #Create a spec to enable/disable CBT based on the setting
    $spec = New-Object VMware.Vim.VirtualMachineConfigSpec 
    $spec.ChangeTrackingEnabled = $Enabled
}

PROCESS {
    foreach ($VMName in $VMNames) {
        $vm = get-vm $VMName

        #Specify Should Process
        if ($Enabled) {$CBTAction = "Enable"} else {$CBTAction = "Disable"}

        if($PSCmdlet.ShouldProcess($VMName,"$CBTAction Changed Block Tracking")) {

        #Apply CBT Change
        write-verbose "Apply CBT Configuration: $($Enabled) to $VMName"
        $vm.ExtensionData.ReconfigVM($spec)

        #If enabled, stun VM with a snapshot to enable CBT

        if ($ApplyNow) {
            write-verbose "Applying CBT by stunning $($vm.ToString())"
            $snap=$vm | New-Snapshot -Name 'Disable CBT Temporary' 
            $snap | Remove-Snapshot -confirm:$false
        }
        }
    }

}

}

Get-VM | where {$_.ExtensionData.config.ChangeTrackingEnabled} | Set-VMChangedBlockTracking -enabled:$true -applynow