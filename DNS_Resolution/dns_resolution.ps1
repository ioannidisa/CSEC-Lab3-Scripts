param (
    [Parameter(Mandatory = $true)]
    [string]
    $filename
)

<#
.SYNOPSIS
Script which will resolve dns based on the hostname from the input file 

.DESCRIPTION
The script will read the file content and try to resolve the DNS of the hostnames.
The script will only query for a "A" record. 

.PARAMETER filename 
Name of the file which contains hostnames

.NOTES
Author: Sunggwan Choi
Date: 10/8/2019

.EXAMPLE
PS C:\> ./dnsResolve.ps1 -filename <filename>
#>

if(Test-Path -Path $filename) {
    foreach($line in Get-Content $filename){
        try{
            $result = (Resolve-DnsName -type A -Name $line -ErrorAction 'ignore').IPAddress
        }
        catch {
            Write-Host $line': N/A'
            continue
        }
        if ($result -eq $null) { Write-Host $line'zz: N/A' ; continue}

        Write-Host $line':' $result
    }
}


