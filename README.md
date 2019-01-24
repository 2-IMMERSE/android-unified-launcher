# Android Unified Launcher

<img src="https://2immerse.eu/wp-content/uploads/2016/04/2-IMM_150x50.png" align="left"/><em>This project was originally developed as part of the <a href="https://2immerse.eu/">2-IMMERSE</a> project, co-funded by the European Commission’s <a hef="http://ec.europa.eu/programmes/horizon2020/">Horizon 2020</a> Research Programme</em>

# Introduction

This repository contains the source code for two Android applications

1. 2-IMMERSE Unified Launcher Application
2. 2-IMMERSE Unified Launcher Configuration Application

The configuration application is used to specify which server environment the 2-IMMERSE Unified Launcher application should use and various other debug settings.

The purpose of the 2-IMMERSE Unified Launcher Application is to bootstrap 2-IMMERSE multi-screen experiences locally (on the Android device) and remotely on multiple HbbTV2.0 TVs and TV emulators. It provides the user with a simple electronic programme guide (EPG) from which a new multi-screen experience can be launched. It also provides a discovery mechanism for finding and joining existing multi-screen experiences.

## Building

To build everything, ensure Docker is installed and run:

```bash
make LAUNCHER_DEPLOYMENT_BASE_URL=<launcher-webapp-deployment-url>  \
     CLIENT_DEPLOYMENT_BASE_URL=<client-api-deployment-url>
```

See `make info` for more details.

This creates a docker image called 'bbcrd-android-builder' containing the build tools and SDKs necessary to compile the android applications. There is no need to install Cordova, Gradle or the Android SDK on your host computer.

The resulting android applications are built to:

`./src/unified-launcher/platforms/android/build/outputs/apk/debug/android-debug.apk`

and

`./src/unified-launcher-config/platforms/android/build/outputs/apk/debug/android-debug.apk`

NB: The URLs of the deployments of the client-api and the unified-launcher code must be specified using the CLIENT_DEPLOYMENT_BASE_URL and LAUNCHER_DEPLOYMENT_BASE_URL environment variables respectively. The URLs specified by these environment variables are embedded into the resulting unified launcher Android application. See the 'src/unified-launcher/index.html.template' file for for details.

# Licence and Authors

All code and documentation is licensed by the original author and contributors under the Apache License v2.0:

* [British Telecommunications (BT) PLC](http://www.bt.com/) (original author)
* [British Broadcasting Corporation](http://www.bbc.co.uk/rd) 

See AUTHORS.md file for a full list of individuals and organisations that have
contributed to this code.

## Contributing

If you wish to contribute to this project, please get in touch with the authors.
