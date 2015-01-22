$esxes = @("a3dpe293.asl.lab.emc.com", "esxvcb1.asl.lab.emc.com",
          "esxvcb2.asl.lab.emc.com", "esxvcb3.asl.lab.emc.com",
          "esxvcb4.asl.lab.emc.com", "esxvcb5.asl.lab.emc.com", 
          "qa-esx-17.asl.lab.emc.com", "qa-esx-18.asl.lab.emc.com",
          "qa-esx-18.asl.lab.emc.com", "qa-esx-19.asl.lab.emc.com",
          "qa-esxi-01.asl.lab.emc.com", "qa-esxi-02.asl.lab.emc.com",
          "qa-esxi-03.asl.lab.emc.com", "qa-esxi-04.asl.lab.emc.com",
          "qa-esxi-05.asl.lab.emc.com","dpe95.asl.lab.emc.com", "qa-cliesx05.asl.lab.emc.com")

foreach ($esx in $esxes) {
    write-output "shutdown $esx ..."
    Connect-VIServer -server $esx -username "root" -password "changeme"
    stop-vmhost $esx -confirm:$false -force
}          