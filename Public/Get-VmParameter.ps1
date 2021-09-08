<#
.SYNOPSIS
Retrieves parameter information from specified VM.

.DESCRIPTION
Retrieves parameter value from the named parameter.  These values can be found in the .vmx file associated with the VM.

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'live' } | Get-VmParameter -Parameter config.version
#>
function Get-VmParameter {
    [CmdletBinding()]
    param (
        # ID of VM to retrieve Parameter
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Id,

        # Parameter name to retrieve.  These can also be retrieved from the vmx file.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Parameter
        
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
        $Endpoint = "vms/$Id/params/$Parameter"
            
        $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"

        $Request = Invoke-RestMethod @ParamIrm
    }
    
    end {
        $Request
    }
}