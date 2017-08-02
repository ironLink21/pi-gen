#!/bin/bash -e

#Only compile if the directory doesn't exists, thus reducing recompile times

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
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH) -DCMAKE_INSTALL_INCLUDEDIR=include -DQT_VERSION=5 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-std=c++11cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH) -DCMAKE_INSTALL_INCLUDEDIR=include -DQT_VERSION=5 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-std=c++11

    #Make and install QtGstreamer
    make -j6
    sudo make install
EOF
fi 