Function Connect-vCenter {
  param(
    [String]$server="winvcenter5.irvineqa.local",
    [String]$user="administrator@vsphere.local",
    [String]$password="P3t3rPan@1"  
    )
  Connect-ViServer -server $server -user $user -password $password
}

Function Disconnect-vCenter {
  Disconnect-ViServer -server * -confirm:$False
}

Function Create-VM {
    <#
    .SYNOPSIS
      Create VM
    .DESCRIPTION
      The function will create VM
    .NOTES
      Source: Automating vSphere Administration
      Authors: Avamar VMware QA
      Date: 5/8/2014
    .PARAMETER VM
    .PARAMETER NUM
    .Example
      PS> Create-VM
    #>

  param(
     [String]$VM="vmtest", 
     [String]$ESXHOST="esxvcb3.asl.lab.emc.com",
     [String]$DATASTORE="iLUN0",
     [Int]$NUM,
     [Int]$STARTNO=1
     [String]$VLAN=244
  )    
  $NUM = $NUM + 1
  For ($i = $STARTNO; $i -lt $NUM;$i++) {
    New-VM -Name $VM$i -ResourcePool $ESXHOST -Datastore $DATASTORE -NumCPU 2 -MemoryGB 2 -DiskGB 2 -NetworkName "VLAN244" `
      -Floppy -CD -DiskStorageFormat Thin -GuestID winNetDatacenterGuest
  } 
}