#!/bin/bash 

#
# Needs sudo apt-get install rpm
#

. ./version.sh

BUILD_DIR="/tmp/build.$$"
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}/BUILD
mkdir -p ${BUILD_DIR}/RPMS
mkdir -p ${BUILD_DIR}/SOURCES
mkdir -p ${BUILD_DIR}/SPECS
mkdir -p ${BUILD_DIR}/SRPMS

FULL_NAME="barclamp-${BARCLAMP_NAME}-${MAJOR_VERSION}.${MINOR_VERSION}"

mkdir $FULL_NAME
cp -r Makefile app chef command_line $FULL_NAME
tar -zcf ${BUILD_DIR}/SOURCES/${FULL_NAME}.tar.gz ${FULL_NAME}
rm -rf ${FULL_NAME}

sed -e "s%BUILD_DIR%$BUILD_DIR%" barclamp-${BARCLAMP_NAME}.spec > ${BUILD_DIR}/SPECS/barclamp-${BARCLAMP_NAME}.spec
sed -ie "s%MAJOR_VERSION%${MAJOR_VERSION}%" ${BUILD_DIR}/SPECS/barclamp-${BARCLAMP_NAME}.spec
sed -ie "s%MINOR_VERSION%${MINOR_VERSION}%" ${BUILD_DIR}/SPECS/barclamp-${BARCLAMP_NAME}.spec
sed -ie "s%RPM_CONTEXT_NUMBER%${RPM_CONTEXT_NUMBER}%" ${BUILD_DIR}/SPECS/barclamp-${BARCLAMP_NAME}.spec

rpmbuild -v -ba --clean ${BUILD_DIR}/SPECS/barclamp-${BARCLAMP_NAME}.spec

mkdir -p bin
cp ${BUILD_DIR}/RPMS/noarch/* bin
cp ${BUILD_DIR}/SRPMS/* bin
#rm -rf ${BUILD_DIR}
