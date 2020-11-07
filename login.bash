#!/bin/bash
set -eu

userId=
password=
cookiejar=$(mktemp --tmpdir=./cookies)
echo "cookiejar: $cookiejar"

# Getting session
curl -jsS 'https://reserve.tokyodisneyresort.jp/top/' \
    -c "$cookiejar" \
    -H 'Connection: keep-alive' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
    > /dev/null

# Logging in
curl -sS 'https://reserve.tokyodisneyresort.jp/fli/doLogin/' \
    -c "$cookiejar" \
    -b "$cookiejar" \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
    -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
    -H 'Connection: keep-alive' \
    -H 'Origin: https://reserve.tokyodisneyresort.jp' \
    --data '_xhr=' \
    --data-urlencode "userId=$userId" \
    --data "password=$password" \
    --data 'currentUrl=%2Ftop%2F' \
    --data 'resultFlg=true&firstLogin=false' \
    | jq .
