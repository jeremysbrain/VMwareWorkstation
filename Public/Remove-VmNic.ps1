<#
.SYNOPSIS
Removes a virtual NIC from the specified VM.

.DESCRIPTION
Removes a virtual NIC from the specified VM.  The VM must not be in a suspended power state.

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | Remove-VmNic -Index 3
#>
function Remove-VmNic {
    [CmdletBinding()]
    param (
        # ID of VM to remove NIC
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Id,

        # Index of VmNic to remove
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Index
    )
    
    begin {
        if (-not $VMwareWsApi) {
            throw 'Not connected. Please run Connect-VMwareWorkstation first'
        }

        $ParamIrm = @{
            Header = $VMwareWsApi.Header
            Method = 'delete'
        }
    }
    
    process {
        $Endpoint = "vms/$id/nic/$index"

        $ParamIrm.Uri  = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)
    
        $Request = Invoke-RestMethod @ParamIrm
    }
    
    end {
        $Request
    }
}