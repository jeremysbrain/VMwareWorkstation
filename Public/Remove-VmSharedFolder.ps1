<#
.SYNOPSIS
Removes a shared folder connection from a VM.

.DESCRIPTION
Removes a shared folder connection from a VM.

.EXAMPLE
Remove-VmSharedFolder -Id '50AED11219204528A2152D96195CDD58' -FolderName 'TEMP'

.EXAMPLE
Get-VmList | Where-Object { $_.Id -eq '50AED11219204528A2152D96195CDD58' } | Remove-VmSharedFolder -Id  -FolderName 'TEMP'
#>
function Remove-VmSharedFolder {
    [CmdletBinding()]
    param (
        # ID of VM to remove Shared Folder
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Id,

        # Name of the shared folder in the VM
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Folder_Id')]
        [string]
        $FolderName
    )
    
    begin {
        if (-not $VMwareWsApi) {
            throw 'Not connected. Please run Connect-VMwareWorkstation first'
        }

        $ParamIrm = @{
            Header = $VMwareWsApi.Header
            Method = 'Delete'
        }
    }
    
    process {
        $Endpoint = "vms/$Id/sharedfolders/$FolderName"

        $ParamIrm.Uri  = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)
    
        $Request = Invoke-RestMethod @ParamIrm
        $Request | Add-Member -MemberType NoteProperty -Name 'Id' -Value $IdItem
    }
    
    end {
        $Request
    }
}