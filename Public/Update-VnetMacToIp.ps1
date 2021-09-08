<#
.SYNOPSIS
Updates static DHCP bindings for the specified virtual network.

.DESCRIPTION
Updates static DHCP bindings for the specified virtual network.  These settings can be retrieved using Get-VnetMacToIp.

.EXAMPLE
Update-VnetMacToIp -Vnet 'vmnet1' -MacAddress '00:0C:DD:5E:FF:40' -IpAddress '192.168.0.202'
#>
function Update-VnetMacToIp {
    [CmdletBinding()]
    param (
        # Vnet Name 
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('VmNet', 'Name')]
        [string]
        $Vnet,

        # MAC address to update
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('MAC')]
        [string]
        $MacAddress,

        # IP Address to assign
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('IP')]
        [string]
        $IpAddress
        
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
        $Endpoint = "vmnet/$Vnet/mactoip/$MacAddress"

        $Body = @{
            IP = $IpAddress
        }
            
        $ParamIrm.Uri = "$($VMwareWsApi.BaseUri)/$EndPoint"
        $ParamIrm.Body = ($Body | ConvertTo-Json)

        $Request = Invoke-RestMethod @ParamIrm
    }
    
    end {
        $Request
    }
}