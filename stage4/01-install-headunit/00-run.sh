#!/bin/bash -e

#Compile qt-gstreamer
if [ ! -d ${ROOTFS_DIR}/opt/qt-gstreamer ] || [ ! -z ${BUILD_QTGSTREAMER+x} ]; then    
    log "Compiling qt-gstreamer..."
on_chroot << EOF
    cd /opt

    #Clone QtGstreamer
    if [ -d "qt-gstreamer" ]; then
        cd qt-gstreamer
        git pull
    else
        git clone git://anongit.freedesktop.org/gstreamer/qt-gstreamer
        cd qt-gstreamer
    fi

    #Create build dir
    mkdir build
    cd build

    #cmake QtGstreamer
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/arm-linux-gnueabihf -DCMAKE_INSTALL_INCLUDEDIR=include -DQT_VERSION=5 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-std=c++11

    #Make and install QtGstreamer
    make -j6
    sudo make install
EOF
else
    log "Skipping qt-gstreamer compilation"
fi

#Compile and install headunit-desktop
if [ ! -d ${ROOTFS_DIR}/opt/headunit-desktop ] || [ ! -z ${BUILD_HEADUNIT+x} ]; then    
    log "Compiling headunit-desktop..."
on_chroot << EOF
    cd /opt

    ### Build headunit 
    if [ -d "headunit-desktop" ]; then
        cd headunit-desktop
        git pull
    else
        git clone --recursive --depth 1 -j6 https://github.com/viktorgino/headunit-desktop.git
        cd headunit-desktop
    fi

    #Generate protobuf with proto
    protoc --proto_path=headunit/hu/ --cpp_out=headunit/hu/generated.x64/ headunit/hu/hu.proto

    #compile headunit-desktop
    make clean
    qmake -config release
    make -j4
EOF
else
    log "Skipping headunit-desktop compilation"
fi 