
# check if ports are specified as a command line arg

if ($Args.Count -le 1){
	throw "Error: Ports not specified"
}

$ip = $Args[0]
$ports = $Args[1]

$open = 0
if($ports -Match "-"){
	$items = $ports.Split("-")
	$begin = [int]$items[0]
	$end = [int]$items[1]

	$ErrorActionPreference = "SilentlyContinue"
	while($begin -le $end){
		$conn = New-Object System.Net.Sockets.TcpClient($ip, $begin) 
		if($conn.Connected){
			Write-Host "Port $begin is open"
			$open++
		}
		$begin++
	}
	if ($open -lt 1){
		Write-Host "No Open Ports on this Host!"
	}
}
else{
	$portarray = "$ports".Split(" ") 
	$i = 0
	$ErrorActionPreference = "SilentlyContinue"
	while ($i -lt $portarray.Count){
		$port = $ports[$i]
		$conn = New-Object System.Net.Sockets.TcpClient($ip, [int]$port) 
		if($conn.Connected){
			Write-Host "Port $port is open"
			$open++
		}
		$i++
	}
	if ($open -lt 1){
		Write-Host "No Open Ports on this Host!"
	}
}
