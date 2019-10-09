$ip = $args[0]

$listofIPs = Get-Content $ip

#create a blank array for resolved names
$ResultList = @()
 
# resolve each
foreach ($ip in $listofIPs){
     $result = $null
     $currentEAP = $ErrorActionPreference
     $ErrorActionPreference = "silentlycontinue"

     #Use the DNS Static .Net class for the reverse lookup

     $result = [System.Net.Dns]::gethostentry($ip)
     $ErrorActionPreference = $currentEAP

     If ($Result){
          $Resultlist += [string]$Result.HostName
     }Else{
          $Resultlist += "$IP - No HostNameFound"
     }
}

#write output
Write-Host $ResultList