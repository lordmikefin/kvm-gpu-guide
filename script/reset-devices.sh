#!/bin/bash

# https://forum.proxmox.com/threads/vfio-pci-refused-to-change-power-state-currently-in-d3.60846/

# Usage:
#  $ sudo ./reset-devices.sh 01:00 02:00 03:00 05:00

#echo 0000:${1}

#echo "disconnecting amd graphics"
#echo "1" | tee -a /sys/bus/pci/devices/0000:${1}.0/remove
#echo "disconnecting amd sound counterpart"
#echo "1" | tee -a /sys/bus/pci/devices/0000:${1}.1/remove
#echo "entered suspended state press power button to continue"
#echo -n mem > /sys/power/state
#echo "reconnecting amd gpu and sound counterpart"
#echo "1" | tee -a /sys/bus/pci/rescan
#echo "AMD graphics card sucessfully reset"

echo "disconnecting devices"
for dev in "$@"; do
    echo "Dev: ${dev}"
    echo "1" | tee -a /sys/bus/pci/devices/0000:${dev}.0/remove
    echo "1" | tee -a /sys/bus/pci/devices/0000:${dev}.1/remove
done

echo "entered suspended state press power button to continue"
echo -n mem > /sys/power/state

echo "reconnecting devices"
echo "1" | tee -a /sys/bus/pci/rescan


