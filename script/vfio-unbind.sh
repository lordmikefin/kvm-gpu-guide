#!/bin/bash

# https://youtu.be/IYOmuPzrdXk?t=686

#echo 0000:${1}
echo 0000:${1} > /sys/bus/pci/drivers/vfio-pci/unbind

