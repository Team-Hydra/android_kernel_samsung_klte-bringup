#!/bin/sh
export PLATFORM="AOSP"
export MREV="KK4.4"
export CURDATE=`date "+%m.%d.%Y"`
if [ "$RLSVER" != "" ]; then
export MUXEDNAMELONG="ChronicKernel-$MREV-$PLATFORM-$BOARD-$RLSVER"
else
export MUXEDNAMELONG="ChronicKernel-$MREV-$PLATFORM-$BOARD-$CURDATE"
fi
export MUXEDNAMESHRT="ChronicKernel-$MREV-$PLATFORM-$BOARD*"
export KTVER="-$MUXEDNAMELONG"
export SRC_ROOT=`readlink -f ../../..`
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export INITRAMFS_DEST=$KERNELDIR/kernel/usr/initramfs
export INITRAMFS_SOURCE=`readlink -f ..`/Ramdisks/G900P/$PLATFORM"_"$MREV
export CONFIG_$PLATFORM_BUILD=y
export PACKAGEDIR=$KERNELDIR/Packages/$PLATFORM
# enable ccache
export USE_CCACHE=1
#Enable FIPS mode
#export USE_SEC_FIPS_MODE=true
export ARCH=arm
export CROSS_COMPILE=$SRC_ROOT/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-
#export CROSS_COMPILE=$PARENT_DIR/linaro4.9-a15/bin/arm-cortex_a15-linux-gnueabihf-
#export CROSS_COMPILE=$SRC_ROOT/prebuilt/linux-x86/toolchain/linaro/bin/arm-eabi-
#export CROSS_COMPILE=$SRC_ROOT/prebuilt/linux-x86/toolchain/new/bin/arm-cortex_a15-linux-gnueabihf-
export ENABLE_GRAPHITE=true

time_start=$(date +%s.%N)

echo "Remove old Package Files"
rm -rf $PACKAGEDIR/* > /dev/null 2>&1

echo "Setup Package Directory"
mkdir -p $PACKAGEDIR/system/lib/modules
mkdir -p $PACKAGEDIR/system/etc

echo "Create initramfs dir"
mkdir -p $INITRAMFS_DEST

echo "Remove old initramfs dir"
rm -rf $INITRAMFS_DEST/* > /dev/null 2>&1

echo "Copy new initramfs dir"
cp -R $INITRAMFS_SOURCE/* $INITRAMFS_DEST

echo "chmod initramfs dir"
chmod -R g-w $INITRAMFS_DEST/*
rm $(find $INITRAMFS_DEST -name EMPTY_DIRECTORY -print) > /dev/null 2>&1
rm -rf $(find $INITRAMFS_DEST -name .git -print)

echo "Remove old zImage"
rm $PACKAGEDIR/zImage
rm arch/arm/boot/zImage
rm arch/arm/boot/zImage-dtb

echo "Make the kernel"
make msm8974_sec_defconfig VARIANT_DEFCONFIG=msm8974pro_sec_klte_eur_defconfig SELINUX_DEFCONFIG=selinux_defconfig

#echo "Modding .config file - "$KTVER
#sed -i 's,CONFIG_LOCALVERSION="-ChronicKernel",CONFIG_LOCALVERSION="'$KTVER'",' .config

#if [ "$RLSVER" != "" ]; then
#echo "Release version number set - disabling LOCALVERSION_AUTO"
#sed -i 's,CONFIG_LOCALVERSION_AUTO=y,# CONFIG_LOCALVERSION_AUTO is not set,' .config
#fi

HOST_CHECK=`uname -n`
if [ $HOST_CHECK = 'chronic-buildbox' ]; then
	echo "detected build server...running make with 24 jobs"
	make -j24
else
	echo "Others! - " + $HOST_CHECK
	make -j`grep 'processor' /proc/cpuinfo | wc -l`
fi;

echo "Copy modules to Package"
cp -a $(find . -name *.ko -print |grep -v initramfs) $PACKAGEDIR/system/lib/modules/
if [ $ADD_CHRONIC_CONFIG = 'Y' ]; then
	cp Packages/chronic-config.sh $PACKAGEDIR/system/etc/chronic-config.sh
fi;

if [ -e $KERNELDIR/arch/arm/boot/zImage ]; then
	echo "Copy zImage to Package"
	cp arch/arm/boot/zImage $PACKAGEDIR/zImage

	echo "Make boot.img"
	./mkbootfs $INITRAMFS_DEST | gzip > $PACKAGEDIR/ramdisk.gz
	tools/dtbTool -o arch/arm/boot/dt.img -s 2048 -p scripts/dtc/ arch/arm/boot/
	chmod a+r arch/arm/boot/dt.img
	tools/mkbootimg --cmdline 'console=null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3' --kernel $PACKAGEDIR/zImage --ramdisk $PACKAGEDIR/ramdisk.gz --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x02000000 --tags_offset 0x01E00000 --dt arch/arm/boot/dt.img --output $PACKAGEDIR/boot.img 
	cd $PACKAGEDIR
	cp -R ../META-INF .

	rm ramdisk.gz
	rm zImage
	rm ../$MUXEDNAMESHRT.zip > /dev/null 2>&1
	zip -r ../$MUXEDNAMELONG.zip .

	time_end=$(date +%s.%N)
	echo -e "${BLDYLW}Total time elapsed: ${TCTCLR}${TXTGRN}$(echo "($time_end - $time_start) / 60"|bc ) ${TXTYLW}minutes${TXTGRN} ($(echo "$time_end - $time_start"|bc ) ${TXTYLW}seconds) ${TXTCLR}"
	
	FILENAME=../$MUXEDNAMELONG.zip
	FILESIZE=$(stat -c%s "$FILENAME")
	echo "Size of $FILENAME = $FILESIZE bytes."

	cd $KERNELDIR
else
	echo "KERNEL DID NOT BUILD! no zImage-dtb exist"
fi;
