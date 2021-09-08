<#
.SYNOPSIS
Updates the type and connection of a VM NIC.

.DESCRIPTION
Updates the type of VmNic and virtual network the NIC is connected to.

.EXAMPLE
Update-VmNic -Id 'F933AFAA165C4032A7A04CF489923AC4' -Type 'HostOnly'
#>
function Update-VmNic {
    [CmdletBinding()]
    param (
        # ID of VM to update VmNic
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Id,

        # Index of VmNic to update
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Index,

        # Updated type of VmNic.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Bridged', 'Nat', 'Custom', 'HostOnly')]
        [VmNicType]
        $Type,

        # Name of Vnet to connect to.  Only used when the Type is Custom.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]
        $Vnet
    )
    
    begin {
        if (-not $VMwareWsApi) {
            throw 'Not connected. Please run Connect-VMwareWorkstation first'
        }

        $ParamIrm = @{
            Header = $VMwareWsApi.Header
            Method = 'put'
        }
    }
    
    process {
        $Endpoint = "vms/$id/nic/$index"

        $Body = @{ }
        $Body.type = $Type.ToLower()

        if ($Type -eq 'Custom') {
            $Body.vmnet = $Vnet
        }
        else {
            if ($Vnet) {
                Write-Warning -Message "Vnet is only applied when Type is Custom.  Vnet value of $Vnet will be ignored."
            }
        }

        $ParamIrm.Uri  = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)
    
        $Request = Invoke-RestMethod @ParamIrm
    }
    
    end {
        $Request
    }
}