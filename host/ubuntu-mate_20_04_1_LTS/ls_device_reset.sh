#!/bin/bash

# https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Passing_through_a_device_that_does_not_support_resetting
# https://github.com/gnif/vendor-reset


for iommu_group in $(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d); do
    echo "IOMMU group $(basename "$iommu_group")";
    for device in $(\ls -1 "$iommu_group"/devices/); do 
        if [[ -e "$iommu_group"/devices/"$device"/reset ]]; then 
            echo -n "[RESET]"; 
        fi; 
        echo -n $'\t';
        lspci -nns "$device"; 
    done; 
done

