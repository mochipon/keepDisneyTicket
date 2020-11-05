#!/bin/bash
set -eu

usage=$(cat << EOS
Usage: ./buyTicket.bash DATE COMMODITY
    DATE:       Slash-separated date. e.g. 2020/12/05
    COMMODITY:  Commodity 'land' or 'sea'.
EOS
)

if [ $# < 2 ]; then
    echo $usage
    exit 1
fi

while true; do
    ./buyTicket.bash "$1" "$2" | grep receipt | tee -a output.txt
    sleep 1
done
