<#
.SYNOPSIS
Get-Moref retrieves moref information ESX,datastore,network from vCenter and export to html file and put into c:\temp.
.DESCRIPTION
Get-Moref use PowerCLI cmdlet to trieve list ESX,datastore,network from vCenter then look for moref of each ESX,datastore,network
.NOTEs
 Authors : VMware Avamar QA
 Date : 6/26/14
.PARAMETER vcenter
.PARAMETER username
.PARAMETER password
.PARAMETER output file html
.EXAMPLE
Get-Moref
#>

param (
    [parameter(mandatory=$true,HelpMessage="Enter FQDN vCenter  name or ip")]$vCenter,
    [parameter(mandatory=$true,HelpMessage="Enter vCenter username")]$username,
    [parameter(mandatory=$true,HelpMessage="Enter output filename you want")]$outfile=$vCenter
)

$password = Read-Host -assecurestring "Enter admin or root vcenter password"

# need to convert secure string to string
$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

Connect-VIServer -server $vcenter -username $username -password $decodedpassword

$esxhosts = get-view -viewtype hostsystem
$datastores = get-view -viewtype datastore
$network = get-view -viewtype network

# check if file html exists
if (Test-Path "c:\temp\$outfile.html"){
    remove-item -path "c:\temp\$outfile.html"
}


function getMoref {
    param($items)   
    $objs = @() 
    foreach ($item in $items){
        $obj = New-Object PSObject
        $obj | add-member -type NoteProperty -name vSphere_name -value $item.name
        $obj | add-member -type NoteProperty -name Moref -value $item.moref.value
        $objs += $obj
    }
    # write-host "parameter for vcenter is $vCenter"
    $objs | convertto-html | out-file -append "c:\temp\$outfile.html"
}

getMoref($esxhosts)
getMoref($datastores)
getMoref($network)
Disconnect-VIServer -server * -Confirm:$False

write-host "completed. you can check file html c:\temp\$outfile.html."