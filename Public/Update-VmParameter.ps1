<#
.SYNOPSIS
Updates a configuration parameter for the specified VM.

.DESCRIPTION
Updates a configuration parameter for the specified VM.  These parameters can be retreived using Get-VmParameter.
NOTE: As of VMware Workstation 16.1.2 build-17966106, the endpoint in the documentation is incorrect.  The correct endpoint is "/vms/{id}/params".

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | Update-VmConfig -Name 'isolation.tools.hgfs.disable' -Value TRUE
#>
function Update-VmParameter {
    [CmdletBinding()]
    param (
        # ID of VM to update settings
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Id,

        # Name of Parameter to update
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Name,

        # Value of Parameter
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Value
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
        $Endpoint = "vms/$id/params"
            
        $Body = @{
            name = $Name
            value = $Value
        }
    
        $ParamIrm.Uri  = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)
    
        $Request = Invoke-RestMethod @ParamIrm

    }
    
    end {
        $Request
    }
}