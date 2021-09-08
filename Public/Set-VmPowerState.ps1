<#
.SYNOPSIS
Sets the power state of the selected VM.

.DESCRIPTION
Sets the power state of the selected VM.
  On - Powers the VM on
  Off - Forcefully powers the VM off (like pulling the power cord)
  Pause - VMware saving the state of the VM
  Suspend - Guest suspension (like putting the guest os to sleep)
  Shutdown - Gracefully shutdown the guest os
  Unpause - Wakes the VM

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | Set-VmPowerState -PowerState On
#>
function Set-VmPowerState {
    [CmdletBinding()]
    param (
        # Id of VM
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Id,

        # Power State to set the VM to
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        [ValidateSet('On','Off','Pause','Unpause','Suspend','Shutdown')]
        $PowerState
    )
    
    begin {
        if (-not $VMwareWsApi) {
            throw 'Not connected. Please run Connect-VMwareWorkstation first'
        }

        $ParamIrm = @{
            Header = $VMwareWsApi.Header
            Method = 'Put'
        }
    }
    
    process {
        $Endpoint = "vms/$Id/power"
        
        $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = $PowerState.ToLower()

        $Request = Invoke-RestMethod @ParamIrm
    }
    
    end {
        $Request
    }
}