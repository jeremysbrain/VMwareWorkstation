<#
.SYNOPSIS
Creates a copy of a VM.

.DESCRIPTION
Creates a copy of the specified VM files.  Does not register the new VM with the GUI Client.  Use Register-Vm to register.

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'Live' } | Copy-Vm -Destination 'LiveCopy'
#>
function Copy-Vm {
    [CmdletBinding()]
    param (
        # Id of Source VM to copy from
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        [Alias('Source')]
        $Id,

        # Name of destination VM
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Destination
    )
    
    begin {
        if (-not $VMwareWsApi) {
            throw 'Not connected. Please run Connect-VMwareWorkstation first'
        }

        $ParamIrm = @{
            Header = $VMwareWsApi.Header
            Method = 'Post'
        }
    }
    
    process {
        $Endpoint = 'vms'

        $Body = @{
            name     = $Destination
            parentId = $Id
        }

        $ParamIrm.Uri  = "$($VMwareWsApi.BaseUri)/$Endpoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)

        $Request = Invoke-RestMethod @ParamIrm
    }
    
    end {
        $Request
    }
}