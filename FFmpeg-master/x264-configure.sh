#!/bin/sh
cd x264
export NDK=/home/wangmaocai/android-ndk-r10e
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt
export PLATFORM=$NDK/platforms/android-14/arch-arm
export PREFIX=../android-lib
./configure --prefix=$PREFIX \
--enable-static \
--enable-pic \
--disable-asm \
--disable-cli \
--host=arm-linux \
--cross-prefix=$PREBUILT/linux-x86/bin/arm-linux-androideabi- \
--sysroot=$PLATFORM

make
make install

cd ..
