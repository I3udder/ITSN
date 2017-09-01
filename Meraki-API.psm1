#Insert your API key here

#$api_key = 'INSERT_API_KEY_HERE'


function Get-MerakiSwitches ($api_key, $networkid) {

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

function Get-MerakiAPs ($api_key, $networkid) {

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

function Get-MerakiAppliances ($api_key, $networkid) {

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

function Get-MerakiVPN ($api_key, $OrganizationID) {

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

function Get-MerakiNetworks ($api_key, $OrganizationID) {

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

function Get-MerakiOrganizations ($api_key) {

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

function Get-MerakiSwitchPorts ($api_key, $networkid, $switch_name) {

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