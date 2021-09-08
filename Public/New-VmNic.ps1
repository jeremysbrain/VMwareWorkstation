<#
.SYNOPSIS
Creates a new virtual NIC in the specified VM.

.DESCRIPTION
Creates a new virtual NIC in the specified VM.  If the Type is Custom, the Virtual Network should also be specified.

.EXAMPLE
New-VmNic -Id 'BFBC62CCE1294BEA963243322D2E58AA' -Type 'Bridged'

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | New-VmNic -Type 'Nat'
#>
function New-VmNic {
    [CmdletBinding()]
    param (
        # ID of VM to create VmNic
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Id,

        # Type of VmNic to create.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Bridged', 'Nat', 'Custom', 'HostOnly')]
        [VmNicType]
        $Type,

        # Name of Vnet to connect to.
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
            Method = 'post'
        }
    }
    
    process {
        $Endpoint = "vms/$id/nic"
            
        $Body = @{
            type = $Type.ToLower()
        }

        if ($Type -eq 'Custom') {
            $Body += @{ vmnet = $Vnet }
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