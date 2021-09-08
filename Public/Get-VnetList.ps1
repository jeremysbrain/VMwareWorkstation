<#
.SYNOPSIS
Retrieves the available Virtual Networks.  The default vmnet0 is not shown.

.DESCRIPTION
Retrieves the available Virtual Networks.  The default vmnet0 is not shown.

.EXAMPLE
Get-VnetList
#>
function Get-VnetList {
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
        $Endpoint = 'vmnet'

        $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$Endpoint"

        $Request = Invoke-RestMethod @ParamIrm | Select-Object -ExpandProperty vmnets
    }
    
    end {
        $Request
    }
}