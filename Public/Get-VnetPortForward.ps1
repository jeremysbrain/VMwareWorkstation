<#
.SYNOPSIS
Retrieves port forwarding information for the specified virtual networks.

.DESCRIPTION
Retrieves port forwarding information for the specified virtual networks.  The type of the specified virtual network must be NAT.

.EXAMPLE
Get-VnetList | Get-VnetPortForward
#>
function Get-VnetPortForward {
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
            $Endpoint = "vmnet/$VnetItem/portforward"
            
            $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"

            $Request += Invoke-RestMethod @ParamIrm | Select-Object -ExpandProperty port_forwardings
        }
    }
    
    end {
        $Request
    }
}