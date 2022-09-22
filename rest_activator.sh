#!/bin/bash
## Inspired by Parker Stephens' work
## https://github.com/parker-stephens/siriusxm-activator/blob/main/index.html

## requires jq

## get token
url="https://mcare.siriusxm.ca/authService/100000002/login"

claimToken=$( curl \
 -s \
 -k \
 -X POST \
 -H "Accept: application/json" \
 -H "Content-Type: application/x-www-form-urlencoded" \
 -H "X-Kony-App-Secret: e3048b73f2f7a6c069f7d8abf5864115" \
 -H "X-Kony-App-Key: 85ee60a3c8f011baaeba01ff3a5ae2c9" \
 -H "X-Kony-Platform-Type: ios" \
  $url | \
  jq -r .claims_token.value )
 
 [[ -n $claimToken ]] && echo -e "Token: \n$claimToken" || ( echo "token failed" && exit 1 ))
 
sleep 3

## create account
echo "Creating account..."
sleep 3

## update me...
deviceId="TESTID"
url="https://mcare.siriusxm.ca/services/DealerAppService3/CreateAccount"

curl \
 -s \
 -k \
 -X POST \
 -H "X-Kony-Authorization: ${claimToken}" \
 -H "Content-Type: application/x-www-form-urlencoded" \
 -H "X-Kony-API-Version: 1.0" \
 -H "X-Kony-Platform-Type: ios" \
 -H "Accept: */*" \
 -d "deviceId${deviceId}" \
 $url | \
 jq .
## should the data submission be "deviceId:${deviceId}" or without the colon...?? I think without, based on the HTML submission...

## do some error return code checking and exit as needed... (needs a successful test run first...)

sleep 3

## activate radio
echo "Activating RadioId: $deviceId ..."
sleep 3

url="https://mcare.siriusxm.ca/services/USUpdateDeviceSATRefresh/updateDeviceSATRefreshWithPriority"

curl \
 -s \
 -k \
 -X POST \
 -H "X-Kony-Authorization: ${claimToken}" \
 -H "Content-Type: application/x-www-form-urlencoded" \
 -H "X-Kony-API-Version: 1.0" \
 -H "X-Kony-Platform-Type: ios" \
 -H "Accept: */*" \
 -d "deviceId${deviceId}" \
 $url | \
 jq .

## do some error return code checking and exit as needed... (needs a successful test run first...)
