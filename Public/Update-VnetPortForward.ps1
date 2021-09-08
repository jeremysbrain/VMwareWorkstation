<#
.SYNOPSIS
Updates port forwarding for a specified Virtual NIC.

.DESCRIPTION
Updates port forwarding for a specified Virtual NIC.

.EXAMPLE
Update-VnetPortForward -Vnet 'vmnet1' -SourcePort 3389 -DestPort 3390 -Protocol TCP -IpAddress 192.168.0.30
#>
function Update-VnetPortForward {
    [CmdletBinding()]
    param (
        # Vnet Name 
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('VmNet', 'Name')]
        [string]
        $Vnet,

        # Source Port Number
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [int]
        $SourcePort,

        # Source and Destination Protocol (TCP/UDP)
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('tcp', 'udp')]
        [string]
        $Protocol,

        # Destination IP Address
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $IpAddress,

        # Destination Port Number.  If ommited, will match the source port number
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [int32]
        $DestPort = $SourcePort,

        # Optional Description
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]
        $Description
        
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
        $Endpoint = "vmnet/$VnetItem/portforward/$Protocol/$SourcePort"
            
        $Body = @{
            guestIp   = $IpAddress
            guestPort = $DestPort
            desc      = $Description
        }
    
        $ParamIrm.Uri  = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)
    
        $Request = Invoke-RestMethod @ParamIrm

    }
    
    end {
        $Request
    }
}