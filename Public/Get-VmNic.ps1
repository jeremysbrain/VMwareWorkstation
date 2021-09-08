<#
.SYNOPSIS
Gets the Virtual NIC's associated with the VM.

.DESCRIPTION
Gets the Virtual NIC information from the specified VMs.  This includes the VNic Index, Type (Bridged, NAT, Host Only, Custom), Virtual Network Connected, and the MAC address.

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | Get-VmNic
#>
function Get-VmNic {
    [CmdletBinding()]
    param (
        # ID of VM to retrieve VmNic information
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
            $Endpoint = "vms/$IdItem/nic"
            
            $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"

            $Request += Invoke-RestMethod @ParamIrm | Select-Object -ExpandProperty 'nics'
        }
    }
    
    end {
        $Request
    }
}