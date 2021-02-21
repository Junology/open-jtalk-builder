#!/bin/bash

script_root="$(cd "$(dirname $0)" >/dev/null 2>&1 ; pwd -P)"
echo "The script executed at ${script_root}"

##
## check if all the necessary commands are available
##
echo ""
echo "=="
echo "Checking necessary commands:"

if ! command -v tar
then
	echo "Not Found: tar"
	exit 1;
fi

if command -v wget
then
	WGET=wget
elif command -v curl
then
	WGET="curl -L"
else
	echo "Not Found: wget | curl"
	exit 1;
fi


##################
### Build step ###
##################

LOCUSR_DIR="${script_root}/usr"
mkdir "${LOCUSR_DIR}"

BUILD_DIR="${script_root}/build"
mkdir "$BUILD_DIR" && cd "$BUILD_DIR"

##
## Building hts_engine API
##
HTS_ENGINE_NAME="hts_engine_API"
HTS_ENGINE_VER="1.10"
HTS_ENGINE_TARBALL="${HTS_ENGINE_NAME}-${HTS_ENGINE_VER}.tar.gz"
HTS_ENGINE_SRCROOT="http://downloads.sourceforge.net/hts-engine/"
HTS_ENGINE_URL="${HTS_ENGINE_SRCROOT}/${HTS_ENGINE_TARBALL}"

# download the source tar ball
echo ""
echo "=="
echo "Downloading hts_engine API"

getcmd="$WGET ${HTS_ENGINE_URL} -O ${HTS_ENGINE_TARBALL}"
echo $getcmd
eval $getcmd

echo ""
echo "Extracting..."
tar zxf "${HTS_ENGINE_TARBALL}"

# configure
cd "${HTS_ENGINE_NAME}-${HTS_ENGINE_VER}"
if ! eval "./configure --prefix=$LOCUSR_DIR"
then
	echo "configure failed."
	exit 1
fi

# build and install
make && make install

# set paths for headers/libraries
HTS_ENGINE_INCLUDE_DIR="${LOCUSR_DIR}/include"
HTS_ENGINE_LIB_DIR="${LOCUSR_DIR}/lib"

# return to the build root
cd "${BUILD_DIR}"

##
## Build Open JTalk
##

OPENJTALK_NAME="open_jtalk"
OPENJTALK_VER="1.11"
OPENJTALK_TARBALL="${OPENJTALK_NAME}-${OPENJTALK_VER}.tar.gz"
OPENJTALK_SRCROOT="http://downloads.sourceforge.net/open-jtalk"
OPENJTALK_URL="${OPENJTALK_SRCROOT}/${OPENJTALK_TARBALL}"

# download the source tar ball
echo "=="
echo "Downloading ${OPENJTALK_NAME}"

getcmd="$WGET ${OPENJTALK_URL} -O ${OPENJTALK_TARBALL}"
echo $getcmd
eval $getcmd

echo ""
echo "Extracting..."
tar zxf "${OPENJTALK_TARBALL}"

# configure
cd "${OPENJTALK_NAME}-${OPENJTALK_VER}"
configure_cmd="./configure --prefix=${LOCUSR_DIR} --with-hts-engine-header-path=${HTS_ENGINE_INCLUDE_DIR} --with-hts-engine-library-path=${HTS_ENGINE_LIB_DIR} --with-charset=UTF-8"
if ! eval "$configure_cmd"
then
	echo "configure failed."
	exit 1
fi

# build and install
make && make install

# copy headers and libraries used in building Open JTalk
OPENJTALK_INCLUDE_DIR="${LOCUSR_DIR}/include/open_jtalk"
OPENJTALK_LIB_DIR="${LOCUSR_DIR}/lib"
mkdir "${OPENJTALK_INCLUDE_DIR}"
mkdir "${OPENJTALK_LIB_DIR}"
find . -name '*.h' -exec cp --parents {} "${OPENJTALK_INCLUDE_DIR}" \;
find . -name 'lib*.a' -exec cp {} "${OPENJTALK_LIB_DIR}" \;

