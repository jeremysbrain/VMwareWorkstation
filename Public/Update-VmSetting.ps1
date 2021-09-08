<#
.SYNOPSIS
Updates the CPU and Memory values for the specified VM.

.DESCRIPTION
Updates the CPU and Memory values for the specified VM.  Either Memory or CPU must be specified.  Unfortunately this does not allow control of the number of cores per processor.

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'Live' } | Update-VmSetting -CPU 4

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'Live' } | Update-VmSetting -Memory 4096

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'Live' } | Update-VmSetting -CPU 8 -Memory 8192
#>
function Update-VmSetting {
    [CmdletBinding()]
    param (
        # ID of VM to retrieve settings
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Id,

        # New CPU count of VM
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [int]
        $CPU,

        # New Memory ammount in MB
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [int]
        $Memory
        
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
        $Endpoint = "vms/$id"

        
        $Body = @{ }
        switch ($true) {
            ($CPU -ne $null) {
                $Body.processors = $CPU
            }
            ($Memory -ne $null) {
                $Body.memory = $Memory
            }
            Default {
                throw 'Either CPU or Memory must be defined'
            }
        }
    
        $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)
    
        $Request = Invoke-RestMethod @ParamIrm

    }
    
    end {
        $Request
    }
}