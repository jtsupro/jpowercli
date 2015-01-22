
# create linked clone VM
# Manually create VM , load os , power on , take snapshot, power off VM
# make sure you don't have 2 master VM with same name

connect-viserver -server "winvcenter5.irvineqa.local" -user administrator@vsphere.local -password P3t3rPan@1

$sourceVM = Get-VM "rhel6-master" | Get-View
$cloneName = "linked_clone_rhel6"
$cloneFolder = $sourceVM.parent

$cloneSpec = new-object VMware.Vim.VirtualMachineCloneSpec
$cloneSpec.Snapshot = $sourceVM.Snapshot.CurrentSnapshot

$cloneSpec.Location = new-object VMware.Vim.VirtualMachineRelocateSpec
$cloneSpec.Location.DiskMoveType = [VMware.Vim.VirtualMachineRelocateDiskMoveOptions]::createNewChildDiskBacking

$sourceVM.CloneVM_Task($cloneFolder, $cloneName, $cloneSpec)

disconnect-viserver -server * -confirm:$False



