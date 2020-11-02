#!/bin/bash
set -eu

dateSample='20201205'

# salesStatus: {
#   1,  // available
#   2,  // ?
#   3,  // not for sale
# }

# "saleStatusCommodityMap": {
#   "TOZZ1D20910PT": ディズニーランド
#   "TOZZ1D20911PT": ディズニーシー
# }

# .[0]  // 1 day
# .[1]  // 10:30 -
# .[2]  // 12:00 -

cookiejar=$(mktemp --tmpdir=./cookies)
echo "cookiejar: $cookiejar"

# Checking availability and getting some variables
availability=$(curl -jsS 'https://reserve.tokyodisneyresort.jp/ticket/ajax/searchTicket/' \
    -c "$cookiejar"    \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
    -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
    --data '_xhr=' \
    --data 'useDays=1' \
    --data "useDateFrom=$dateSample" \
    --data "parkTicketSalesForm=1")

# Bind to variables
useDays=$(echo $availability | jq -r ".[0].useDays")
parkTicketGroupCd=$(echo $availability | jq -r ".[0].parkticketgroupcd")
! $(echo $availability | jq -r ".[0].searchDateOpenTicket")
searchDateOpenTicket="$?"   # convert true to 1, false to 0
function tozz() {
    echo $1%3A$(echo $availability | jq -r ".[0].saleStatusCommodityMap.$1")
}
saleStatusCommodity="$(tozz TOZZ1D20910PT)%2C$(tozz TOZZ1D20911PT)"

if false; then
    echo $useDays
    echo $parkTicketGroupCd
    echo $searchDateOpenTicket
    echo $saleStatusCommodity
fi

echo "$dateSample:"
echo "  land: $(echo $availability | jq -r ".[0].saleStatusCommodityMap.TOZZ1D20910PT")"
echo "  sea : $(echo $availability | jq -r ".[0].saleStatusCommodityMap.TOZZ1D20911PT")"
