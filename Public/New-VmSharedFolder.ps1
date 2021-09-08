<#
.SYNOPSIS
Creates a shared folder mapping between the host and a VM.

.DESCRIPTION
Creates a shared folder mapping between the host and a VM.

.EXAMPLE
New-VmSharedFolder -Id '87A4E98166AD47A7B8E12650556510BA' -FolderName 'Temp' -Path "$env:TEMP" -Access ReadWrite

.EXAMPLE
Get-VmList | Where-Object { $_.path -match 'Live' } | New-VmSharedFolder -FolderName 'Temp' -Path "$env:TEMP"
#>
function New-VmSharedFolder {
    [CmdletBinding()]
    param (
        # ID of VM to add Shared Folder
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Id,

        # Name of the shared folder in the VM
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Folder_Id')]
        [string]
        $FolderName,

        # Path to folder on host.  Path must already exist.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript( {
            Test-Path -Path $_
        } )]
        [string]
        $Path,

        # Access type to host folder.  Default is Read Only.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('ReadOnly', 'ReadWrite')]
        [AccessType]
        $Access = 'ReadOnly'
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
        $Endpoint = "vms/$Id/sharedfolders"
            
        $Body = @{
            folder_id = $FolderName
            host_path = $Path
            flags = [int]0
        }
        
        if ( $Access = 'ReadWrite' ) {
            $Body.flags = [int]4
        }

        $ParamIrm.Uri  = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)
    
        $Request = Invoke-RestMethod @ParamIrm
        $Request | Add-Member -MemberType NoteProperty -Name 'Id' -Value $IdItem
    }
    
    end {
        $Request
    }
}