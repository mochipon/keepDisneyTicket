#!/bin/bash
set -eu

while true; do
    ./buyTicket.bash | grep receipt | tee -a output.txt
    sleep 1
done
