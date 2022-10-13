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
 
 ( [[ -n $claimToken ]] && [[ $claimToken -ne "null" ]] ) && echo -e "Token: \n$claimToken" || ( echo "token failed" && exit 1 )
 
sleep 3

## create account
## 2022-09-23 -- this isn't working, getting failed authentication. Token and deviceId should be fine, so it's likely formatting on the submission...
## 2022-10-13 -- changed POST data to be form-url-encoded format, still auth failure, despite having a token... hmm...
echo "Creating account..."
sleep 3

## update me...
if [[ -n $1 ]]; then
{
  deviceId=$1
} else {
  deviceId="TESTID"
}
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
 -d "deviceId=${deviceId}" \
 $url | \
 jq .

## successful attempt Headers:
# POST /services/DealerAppService3/CreateAccount HTTP/1.1
# Accept: */*
# Accept-Encoding: gzip, deflate, br
# Accept-Language: en-US,en;q=0.9
# Connection: keep-alive
# Content-Length: 17
# Content-Type: application/x-www-form-urlencoded
# Host: mcare.siriusxm.ca
# Referer: https://parker-stephens.github.io/
# Sec-Fetch-Dest: empty
# Sec-Fetch-Mode: cors
# Sec-Fetch-Site: cross-site
# User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36
# X-Kony-API-Version: 1.0
# X-Kony-Authorization: <token>
# X-Kony-Platform-Type: ios
# sec-ch-ua: "Chromium";v="105", "Not)A;Brand";v="8"
# sec-ch-ua-mobile: ?0
# sec-ch-ua-platform: "Windows"
#
## successful attempt Data:
# deviceId=AAAABBBB

## do some error return code checking and exit as needed... (needs a successful test run first...)



#-# debug - stop here
exit 1
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
 -d "deviceId=${deviceId}" \
 $url | \
 jq .

## do some error return code checking and exit as needed... (needs a successful test run first...)
