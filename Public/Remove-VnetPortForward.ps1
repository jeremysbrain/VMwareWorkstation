<#
.SYNOPSIS
Removes a port forwarding setting for a specified virtual network.

.DESCRIPTION
Removes a port forwarding setting for a specified virtual network.  

.EXAMPLE
Remove-VnetPortForward -Vnet vmnet1 -SourcePort 8080 -Protocol tcp
#>
function Remove-VnetPortForward {
    [CmdletBinding()]
    param (
        # Vnet Name 
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('VmNet', 'Name')]
        [string]
        $Vnet,

        # Source Port Number
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Port')]
        [int]
        $SourcePort,
        
        # Source and Destination Protocol (TCP/UDP)
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('tcp', 'udp')]
        [string]
        $Protocol
    )
    
    begin {
        if (-not $VMwareWsApi) {
            throw 'Not connected. Please run Connect-VMwareWorkstation first'
        }

        $ParamIrm = @{
            Header = $VMwareWsApi.Header
            Method = 'Delete'
        }
    }
    
    process {
        $Endpoint = "vmnet/$Vnet/portforward/$Protocol/$SourcePort"
    
        $ParamIrm.Uri  = "$($VMwareWsApi.BaseUri)/$EndPoint"
    
        $Request = Invoke-RestMethod @ParamIrm

    }
    
    end {
        $Request
    }

}