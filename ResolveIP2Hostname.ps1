
if ($Args.Count -lt 1){
	throw "Error: File not specified"
}

$ip = $Args[0]

$listofIPs = Get-Content -Path $ip

#create a blank array for resolved names
$ResultList = @()
 
# resolve each
foreach ($ip in $listofIPs){
     $result = $null
     $currentEAP = $ErrorActionPreference
     $ErrorActionPreference = "silentlycontinue"

     #Use the DNS Static .Net class for the reverse lookup

     $result = [System.Net.Dns]::gethostentry($ip).Hostname
     $ErrorActionPreference = $currentEAP

     If ($Result){
          Write-Host "IP: $ip      Hostname:$result.Hostname"
     }
     Else{
          Write-Host "IP: $IP - No Hostname Found"
     }
}
