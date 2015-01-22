$esxes = @("a3dpe293.asl.lab.emc.com", "esxvcb1.asl.lab.emc.com",
          "esxvcb2.asl.lab.emc.com", "esxvcb3.asl.lab.emc.com",
          "esxvcb4.asl.lab.emc.com", "esxvcb5.asl.lab.emc.com", 
          "qa-esx-17.asl.lab.emc.com", "qa-esx-18.asl.lab.emc.com",
          "qa-esx-19.asl.lab.emc.com", "qa-esx-20.asl.lab.emc.com",
          "qa-esxi-01.asl.lab.emc.com", "qa-esxi-02.asl.lab.emc.com",
          "qa-esxi-03.asl.lab.emc.com", "qa-esxi-04.asl.lab.emc.com",
          "qa-esxi-05.asl.lab.emc.com","dpe95.asl.lab.emc.com")

foreach ($esx in $esxes) {
    write-output "search VM ..."
    Connect-VIServer -server $esx -username "root" -password "changeme"
    Write-output "connected successful."
    # Get-VM | where {$_.Name -eq "proxy20*"} | Start-VM
    try {
      Get-VM "vmwareqa*" -ErrorAction Stop | Start-VM
      write-output "This VM on $esx host"
    }
    catch {
      return
    }
    
    Disconnect-viserver -server $esx -confirm:$false
}          