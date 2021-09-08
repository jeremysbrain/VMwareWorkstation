<#
.SYNOPSIS
Updates the configuration of an existing shared folder between the host and a VM.

.DESCRIPTION
Updates the configuration of an existing shared folder between the host and a VM.

.EXAMPLE
New-VmSharedFolder -Id '2D28DB62454C4BFB95A239CBE455F8F0' -FolderName 'Temp' -Path '\Temp'
Update-VmSharedFolder -Id '2D28DB62454C4BFB95A239CBE455F8F0' -FolderName 'Temp' -Path '\Temp' -Access 'ReadWrite'
#>
function Update-VmSharedFolder {
    [CmdletBinding()]
    param (
        # ID of VM to update Shared Folder
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
            Method = 'Put'
        }
    }
    
    process {
        $Endpoint = "vms/$Id/sharedfolders/$FolderName"
            
        $Body = @{
            host_path = $Path
            flags     = [int]0
        }
        
        if ( $Access = 'ReadWrite' ) {
            $Body.flags = [int]4
        }

        $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)
    
        $Request = Invoke-RestMethod @ParamIrm
        $Request | Add-Member -MemberType NoteProperty -Name 'Id' -Value $IdItem
    }
    
    end {
        $Request
    }
}