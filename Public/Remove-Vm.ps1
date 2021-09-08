<#
.SYNOPSIS
Removes the files associated with the specified VMs.

.DESCRIPTION
Removes the files associated with the specified VMs. Does not unregister the VM with the client.

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'Live' } | Remove-Vm
#>
function Remove-Vm {
    [CmdletBinding()]
    param (
        # ID of VM to delete
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
            Method = 'Delete'
        }

        $Request = @()
    }
    
    process {
        foreach ($IdItem in $Id) {
            $Endpoint = "vms/$IdItem"
            
            $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"

            $Request += Invoke-RestMethod @ParamIrm
        }        
    }
    
    end {
        $Request
    }
}