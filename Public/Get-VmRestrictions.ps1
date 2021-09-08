<#
.SYNOPSIS
Retrieves the restrictions associated with a VM

.DESCRIPTION
Retrieves the "restrictions" associated with a VM

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | Get-VmRestrictions
#>
function Get-VmRestrictions {
    [CmdletBinding()]
    param (
        # ID of VM to retrieve restrictions
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
            $Endpoint = "vms/$IdItem/restrictions"
            
            $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"

            $Request += Invoke-RestMethod @ParamIrm
        }
    }
    
    end {
        $Request
    }
}