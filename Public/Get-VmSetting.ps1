<#
.SYNOPSIS
Retrieves the settings from the specified VMs.

.DESCRIPTION
Retrieves CPU and Memory information from the associated VM

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | Get-VmSetting
#>
function Get-VmSetting {
    [CmdletBinding()]
    param (
        # ID of VM to retrieve settings
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
            $Endpoint = "vms/$IdItem"
            
            $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"

            $Request += Invoke-RestMethod @ParamIrm
        }        
    }
    
    end {
        $Request
    }
}