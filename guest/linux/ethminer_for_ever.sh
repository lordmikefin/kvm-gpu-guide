#!/bin/bash

# restart ethminer for ever

# NOTE: sometimes ethminer might disconnect :(

while true
do
  # Coinmotion address
  #ethminer --opencl --pool stratum://0x7c5ceff4c98551570c0dca4cd09d9e37e95aa01c@eu1.ethermine.org:4444
  # Binance address
  ethminer --opencl --pool stratum://0xbb1c6750ce9f76e6f53540cb37155ef7ff3354ab@eu1.ethermine.org:4444
  sleep 1
done
