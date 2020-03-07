# FFmpeg library integration in TiviApp
This repository describes how the [FFmpeg Library](https://www.ffmpeg.org/) is integrated within the [TiviApp Live](https://play.google.com/store/apps/details?id=com.treynix.tiviapplive&hl=en) application in accordance with the [LGPLv2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html) software license.

## FFmpeg Source Code
The source code for the software libraries is taken AS-IS from the following [FFmpeg GitHub Repository](https://github.com/FFmpeg/FFmpeg/tree/n4.2). To access the code, just clone the following GIT repository: https://github.com/FFmpeg/FFmpeg.git and checkout the tag: **4.2n** for version 4.2.
**NOTE:** TiviApp was built and tested with version 4.2 only. We cannot provide warranty or liability for using other versions of FFmpeg.

## Building FFmpeg
We build the FFmpeg libraries by using the build_ffmpeg_tiviapp.sh Bash Script in this repository. The script performs the following operations:
* Fetches the FFmpeg sources (from the Git repository above)
* Configures the build parameters for TiviApp needs
* Builds dynamically linked libraries for different ABIs.
The resulted build artifacts are in form of Shared Object files, that are loaded dynamically (at runtime) by the TiviApp Live application

## Changing FFmpeg Version
If you wish to recompile and change the FFmpeg version that is being used in TiviApp, you can do so by performing the following steps:
* Build your custom FFmpeg version for the target device platform (ABI)
* Place the resulted ```.so``` files in the application's ```lib``` folder on your device (phone storage).
**NOTE:** You may need root privileges for accessing the folder
* Reboot the device or Force Stop the TiviApp application.


