# FFmpeg library integration in TiviApp
This repository describes how the [FFmpeg Library](https://www.ffmpeg.org/) is integrated within the [TiviApp Live](https://play.google.com/store/apps/details?id=com.treynix.tiviapplive&hl=en) application in accordance with the [LGPLv2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html) software license.

## FFmpeg Source Code
The source code for the software libraries is taken as-is from the following [FFmpeg GitHub Repository](https://github.com/FFmpeg/FFmpeg/tree/n4.2). To access the code, just clone the following GIT repository: ```https://github.com/FFmpeg/FFmpeg.git``` and checkout the tag: **4.2n** for getting version 4.2.

**NOTE:** ___TiviApp was built and tested with version 4.2 only. We cannot provide any warranty or liability for using other versions of FFmpeg.___

## Building FFmpeg
We build the FFmpeg libraries by using the build_ffmpeg_tiviapp.sh Bash Script in this repository. The script performs the following operations:
* Fetches the FFmpeg sources (from the Git repository above)
* Configures the build parameters for TiviApp's needs
* Builds dynamically-linked libraries for different ABIs.
The resulted build artifacts are in form of Android's Shared Object files, that are loaded dynamically (at runtime) by the TiviApp Live application

To build FFmpeg on Linux one should:
* Download and install [NDK](https://developer.android.com/ndk/downloads) for Linux
* set: ```NDK_PATH=<path to ndk root folder>```
* run: ```sudo ./build_ffmpeg_tiviapp.sh "${NDK_PATH}"```
* run: ```sudo ${NDK_PATH}/ndk-build APP_ABI="armeabi-v7a arm64-v8a x86 x86-64" -j4```

## Changing the FFmpeg Version
If you wish to recompile or change the FFmpeg version that is being used in TiviApp, you can do so by performing the following steps:
* Build your custom FFmpeg version for the target device platform (ABI)
* Replace the resulted ```.so``` files in the application's ```lib``` folder on your device (phone storage).

For example: on Android 9 the ```.so``` files are located on this path (but it may change from one device to another): 
```
/data/data/app/com.treynix.tiviapplive/lib
```

**NOTE:** ___You may need root privileges for accessing the application folder on your device___
* Reboot the device or Force Stop the TiviApp Live application.

**WARNING:** ___We will not take any responsibility for any problems that may occur during this process. Perform this at your own risk!___

## Integration and Debug
For the purpose of debug and integration of custom FFmpeg versions, you may use the following code from the [ExoPlayer GitHub Repository](https://github.com/google/ExoPlayer/tree/r2.11.3/extensions/ffmpeg/src/main/java/com/google/android/exoplayer2/ext/ffmpeg). TiviApp Live uses the exact code from the **r2.11.3** tag to load the FFmpeg modules and activate the relevant codecs.

## License
The FFmpeg Source Code and Binaries are licensesd under the LGPL v2.1 license
All the information in this repository, including build scripts and auxilliary material is licensed under the Apache v2 license 

