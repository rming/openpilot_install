#!/sbin/sh
#
# init bash in twrp sh

export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib/
export PATH=/data/data/com.termux/files/usr/bin/:$PATH
mount -o ro /dev/block/bootdevice/by-name/system /system
[[ -d /usr ]] || ln -s /data/data/com.termux/files/usr /
