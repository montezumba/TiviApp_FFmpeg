#!/bin/bash
#
# Copyright (C) 2019 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ------------------------------------------------------------------
#
# Modifications by: Copyright (C) 2020 Treynix
#
# + Added a configuration for x86_64
# * Changed the configuration for other ABIs
# + Added building of ffmpeg lib
# * Hardcoded the enabled-decoders list as per TiviApp specific needs
# * Changed the FFmpeg source repository to point to the GitHub tag n4.2
# * Minor changes in the script
# ------------------------------------------------------------------
#

NDK_PATH=$1
HOST_PLATFORM="linux-x86_64"
ENABLED_DECODERS=(vorbis opus flac alac pcm_mulaw pcm_alaw mp3 amrnb amrwb aac ac3 eac3 dca mlp truehd)


COMMON_OPTIONS="
	--target-os=android
    --disable-static	
    --disable-doc
    --disable-programs
    --disable-everything
    --disable-avdevice
    --disable-avformat
    --disable-swscale
    --disable-postproc
    --disable-avfilter
    --disable-symver
    --enable-avresample
    --enable-swresample
	--enable-cross-compile
    --enable-shared
    "
TOOLCHAIN_PATH="${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}"
SYSROOT="${TOOLCHAIN_PATH}/sysroot"
for decoder in "${ENABLED_DECODERS[@]}"
do
    echo ${decoder}
    COMMON_OPTIONS="${COMMON_OPTIONS} --enable-decoder=${decoder}"
done
(git -C ffmpeg pull || git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg)
cd ffmpeg
git checkout release/4.2
################# armeabi-v7a #######################
./configure \
	--prefix=android-libs/armeabi-v7a \
	--arch=arm \
	--extra-cflags="-O3 -fPIC" \
	--sysroot=${SYSROOT} \
	--cross-prefix="${TOOLCHAIN_PATH}/bin/arm-linux-androideabi-" \
	--cc="${TOOLCHAIN_PATH}/bin/armv7a-linux-androideabi16-clang" \
	${COMMON_OPTIONS}
make -j4
make install-libs
make clean
################# arm64-v8a ########################
./configure \
	--prefix=android-libs/arm64-v8a \
	--arch=aarch64 \
	--extra-cflags="-O3 -fPIC" \
	--sysroot=${SYSROOT} \
	--cross-prefix="${TOOLCHAIN_PATH}/bin/aarch64-linux-android-" \
	--cc="${TOOLCHAIN_PATH}/bin/aarch64-linux-android21-clang" \
	${COMMON_OPTIONS}
make -j4
make install-libs
make clean
###################### x86 #########################
./configure \
	--prefix=android-libs/x86 \
	--arch=i686 \
	--extra-cflags="-O3 -fPIC" \
	--sysroot=${SYSROOT} \
	--cross-prefix="${TOOLCHAIN_PATH}/bin/i686-linux-android-" \
	--cc="${TOOLCHAIN_PATH}/bin/i686-linux-android16-clang" \
	--disable-asm \
	${COMMON_OPTIONS}
make -j4
make install-libs
make clean
###################### x86_64 ######################
./configure \
	--prefix=android-libs/x86_64 \
	--arch=x86_64 \
	--extra-cflags="-O3 -fPIC" \
	--sysroot=${SYSROOT} \
	--cross-prefix="${TOOLCHAIN_PATH}/bin/x86_64-linux-android-" \
	--cc="${TOOLCHAIN_PATH}/bin/x86_64-linux-android21-clang" \
	--x86asmexe="${TOOLCHAIN_PATH}/bin/yasm" \
	${COMMON_OPTIONS}
make -j4
make install-libs
make clean
cd ..
${NDK_PATH}/ndk-build APP_ABI="armeabi-v7a arm64-v8a x86 x86_64" -j4