#!/bin/bash
set -eu

seq 1 50 | xargs -IX -P 100 ./buyTicket.bash
