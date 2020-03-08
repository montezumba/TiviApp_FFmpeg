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
# * Hardcoded the enabled-decoders list as per TiviApp specific needs
# * Changed the FFmpeg source repository to point to the GitHub tag n4.2
# * Minor changes in the script
# ------------------------------------------------------------------
#

#FFMPEG_EXT_PATH=$1
NDK_PATH=$1
HOST_PLATFORM="linux-x86_64"
ENABLED_DECODERS=(vorbis opus flac alac pcm_mulaw pcm_alaw mp3 amrnb amrwb aac ac3 eac3 dca mlp truehd)
#ENABLED_DECODERS=("${@:4}")


COMMON_OPTIONS="    
    --disable-static
    --enable-shared
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
    "
#TOOLCHAIN_PREFIX="${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}/bin"
#TOOLCHAIN_PREFIX_X86_64="${NDK_PATH}/toolchains/x86_64-4.9/prebuilt/linux-x86_64/bin"
TOOLCHAIN_PATH="${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}"
SYSROOT="${TOOLCHAIN_PATH}/sysroot"
for decoder in "${ENABLED_DECODERS[@]}"
do
    echo ${decoder}
    COMMON_OPTIONS="${COMMON_OPTIONS} --enable-decoder=${decoder}"
done
#cd "${FFMPEG_EXT_PATH}"
# git://source.ffmpeg.org/ffmpeg
(git -C ffmpeg pull || git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg)
cd ffmpeg
git checkout release/4.2
echo ${COMMON_OPTIONS}
./configure \
	--prefix=android-libs/x86_64 \
	--enable-cross-compile \
	--arch=x86_64 \
	--target-os=android \
	--sysroot=${SYSROOT} \
	--cross-prefix="${TOOLCHAIN_PATH}/bin/x86_64-linux-android-" \
	--cc="${TOOLCHAIN_PATH}/bin/x86_64-linux-android21-clang" \
	--extra-cflags="-O3 -fPIC" \
	--x86asmexe="${TOOLCHAIN_PATH}/bin/yasm" \
	${COMMON_OPTIONS}
make -j4
make install-libs
make clean