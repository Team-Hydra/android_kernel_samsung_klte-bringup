#!/system/bin/sh
#Script originally made by Axetilen. Modified by Sultan (android1234567)
#Updated for albinoman887's ChronicKernel (98% of the credit goes to android1234567. Thanks so much man :)
#Updated for ChronicKernel-pyramid-linaro
#adapted for Galaxy S4 kernel
#adapted for Galaxy S5 ChronicKernel

# Configure your options here #


# Config default CPU Gonvernor
# Kernel Default: intelliactive
# Uncomment desired governor by removing the "#" symbal before desired gov
# and add a "#" to the old line

# Possible values

# GOV=smartmax
# GOV=linoheart
# GOV=badass
# GOV=wheatley
# GOV=userspace
# GOV=consevative
# GOV=intelliactive
# GOV=performance
# GOV=ondemand
GOV=interactive

# Config CPU frequency
# Default: 2457600 (2.45Ghtz)
# Range: 300000 - 2899200 (300Mhtz - 2.89Ghtz)
#
# Max/Min
MAXFREQ=2457600
MINFREQ=300000


# Config 3D GPU clock
# 389000000 = 389mhz (Super Underclocked)
# 462400000 = 450mhz (Underclocked)
# 578000000 = 578mhz (Default)
# 657500000 = 657mhz (Performance)
GPU=578000000


# Enable Fastcharge
# 0 = disabled
# 1 = substitute AC to USB charging always
# 2 = substitute AC to USB charging only if there is no USB peripheral detected
FASTCHARGE=0



# End of configurable options #


################# DON'T CHANGE ANYTHING BELOW THIS LINE #################


# Config CPU Frequency
    sleep 3
    chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    echo $MAXFREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
    echo $MINFREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

    chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
    echo $MAXFREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
    chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
    echo $MINFREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq

    chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
    echo $MAXFREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
    chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
    echo $MINFREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq

    chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
    echo $MAXFREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
    chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
    echo $MINFREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq


## Config CPU governor
    sleep 3
    echo "$GOV" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    echo "$GOV" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
    echo "$GOV" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    echo "$GOV" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor


# Config 3D GPU setting
    echo $GPU > /sys/class/kgsl/kgsl-3d0/max_gpuclk


# Config USB forced fastcharge
    echo "$FASTCHARGE" > /sys/kernel/fast_charge/force_fast_charge

