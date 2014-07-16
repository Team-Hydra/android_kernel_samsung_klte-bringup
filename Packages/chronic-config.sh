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
# available frequencies:
# 300000 345600 422400 499200 576000 652800 729600 806400 883200 960000 1036800 1113600 1190400 1267200 1344000 1420800
# 1497600 1574400 1651200 1728000 1804800 1881600 1958400 2035200 2112000 2150400 2188800 2265600 2342400 2419200 2457600
# 2534400 2611200 2688000 2764800 2841600 2899200
#
# Max/Min
MAXFREQ=2457600
MINFREQ=300000


# Config GPU clock Max Frequency
# 389000000 = 389mhz (Super Underclocked)
# 462400000 = 450mhz (Underclocked)
# 578000000 = 578mhz (Default)
# 657500000 = 657mhz (Performance)
GPU_MAX=578000000


# Config GPU clock Min Frequency

# ** Choose either Samsung default 320Mhtz or Standard 200Mhtz
# ** key is as follows..

# 320Mhtz = 4
# 200Mhtz = 5
GPU_MIN=4


# I/O Scheduler
# 
# Available schedulers: cfq, bfq, fiops, noop, deadline, row, sio, vr, zen, fifo
# Device default: cfq
SCHED=cfq


# Enable Fastcharge
# 0 = disabled
# 1 = substitute AC to USB charging always
# 2 = substitute AC to USB charging only if there is no USB peripheral detected
FASTCHARGE=0


# Chronic Hotplug
# set custom "enable_core_thresholds" This is represented as four numbers each being for the corosponding core (0,1,2.3)
# the numbers are derived from cpu load times 10
# 0 = always on
# 999 = never on
ENABLE_CORE_THRES="0 290 340 390"


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
    echo $GPU_MAX > /sys/class/kgsl/kgsl-3d0/max_gpuclk
    echo $GPU_MIN > /sys/class/kgsl/kgsl-3d0/min_pwrlevel


# Config USB forced fastcharge
    echo "$FASTCHARGE" > /sys/kernel/fast_charge/force_fast_charge


# Config I/O sched
    echo $SCHED > /sys/block/mmcblk0/queue/scheduler


# Config Chronic Hotplug
    echo $ENABLE_CORE_THRES > /sys/devices/system/cpu/cpufreq/chronic_hotplug/enable_core_thresholds

