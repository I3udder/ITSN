function Get-MerakiSwitches {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$NetworkID
    )

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }
    $api.url = "/networks/"+ $networkid +"/devices" 
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiAPs {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$NetworkID
    )

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = "/networks/"+ $networkid +"/devices"
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiAppliances {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$NetworkID
    )

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = "/networks/"+ $networkid +"/devices"
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiVPN {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID
    )

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = "/organizations/"+ $OrganizationID +"/thirdPartyVPNPeers"
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiNetworks {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID
    )

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = "/organizations/"+ $OrganizationID +"/networks"
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiOrganizations {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key
    )

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = '/organizations'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiSwitchPorts {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$networkid,
        [Parameter(Mandatory=$true)]
        [String]$switch_name
    )


    #Useage: Get-MerakiSwitchPorts "SW01"

    $switch = Get-MerakiSwitches -api_key $api_key -networkid $networkid | where {$_.name -eq $switch_name}

    if ($switch){

        $api = @{

            "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
        }

        $header = @{
        
            "X-Cisco-Meraki-API-Key" = $api_key
            "Content-Type" = 'application/json'
        
        }

        $api.url = "/devices/" + $switch.serial + "/switchPorts"
        $uri = $api.endpoint + $api.url
        $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
        return $request
    
    }
    else{

        Write-Host "Switch doesn't exist." -ForegroundColor Red
    
    }

}

Function Get-MerakiRedirectedUrl  {
 
    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID
    )

    $url = "https://dashboard.meraki.com/api/v0/organizations/"+ $OrganizationID +"/networks"
    $request = [System.Net.WebRequest]::Create($url)
    $request.Method = "GET"
    $request.ContentType = "application/json"
    $request.Headers.Add("X-Cisco-Meraki-API-Key",$api_key);
    $request.AllowAutoRedirect=$False
    $response=$request.GetResponse()
 
    If ($response.StatusCode -eq "Found")
    {
        $response.GetResponseHeader("Location")
    }
}

 function New-MerakiOrganization {

   Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID,
        [Parameter(Mandatory=$true)]
        [String]$new_name,
        [Parameter(Mandatory=$false)]
        [String]$ServerID

    )

If (!$ServerID) {
    $shard = Get-MerakiRedirectedUrl -api_key $api_key -OrganizationID $OrganizationID
    $endpoint = $shard.Substring(8,4)
    }
    else {
    $endpoint = $ServerID
    }

$json = @"


{
"name":"$new_name"
}

"@


    $api = @{

        "endpoint" = "https://"+ $endpoint +".meraki.com/api/v0"
    
    }


    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
    }

    $api.url = '/organizations'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method Post -Uri $uri -Headers $header -Body $json -Verbose
    return $request

}  

function Get-MerakiLicenseState {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID
    )

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = "/organizations/"+ $OrganizationID +"/licenseState"
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Copy-MerakiOrganization {

   Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID,
        [Parameter(Mandatory=$true)]
        [String]$new_name,
        [Parameter(Mandatory=$false)]
        [String]$ServerID

    )

If (!$ServerID) {
    $shard = Get-MerakiRedirectedUrl -api_key $api_key -OrganizationID $OrganizationID
    $endpoint = $shard.Substring(8,4)
    }
    else {
    $endpoint = $ServerID
    }

$json = @"


{
"name":"$new_name"
}

"@


    $api = @{

        "endpoint" = "https://"+ $endpoint +".meraki.com/api/v0"
    
    }


    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
    }

    $api.url = "/organizations/"+ $OrganizationID +"/clone"
    $uri = $api.endpoint + $api.url
    #Write-Output $uri
    $request = Invoke-RestMethod -Method Post -Uri $uri -Headers $header -Body $json -Verbose
    return $request

}

function Get-MerakiSSID {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$NetworkID
    )

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = "/networks/"+ $networkid +"/ssids"
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}
 
 Function Set-MerakiOrganization {


Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID,
        [Parameter(Mandatory=$true)]
        [String]$new_name,
        [Parameter(Mandatory=$false)]
        [String]$ServerID

    )

If (!$ServerID) {
    $shard = Get-MerakiRedirectedUrl -api_key $api_key -OrganizationID $OrganizationID
    $endpoint = $shard.Substring(8,4)
    }
    else {
    $endpoint = $ServerID
    }

$json = @"


{
"id": $OrganizationID,
"name":"$new_name"
}

"@


    $api = @{

        "endpoint" = "https://"+ $endpoint +".meraki.com/api/v0"
    
    }


    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
    }

    $api.url = "/organizations/"+ $OrganizationID
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method Put -Uri $uri -Headers $header -Body $json -Verbose
    return $request

} 

function Get-MerakiInventory {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID
    )

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = "/organizations/"+ $OrganizationID +"/inventory"
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    #Invoke-RestMethod -Method GET -Uri $uri -Headers $header | Out-File c:\temp\inventory.json
    return $request

}

function New-MerakiNetwork {

 <#
  .SYNOPSIS
  This function adds a new network in an organization
  .DESCRIPTION
  This function adds a new network in an organization
  .PARAMETER new_name
  The name of the new network
  .PARAMETER type
  The type of the new network. Valid types are 'wireless' (for MR), 'switch' (for MS), 'appliance' (for MX or Z1), 'phone' (for MC).
  .PARAMETER tags
  A space-separated list of tags to be applied to the network
  .PARAMETER timeZone
  The timezone of the network. For a list of allowed timezones, please see the 'TZ' column in the table in this article.
  https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

  #>

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID,
        [Parameter(Mandatory=$true)]
        [ValidateSet("switch","wireless","appliance", IgnoreCase = $False)]
        [String]$Type,
        [Parameter(Mandatory=$true)]
        [String]$new_name,
        [Parameter(Mandatory=$false)]
        [String]$tags,
        [Parameter(Mandatory=$false)]
        [String]$ServerID,
        [Parameter(Mandatory=$false)]
        [ValidateSet("US/Pacific","Europe/Amsterdam","America/Los_Angeles", IgnoreCase = $False)]
        [String]$timeZone

    )

If (!$ServerID) {
    $shard = Get-MerakiRedirectedUrl -api_key $api_key -OrganizationID $OrganizationID
    $endpoint = $shard.Substring(8,4)
    }
    else {
    $endpoint = $ServerID
    }

    $ConvertedType = $Type.ToLower()

$Object = New-Object PSObject

if ($new_name) {
 $Object | Add-Member NoteProperty name $new_name
}
if ($type) {
  $Object | Add-Member NoteProperty type $ConvertedType
}
if ($timeZone) {
  $Object | Add-Member NoteProperty timeZone $timeZone
}
if ($tags) {
  $Object | Add-Member NoteProperty tags $tags
}


$json = $Object | ConvertTo-Json

    $api = @{

        "endpoint" = "https://"+ $endpoint +".meraki.com/api/v0"
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = "/organizations/"+ $OrganizationID +"/networks"
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method Post -Uri $uri -Headers $header -Body $json -Verbose
    return $request

}

function New-MerakiLicense {

 <#
  .SYNOPSIS
  This function claims a device, license key, or order into an organization.
  .DESCRIPTION
  When claiming by order, all devices and licenses in the order will be claimed; 
  licenses will be added to the organization and devices will be placed in the organization's inventory. 
  These three types of claims are mutually exclusive and cannot be performed in one request.

  Either 'renew' or 'addDevices'. 'addDevices' will increase the license limit, while 'renew' will extend the amount of time until expiration. 
  This parameter is required when claiming by licenseKey
  #>

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID,
        [Parameter(Mandatory=$false)]
        [String]$ServerID,
        [Parameter(Mandatory=$false)]
        [ValidateSet("renew","addDevices", IgnoreCase = $False)]
        [String]$licenseMode,
        [Parameter(Mandatory=$false)]
        [String]$order,
        [Parameter(Mandatory=$false)]
        [String]$licenseKey,
        [Parameter(Mandatory=$false)]
        [String]$serial

    )

If (!$ServerID) {
    $shard = Get-MerakiRedirectedUrl -api_key $api_key -OrganizationID $OrganizationID
    $endpoint = $shard.Substring(8,4)
    }
    else {
    $endpoint = $ServerID
    }

if ($licenseKey){
  if (!$licenseMode) {
    $Warning = "Parameter licenseMode is required when adding licenseKey"
    Write-Error $Warning
    return
    }
  else{
$json = @"
{
"licenseKey": "$licenseKey",
"licenseMode": "$licenseMode"
}
"@
    }
}
if ($order) {

$json = @"
{
"order": "$order"
}
"@

}

if ($serial) {
$json = @"
{
"serial": "$serial"
}
"@
}

    $api = @{

        "endpoint" = "https://"+ $endpoint +".meraki.com/api/v0"
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'undefined'
        
    }

    $api.url = "/organizations/"+ $OrganizationID +"/claim"
    $uri = $api.endpoint + $api.url
    Write-Output $json
    $request = Invoke-RestMethod -Method Post -Uri $uri -Headers $header -Body $json -Verbose
    return $request

}

function Set-MerakiSwitchPort {

 <#
  .SYNOPSIS
  This function configures a switch port on a Meraki Switch
  .DESCRIPTION
  This function tries to get the serial number of the defined switch. With that serial number and the parameters supplied the command updates the switch port configuration.
  Only the values that are set will be configured on the port.
  #>

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID,
        [Parameter(Mandatory=$true)]
        [String]$networkID,
        [Parameter(Mandatory=$false)]
        [String]$ServerID,
        [Parameter(Mandatory=$True)]
        [String]$switchName,
        [Parameter(Mandatory=$True)]
        [String]$PortNumber,
        [Parameter(Mandatory=$False)]
        [String]$Name,
        [Parameter(Mandatory=$false)]
        [ValidateSet($true,$false)]
        [String]$enabled,
        [Parameter(Mandatory=$false)]
        [ValidateSet($true,$false)]
        [String]$poeEnabled,
        [Parameter(Mandatory=$False)]
        [String]$tags,
        [Parameter(Mandatory=$false)]
        [ValidateSet("access","trunk", IgnoreCase=$false)]
        [String]$type,
        [Parameter(Mandatory=$false)]
        [String]$vlan,
        [Parameter(Mandatory=$false)]
        [String]$voiceVlan,
        [Parameter(Mandatory=$false)]
        [String]$allowedVlans,
        [Parameter(Mandatory=$false)]
        [ValidateSet($true,$false)]
        [String]$isolationEnabled,
        [Parameter(Mandatory=$false)]
        [ValidateSet($true,$false)]
        [String]$rstpEnabled,
        [Parameter(Mandatory=$false)]
        [ValidateSet("disabled","Root guard","BPDU guard", IgnoreCase=$false)]
        [String]$stpGuard
    )

If (!$ServerID) {
    $shard = Get-MerakiRedirectedUrl -api_key $api_key -OrganizationID $OrganizationID
    $endpoint = $shard.Substring(8,4)
    }
    else {
    $endpoint = $ServerID
    }

$Object = New-Object PSObject

if ($name) {
 $Object | Add-Member NoteProperty name $Name
}
if ($tags) {
 $Object | Add-Member NoteProperty tags $tags
}
if ($enabled -eq $true) {
 $Object | Add-Member NoteProperty enabled $true
} 
if ($enabled -eq $false) {
 $Object | Add-Member NoteProperty enabled $false
}
if ($type) {
  $Object | Add-Member NoteProperty type $type
}
if ($vlan) {
  $Object | Add-Member NoteProperty vlan $vlan
}
if ($voiceVlan) {
  $Object | Add-Member NoteProperty voiceVlan $voiceVlan
}
if ($allowedVlans) {
  $Object | Add-Member NoteProperty allowedVlans $allowedVlans
}
if ($poeEnabled -eq $true) {
 $Object | Add-Member NoteProperty poeEnabled $true
} 
if ($poeEnabled -eq $false) {
 $Object | Add-Member NoteProperty poeEnabled $false
}
if ($isolationEnabled -eq $true) {
 $Object | Add-Member NoteProperty isolationEnabled $true
} 
if ($isolationEnabled -eq $false) {
 $Object | Add-Member NoteProperty isolationEnabled $false
}
if ($rstpEnabled -eq $true) {
 $Object | Add-Member NoteProperty rstpEnabled $true
} 
if ($rstpEnabled -eq $false) {
 $Object | Add-Member NoteProperty rstEnabled $false
}
if ($stpGuard) {
  $Object | Add-Member NoteProperty stpGuard $stpGuard
}

    $json = $Object | ConvertTo-Json

$switch = Get-MerakiSwitches -api_key $api_key -networkid $networkid | where {$_.name -eq $switchName}

if ($switch){ 

    $api = @{

        "endpoint" = "https://"+ $endpoint +".meraki.com/api/v0"
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = "/devices/" + $switch.serial + "/switchPorts/"+ $PortNumber
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method Put -Uri $uri -Headers $header -Body $json -Verbose
    return $request
    }
    else{

        Write-Host "Switch doesn't exist." -ForegroundColor Red
    
    }

}