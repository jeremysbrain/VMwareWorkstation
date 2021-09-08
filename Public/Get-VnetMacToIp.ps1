<#
.SYNOPSIS
Retrieves a list of static dhcp bindings for the specified virtual network.

.DESCRIPTION
Retrieves the list of MAC addresses and their assigned IP addresses.  This configuration is found in the vmnetdhcp.conf file and unfortunately cannot be accessed from the GUI.
NOTE: This endpoint may not be working.  Further testing needed.

.EXAMPLE
Get-VnetMacToIp -Vnet vmnet1

.EXAMPLE
Get-VnetList | Get-VnetMacToIp
#>
function Get-VnetMacToIp {
    [CmdletBinding()]
    param (
        # Vnet Name 
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('VmNet','Name')]
        [string[]]
        $Vnet
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
        foreach ($VnetItem in $Vnet) {
            $Endpoint = "vmnet/$VnetItem/mactoip"
            
            $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"

            $Request += Invoke-RestMethod @ParamIrm | Select-Object -ExpandProperty mactoips
        }
    }
    
    end {
        $Request
    }
}