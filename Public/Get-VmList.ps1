<#
.SYNOPSIS
Returns a list of VM's associated with VMware Workstation

.DESCRIPTION
Returns a list of the Id and .vmx file path associated with VM's registered with VMware Workstation.  The .vmx file typically matches the VM name.

.EXAMPLE
Get-VmList
#>
function Get-VmList {
    [CmdletBinding()]
    param (

    )
    
    begin {
        if (-not $VMwareWsApi) {
            throw 'Not connected. Please run Connect-VMwareWorkstation first'
        }

        $ParamIrm = @{
            Header = $VMwareWsApi.Header
            Method = 'Get'
        }
    }
    
    process {
        $Endpoint = 'vms'

        $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$Endpoint"

        $Request = Invoke-RestMethod @ParamIrm
    }
    
    end {
        $Request
    }
}