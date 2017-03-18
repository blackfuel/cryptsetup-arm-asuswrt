#!/bin/bash
# Before running this script, you must first compile your router firmware so
# that it generates the AsusWRT libraries.  If you "make clean" this will
# remove the libraries needed by this script.
PATH_CMD="$(readlink -f $0)"

set -e
set -x

REBUILD_ALL=1
PACKAGE_ROOT="$HOME/asuswrt-merlin-addon/cryptsetup"
SRC="$PACKAGE_ROOT/src"
TOP="$HOME/asuswrt-merlin/release/src/router"
SYSROOT="$HOME/asuswrt-merlin/release/src-rt-6.x.4708/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3/arm-brcm-linux-uclibcgnueabi/sysroot"
LINUX_KERNEL="$HOME/asuswrt-merlin/release/src-rt-6.x.4708/linux/linux-2.6.36" \
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/brcm-arm/bin:/opt/brcm/hndtools-mipsel-linux/bin:/opt/brcm/hndtools-mipsel-uclibc/bin
MAKE="make -j`nproc`"

######## ####################################################################
# POPT # ####################################################################
######## ####################################################################

DL="popt-1.16.tar.gz"
URL="http://rpm5.org/files/popt/$DL"
mkdir -p $SRC/popt && cd $SRC/popt
FOLDER="${DL%.tar.gz*}"
[ "$REBUILD_ALL" == "1" ] && rm -rf "$FOLDER"
if [ ! -f "$FOLDER/__package_installed" ]; then
[ ! -f "$DL" ] && wget $URL
[ ! -d "$FOLDER" ] && tar xzvf $DL
cd $FOLDER

PKG_CONFIG_PATH="$PACKAGE_ROOT/lib/pkgconfig" \
OPTS="-ffunction-sections -fdata-sections -O3 -pipe -march=armv7-a -mtune=cortex-a9 -fno-caller-saves -mfloat-abi=soft -Wall -fPIC -std=gnu99" \
CFLAGS="$OPTS" CPPFLAGS="$OPTS" \
LDFLAGS="-ffunction-sections -fdata-sections -Wl,--gc-sections" \
./configure \
--host=arm-brcm-linux-uclibcgnueabi \
'--build=' \
--prefix=$PACKAGE_ROOT \
--enable-shared \
--enable-static \
--disable-nls \
--disable-rpath

$MAKE
make install
touch __package_installed
fi

################ ############################################################
# LIBGPG-ERROR # ############################################################
################ ############################################################

DL="libgpg-error-1.27.tar.bz2"
URL="https://gnupg.org/ftp/gcrypt/libgpg-error/$DL"
mkdir -p $SRC/libgpg-error && cd $SRC/libgpg-error
FOLDER="${DL%.tar.bz2*}"
[ "$REBUILD_ALL" == "1" ] && rm -rf "$FOLDER"
if [ ! -f "$FOLDER/__package_installed" ]; then
[ ! -f "$DL" ] && wget $URL
[ ! -d "$FOLDER" ] && tar xvjf $DL
cd $FOLDER

PATCH_NAME="${PATH_CMD%/*}/libgpg-error_mkheader_brcmarm.patch"
patch -p2 -i "$PATCH_NAME"

PKG_CONFIG_PATH="$PACKAGE_ROOT/lib/pkgconfig" \
OPTS="-ffunction-sections -fdata-sections -O3 -pipe -march=armv7-a -mtune=cortex-a9 -fno-caller-saves -mfloat-abi=soft -Wall -fPIC -std=gnu99" \
CFLAGS="$OPTS" CPPFLAGS="$OPTS" \
LDFLAGS="-ffunction-sections -fdata-sections -Wl,--gc-sections" \
./configure \
--host=arm-brcm-linux-uclibcgnueabi \
'--build=' \
--prefix=$PACKAGE_ROOT \
--enable-shared \
--enable-static \
--disable-nls \
--disable-rpath

$MAKE
make install
touch __package_installed
fi

############## ##############################################################
# UTIL-LINUX # ##############################################################
############## ##############################################################

DL="util-linux-2.29.2.tar.xz"
URL="https://www.kernel.org/pub/linux/utils/util-linux/v2.29/$DL"
mkdir -p $SRC/util-linux && cd $SRC/util-linux
FOLDER="${DL%.tar.xz*}"
[ "$REBUILD_ALL" == "1" ] && rm -rf "$FOLDER"
if [ ! -f "$FOLDER/__package_installed" ]; then
[ ! -f "$DL" ] && wget $URL
[ ! -d "$FOLDER" ] && tar xvJf $DL
cd $FOLDER

pushd .
cd $TOP/ncurses/lib
[ ! -f libtinfo.so.6 ] && ln -sf libncursesw.so.6 libtinfo.so.6
[ ! -f libtinfo.so ] && ln -sf libtinfo.so.6 libtinfo.so
popd

PKG_CONFIG_PATH="$PACKAGE_ROOT/lib/pkgconfig" \
OPTS="-ffunction-sections -fno-data-sections -O3 -pipe -march=armv7-a -mtune=cortex-a9 -fno-caller-saves -mfloat-abi=soft -Wall -fPIC -std=gnu99 -I$TOP/ncurses/include -I$SYSROOT/usr/include -lm" \
CFLAGS="$OPTS" CPPFLAGS="$OPTS" \
LDFLAGS="-ffunction-sections -fno-data-sections -Wl,--gc-sections -L$TOP/ncurses/lib -L$SYSROOT/usr/lib" \
LIBS="-lm -lncursesw -L$TOP/ncurses/lib -L$SYSROOT/usr/lib" \
./configure \
--host=arm-brcm-linux-uclibcgnueabi \
'--build=' \
--prefix=$PACKAGE_ROOT \
--enable-shared \
--enable-static \
--disable-rpath \
--disable-silent-rules --disable-agetty --disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-more --disable-libfdisk --disable-libsmartcols --disable-cal --disable-makeinstall-chown --disable-makeinstall-setuid --without-python --without-systemd --without-systemdsystemunitdir --with-sysroot=$SYSROOT

$MAKE
make install
touch __package_installed
fi

######## ####################################################################
# LVM2 # ####################################################################
######## ####################################################################

DL="LVM2.2.02.168.tgz"
URL="ftp://sources.redhat.com/pub/lvm2/releases/$DL"
mkdir -p $SRC/lvm2 && cd $SRC/lvm2
FOLDER="${DL%.tgz*}"
[ "$REBUILD_ALL" == "1" ] && rm -rf "$FOLDER"
if [ ! -f "$FOLDER/__package_installed" ]; then
[ ! -f "$DL" ] && wget $URL
[ ! -d "$FOLDER" ] && tar xzvf $DL
cd $FOLDER

PKG_CONFIG_PATH="$PACKAGE_ROOT/lib/pkgconfig" \
OPTS="-ffunction-sections -fdata-sections -O3 -pipe -march=armv7-a -mtune=cortex-a9 -fno-caller-saves -mfloat-abi=soft -Wall -fPIC -std=gnu99 -I$PACKAGE_ROOT/include" \
CFLAGS="$OPTS" CXXFLAGS="$OPTS" CPPFLAGS="$OPTS" \
LDFLAGS="-ffunction-sections -fdata-sections -Wl,--gc-sections  -L$PACKAGE_ROOT/lib -L../libdm/ioctl" \
LIBS="-lpthread -luuid -lm  -L$PACKAGE_ROOT/lib -L../libdm/ioctl" \
ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes \
./configure \
--host=arm-brcm-linux-uclibcgnueabi \
'--build=' \
--prefix=$PACKAGE_ROOT \
--with-confdir=$PACKAGE_ROOT/etc \
--with-default-system-dir=$PACKAGE_ROOT/etc/lvm \
--enable-static_link \
--disable-nls

mkdir -p $PACKAGE_ROOT/lib/pkgconfig
cp -p "libdm/libdevmapper.pc" $PACKAGE_ROOT/lib/pkgconfig
pushd .
cd $PACKAGE_ROOT/lib/pkgconfig
ln -sf libdevmapper.pc devmapper.pc
popd

$MAKE
make install
touch __package_installed
fi

########## ##################################################################
# GCRYPT # ##################################################################
########## ##################################################################

DL="libgcrypt-1.7.6.tar.bz2"
URL="https://gnupg.org/ftp/gcrypt/libgcrypt/$DL"
mkdir -p $SRC/gcrypt && cd $SRC/gcrypt
FOLDER="${DL%.tar.bz2*}"
[ "$REBUILD_ALL" == "1" ] && rm -rf "$FOLDER"
if [ ! -f "$FOLDER/__package_installed" ]; then
[ ! -f "$DL" ] && wget $URL
[ ! -d "$FOLDER" ] && tar xvjf $DL
cd $FOLDER

PKG_CONFIG_PATH="$PACKAGE_ROOT/lib/pkgconfig" \
OPTS="-ffunction-sections -fdata-sections -O3 -pipe -march=armv7-a -mtune=cortex-a9 -fno-caller-saves -mfloat-abi=soft -Wall -fPIC -std=gnu99" \
CFLAGS="$OPTS" CPPFLAGS="$OPTS" \
LDFLAGS="-ffunction-sections -fdata-sections -Wl,--gc-sections" \
./configure \
--host=arm-brcm-linux-uclibcgnueabi \
'--build=' \
--prefix=$PACKAGE_ROOT \
--enable-shared \
--enable-static \
--disable-amd64-as-feature-detection \
--with-gpg-error-prefix=$PACKAGE_ROOT

$MAKE
make install
touch __package_installed
fi

############## ##############################################################
# CRYPTSETUP # ##############################################################
############## ##############################################################

# select the crypto backend for cryptsetup
CRYPTO_BACKEND="gcrypt"
#CRYPTO_BACKEND="openssl_asuswrt"
#CRYPTO_BACKEND="nettle_asuswrt"

mkdir -p $SRC/cryptsetup && cd $SRC/cryptsetup
DL="cryptsetup-1.7.4.tar.xz"
FOLDER="${DL%.tar.xz*}"
URL="https://www.kernel.org/pub/linux/utils/cryptsetup/v1.7/$DL"
[ "$REBUILD_ALL" == "1" ] && rm -rf "$FOLDER"
if [ ! -f "$FOLDER/__package_installed" ]; then
[ ! -f "$DL" ] && wget $URL
[ ! -d "$FOLDER" ] && tar xvJf $DL
cd $FOLDER

# compiling without "--disable-kernel-crypto" requires a kernel header file: linux/if_alg.h
HEADER_KERNEL_CRYPTO="${PATH_CMD%/*}/if_alg.h"
[ ! -f "$LINUX_KERNEL/include/linux/if_alg.h" ] && [ -f "$HEADER_KERNEL_CRYPTO" ] && cp -p "$HEADER_KERNEL_CRYPTO" $LINUX_KERNEL/include/linux

if [ "$CRYPTO_BACKEND" == "gcrypt" ]; then

PKG_CONFIG_PATH="$PACKAGE_ROOT/lib/pkgconfig" \
OPTS="-ffunction-sections -fdata-sections -O3 -pipe -march=armv7-a -mtune=cortex-a9 -fno-caller-saves -mfloat-abi=soft -Wall -fPIC -std=gnu99 -I$PACKAGE_ROOT/include -I$TOP/e2fsprogs/lib -I$LINUX_KERNEL/include" \
CFLAGS="$OPTS" CPPFLAGS="$OPTS" \
LDFLAGS="-ffunction-sections -fdata-sections -Wl,--gc-sections -L$PACKAGE_ROOT/lib -L$TOP/e2fsprogs/lib" \
LIBS="-lpthread -lgpg-error -luuid -ldl -lgcrypt -L$PACKAGE_ROOT/lib -L$TOP/e2fsprogs/lib" \
./configure \
--host=arm-brcm-linux-uclibcgnueabi \
'--build=' \
--prefix=$PACKAGE_ROOT \
--enable-shared \
--enable-static \
--disable-nls \
--disable-rpath \
--enable-cryptsetup-reencrypt \
--with-crypto_backend=gcrypt \
--enable-static-cryptsetup \
--with-libgcrypt-prefix=$PACKAGE_ROOT

elif [ "$CRYPTO_BACKEND" == "openssl_asuswrt" ]; then

PKG_CONFIG_PATH="$PACKAGE_ROOT/lib/pkgconfig" \
OPTS="-ffunction-sections -fdata-sections -O3 -pipe -march=armv7-a -mtune=cortex-a9 -fno-caller-saves -mfloat-abi=soft -Wall -fPIC -std=gnu99 -I$PACKAGE_ROOT/include -I$TOP/e2fsprogs/lib -I$LINUX_KERNEL/include" \
CFLAGS="$OPTS" CPPFLAGS="$OPTS" \
LDFLAGS="-ffunction-sections -fdata-sections -Wl,--gc-sections -L$PACKAGE_ROOT/lib -L$TOP/e2fsprogs/lib" \
LIBS="-lpthread -lssl -lcrypto -lz -luuid -ldl -L$TOP/e2fsprogs/lib" \
./configure \
--host=arm-brcm-linux-uclibcgnueabi \
'--build=' \
--prefix=$PACKAGE_ROOT \
--enable-shared \
--enable-static \
--disable-nls \
--disable-rpath \
--enable-cryptsetup-reencrypt \
--with-crypto_backend=openssl \
--enable-static-cryptsetup

elif [ "$CRYPTO_BACKEND" == "nettle_asuswrt" ]; then

PKG_CONFIG_PATH="$PACKAGE_ROOT/lib/pkgconfig" \
OPTS="-ffunction-sections -fdata-sections -O3 -pipe -march=armv7-a -mtune=cortex-a9 -fno-caller-saves -mfloat-abi=soft -Wall -fPIC -std=gnu99 -I$PACKAGE_ROOT/include -I$TOP/e2fsprogs/lib -I$TOP/nettle/include -I$LINUX_KERNEL/include" \
CFLAGS="$OPTS" CPPFLAGS="$OPTS" \
LDFLAGS="-ffunction-sections -fdata-sections -Wl,--gc-sections -L$PACKAGE_ROOT/lib -L$TOP/e2fsprogs/lib -L$TOP/nettle/lib" \
LIBS="-lpthread -lgpg-error -luuid -ldl -lnettle -L$PACKAGE_ROOT/lib -L$TOP/e2fsprogs/lib -L$TOP/nettle/lib" \
./configure \
--host=arm-brcm-linux-uclibcgnueabi \
'--build=' \
--prefix=$PACKAGE_ROOT \
--enable-shared \
--enable-static \
--disable-nls \
--disable-rpath \
--enable-cryptsetup-reencrypt \
--with-crypto_backend=nettle \
--enable-static-cryptsetup \
--with-libgcrypt-prefix=$PACKAGE_ROOT

fi

$MAKE
make install
touch __package_installed
fi

