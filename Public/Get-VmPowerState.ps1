<#
.SYNOPSIS
Gets the power state of the specified VMs.

.DESCRIPTION
Gets the power state of the specified VMs.

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | Get-VmPowerState
#>
function Get-VmPowerState {
    [CmdletBinding()]
    param (
        # ID of VM to retrieve Power State
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
            $Endpoint = "vms/$IdItem/power"
            
            $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"

            $Request += Invoke-RestMethod @ParamIrm
        }
    }
    
    end {
        $Request
    }
}