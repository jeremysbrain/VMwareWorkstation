<#
.SYNOPSIS
Returns an ip address associated with a VM.

.DESCRIPTION
Returns a single ip address associated with a VM.  This appears to be the address associated with the VM Nic at Index 1.

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | Get-VmIpAddress
#>
function Get-VmIpAddress {
    [CmdletBinding()]
    param (
        # ID of VM to retrieve IP Address information
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Id        
        
    )
    
    begin {
        if (-not $VMwareWsApi) {
            throw 'Not connected. Please run Connect-VMwareWorkstation first'
        }

        $ParamIrm = @{
            Header = $VMwareWsApi.Header
            Method = 'Get'
        }

        $Request = @()
    }
    
    process {
        foreach ($IdItem in $Id) {
            $Endpoint = "vms/$IdItem/ip"
            
            $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"

            $Request += Invoke-RestMethod @ParamIrm
        }
    }
    
    end {
        $Request
    }
}