#!/bin/sh
cd ffmpeg
export NDK=/home/wangmaocai/android-ndk-r10e
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt
export PLATFORM=$NDK/platforms/android-14/arch-arm
export PREFIX=../android-lib
build_one(){
  ./configure --target-os=linux --prefix=$PREFIX \
--enable-cross-compile \
--enable-runtime-cpudetect \
--disable-asm \
--arch=arm \
--cc=$PREBUILT/linux-x86/bin/arm-linux-androideabi-gcc \
--cross-prefix=$PREBUILT/linux-x86/bin/arm-linux-androideabi- \
--disable-stripping \
--nm=$PREBUILT/linux-x86/bin/arm-linux-androideabi-nm \
--sysroot=$PLATFORM \
--enable-gpl --disable-shared --enable-static --enable-nonfree --enable-version3 --disable-vda --disable-iconv \
--disable-encoders --enable-libx264 --enable-libfdk-aac --enable-encoder=libx264 --enable-encoder=libfdk_aac \
--disable-muxers --enable-muxer=mov --enable-muxer=ipod --enable-muxer=psp --enable-muxer=mp4 --enable-muxer=avi \
--disable-decoders --enable-decoder=aac --enable-decoder=aac_latm --enable-decoder=h264 --enable-decoder=mpeg4 \
--disable-demuxers --enable-demuxer=h264 --enable-demuxer=avi --enable-demuxer=mpc --enable-demuxer=mov \
--disable-parsers --enable-parser=aac --enable-parser=ac3 --enable-parser=h264 \
--disable-protocols --enable-protocol=file \
--disable-bsfs --enable-bsf=aac_adtstoasc --enable-bsf=h264_mp4toannexb \
--disable-indevs --enable-zlib \
--disable-outdevs --disable-ffprobe --disable-ffplay --enable-pthreads --enable-ffmpeg  --disable-ffserver --disable-debug --disable-doc \
--extra-cflags="-I ../android-lib/include -pie -fPIE -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm -march=armv7-a" \
--extra-ldflags="-L ../android-lib/lib -pie -fPIE"

}

build_one

make clean
make
make install

#$PREBUILT/linux-x86/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib  -L$PLATFORM/usr/lib -L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavfilter/libavfilter.a libswresample/libswresample.a  libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a libpostproc/libpostproc.a libavdevice/libavdevice.a -lc -lm -lz -ldl -llog -lx264 -lfdk-aac --dynamic-linker=/system/bin/linker $PREBUILT/linux-x86/lib/gcc/arm-linux-androideabi/4.9/libgcc.a 
cd ..
