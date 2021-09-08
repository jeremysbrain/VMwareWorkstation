<#
.SYNOPSIS
Registers VM files with VMware applications.

.DESCRIPTION
Registers VM files with VMware applications.

.EXAMPLE
Register-Vm -Name 'Live' -Path 'D:\VM\Live\Live.vmx'
#>
function Register-Vm {
    [CmdletBinding()]
    param (
        # Name of VM once registered
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Name,

        # Path to .vmx file of VM to register
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Path
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
        $Endpoint = "vms/registration"
        
        $Body = @{
            name = $Name
            path = $Path
        }

        $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)

        $Request = Invoke-RestMethod @ParamIrm
    }
    
    end {
        $Request
    }
}