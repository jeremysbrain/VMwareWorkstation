<#
.SYNOPSIS
Connects to Vmware Workstation.  The vmrest.exe client must be running

.DESCRIPTION
Connects to VMware Workstation API.  The vmrest.exe client must be running.

vmrest.exe can normally be found in the same folder as the VMware Workstation executable.  This is normally "$env:ProgramFiles(x86)\VMware\VMware Workstation\vmrest.exe"
SMALL WARNING: The VMware Workstation GUI client does not automatically update.  If both vmrest.exe and the GUI client are used simultaneously, the GUI may not show inaccurate information.

.EXAMPLE
Connect-VMwareWorkstation

.EXAMPLE
$Cred = Get-Credential
Connect-VMwareWorkstation -Credential $Cred -Force
#>
function Connect-VMwareWorkstation {
    [CmdletBinding()]
    param (
        # URI to the VMware Workstation API.  Defaults to http://127.0.0.1:8697/api
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [uri]
        $Uri = 'http://127.0.0.1:8697/api',

        # Credentials
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [pscredential]
        $Credential = (Get-Credential -Message 'Enter Credentials for VMware Workstation API'),

        # Setup connection even if connectivity test fails
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [switch]
        $Force
    )

    if ( -not $Force ) {
        if ( -not (Test-NetConnection -ComputerName $Uri.Host -Port $Uri.Port).TcpTestSucceeded) {
            throw 'Could not connect to address {0} on port {1}. Use -Force to override' -f $Uri.Host, $Uri.Port
        }
    }

    $SwaggerUri = $Uri.AbsoluteUri -replace $Uri.AbsolutePath, '/json/swagger.json'
    $Swagger = Get-SwaggerData -Uri $SwaggerUri

    $CredentialCombination = '{0}:{1}' -f $Credential.UserName, $Credential.GetNetworkCredential().Password
    $Base64Cred = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($CredentialCombination))

    $VMwareWsAPI = $Script:VMwareWsAPI = @{
        BaseUri = $Uri
        Header  = @{
            'Authorization' = "Basic $Base64Cred"
            'Content-Type'  = 'application/vnd.vmware.vmw.rest-v1+json'
            'Accept'        = 'application/vnd.vmware.vmw.rest-v1+json'
        }
    }
}