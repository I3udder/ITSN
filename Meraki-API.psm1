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
        [String]$new_name

    )

$shard = Get-MerakiRedirectedUrl -api_key $api_key -OrganizationID $OrganizationID
$endpoint = $shard.Substring(8,4)

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
        [String]$new_name

    )

$shard = Get-MerakiRedirectedUrl -api_key $api_key -OrganizationID $OrganizationID
$endpoint = $shard.Substring(8,4)

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
        [String]$new_name

    )

    $shard = Get-MerakiRedirectedUrl -api_key $api_key -OrganizationID $OrganizationID
    $endpoint = $shard.Substring(8,4)

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
    return $request

}

function New-MerakiNetwork {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$api_key,        
        [Parameter(Mandatory=$true)]
        [String]$OrganizationID,
        [Parameter(Mandatory=$true)]
        [String]$Type,
        [Parameter(Mandatory=$true)]
        [String]$new_name,
        [Parameter(Mandatory=$false)]
        [String]$tags

    )

    $shard = Get-MerakiRedirectedUrl -api_key $api_key -OrganizationID $OrganizationID
    $endpoint = $shard.Substring(8,4)
    $ConvertedType = $Type.ToLower()
if (!$tags){

$json = @"


{
"name":"$new_name",
"type": "$ConvertedType",
"tags": "",
"timeZone": "Europe/Amsterdam"
}

"@
}
else {

$json = @"


{
"name":"$new_name",
"type":  "$ConvertedType",
"tags": "$tags"
"timeZone": "Europe/Amsterdam"
}

"@

}

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