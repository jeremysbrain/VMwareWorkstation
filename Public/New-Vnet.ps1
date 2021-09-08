<#
.SYNOPSIS
Creates a new virtual network.

.DESCRIPTION
Creates a new virtual network.

.EXAMPLE
New-Vnet -Name 'TestNetwork' -Type 'HostOnly'
#>
function New-Vnet {
    [CmdletBinding()]
    param (
        # Vnet Name 
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('VmNet', 'Name')]
        [string]
        $Vnet,

        # Vnet Type (Host Only / NAT)
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('HostOnly', 'Nat')]
        [string]
        $Type
    )
    
    begin {
        if (-not $VMwareWsApi) {
            throw 'Not connected. Please run Connect-VMwareWorkstation first'
        }

        $ParamIrm = @{
            Header = $VMwareWsApi.Header
            Method = 'Post'
        }
    }
    
    process {
        $Endpoint = "vmnets"
            
        $Body = @{
            name = $Vnet
            type = $Type.ToLower()
        }
    
        $ParamIrm.Uri  = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)
    
        $Request = Invoke-RestMethod @ParamIrm

    }
    
    end {
        $Request
    }
}