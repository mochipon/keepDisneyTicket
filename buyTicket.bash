#!/bin/bash
set -eu

usage=$(cat << EOS
Usage: ./buyTicket.bash DATE COMMODITY
    DATE:       Slash-separated date. e.g. 2020/12/05
    COMMODITY:  Commodity 'land' or 'sea'.
EOS
)

dateSampleSlashed=${1:-'2020/12/05'}
dateSample=$(echo dateSampleSlashed | sed 's;/;;g')

if [ "$2" = 'land' ]; then
    commodity="tozz1d20910pt"   # land
    selectparkday1="01"         # land
elif [ "$2" = 'sea' ]; then
    commodity="tozz1d20911pt"   # sea
    selectParkDay1="02"         # sea
else
    echo $usage
    exit 1;
fi

cookiejar=$(mktemp --tmpdir=./cookies)

# Getting TOKEN
token=$(curl -jsS 'https://reserve.tokyodisneyresort.jp/ticket/search/' \
    -c "$cookiejar" \
    -H 'Connection: keep-alive' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
    | grep "org.apache.struts.taglib.html.TOKEN" \
    | grep -oP '(?<=value=").*(?=")' \
    | uniq)

# ディズニーランド, 大人2人
curl -sS 'https://reserve.tokyodisneyresort.jp/online/parkticket/input/' \
    -w "{\"httpCode\":\"%{http_code}\",\"redirectUrl\":\"%{redirect_url}\",\"cookiejar\":\"${cookiejar}\"}" \
    -o /dev/null \
    -c "$cookiejar" \
    -b "$cookiejar" \
    -H 'Connection: keep-alive' \
    -H 'Pragma: no-cache' \
    -H 'Cache-Control: no-cache' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H 'Origin: https://reserve.tokyodisneyresort.jp' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'Sec-Fetch-Mode: navigate' \
    -H 'Sec-Fetch-User: ?1' \
    -H 'Sec-Fetch-Dest: document' \
    -H 'Referer: https://reserve.tokyodisneyresort.jp/ticket/search/' \
    -H 'Accept-Language: ja,en-US;q=0.9,en;q=0.8' \
    --data "tickets%5B0%5D.isParkTicket=true" \
    --data "tickets%5B0%5D.parkTicketGroupCd=01" \
    --data "tickets%5B0%5D.comCds=${commodity}" \
    --data "tickets%5B0%5D.parkTicketSalesForm=1" \
    --data "tickets%5B0%5D.useDays=1" \
    --data "tickets%5B0%5D.useDateFromHidden=${dateSample}" \
    --data-urlencode "tickets%5B0%5D.useDateFrom=${dateSampleSlashed}" \
    --data "tickets%5B0%5D.openTicket="     \
    --data "tickets%5B0%5D.numOfAdult=2"    \
    --data "tickets%5B0%5D.numOfJunior=0"   \
    --data "tickets%5B0%5D.numOfChild=0"    \
    --data "tickets%5B0%5D.selectParkDay1=${selectParkDay1}" \
    --data "tickets%5B0%5D.selectParkDay2=" \
    --data "route=1" \
    --data-urlencode "prev=/ticket/search/?numOfAdult=2&numOfJunior=0&numOfChild=0&selectParkDay1=${selectParkDay1}&parkTicketGroupCd=01&openTicket=&useDateFrom=${dateSample}&parkTicketSalesForm=1&useDays=1&route=1&" \
    --data "org.apache.struts.taglib.html.TOKEN=$token"
