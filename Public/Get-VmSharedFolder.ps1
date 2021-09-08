<#
.SYNOPSIS
Retrieves a list of folders shared between the host and the specified VM.

.DESCRIPTION
Retrieves a list of folders shared between the host and the specified VM.

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | Get-VmSharedFolder
#>
function Get-VmSharedFolder {
    [CmdletBinding()]
    param (
        # ID of VM to retrieve Shared Folder Information
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
            $Endpoint = "vms/$IdItem/sharedfolders"
            
            $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"

            $Request += Invoke-RestMethod @ParamIrm
            $Request | Add-Member -MemberType NoteProperty -Name 'Id' -Value $IdItem
        }
    }
    
    end {
        $Request
    }
}