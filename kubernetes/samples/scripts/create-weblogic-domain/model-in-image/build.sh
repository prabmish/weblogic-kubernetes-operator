#!/bin/bash
# Copyright 2019, Oracle Corporation and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#
# Usage: build.sh <working directory> <oracle support id> <oracle support id password> <domain type:WLS|RestrictedJRF|JRF>
#
set -e
usage() {
    echo "build.sh <working directory> <oracle support id> <oracle support id password> <domain type:WLS|RestrictedJRF|JRF>"
}
if [ "$#" != 4 ] ; then
    usage && exit
fi

WORKDIR=$1
USERID=$2
USERPWD=$3
DOMAINTYPE=$4

if [ ! "${DOMAINTYPE}" == "WLS" ] && [ ! "${DOMAINTYPE}" == "RestrictedJRF" ] && [ ! "${DOMAINTYPE}" == "JRF"]; then  echo "Invalid domain type: WLS or
FMW"; fi

if [ ! -d "${WORKDIR}" ] ; then
 echo "Directory WORKDIR does not exists." && exit 
fi

if [ -f "V982783-01.zip" ] ; then
 echo "Directory ${WORKDIR} does not contain V982783-01.zip." && exit 
fi

if [ -f "V886243-01.zip" ] && [ "${DOMAINTYPE}" == "WLS" ] ; then
 echo "Directory ${WORKDIR} does not contain V886243-01.zip." && exit 
fi

if [ -f "V886246-01.zip" ] && [ "${DOMAINTYPE}" == "RestrictedJRF" -o "${DOMAINTYPE}" == "JRF" ] ; then
 echo "Directory ${WORKDIR} does not contain V886243-01.zip." && exit 
fi

#
#
shopt -s expand_aliases
cp -R * ${WORKDIR}
cd ${WORKDIR}
unzip V982783-01.zip
#
echo Downloading latest WebLogic Image Tool

downloadlink=$(curl -sL https://github.com/oracle/weblogic-image-tool/releases/latest | grep "/oracle/weblogic-image-tool/releases/download" | awk '{ split($0,a,/href="/); print a[2]}' | cut -d\" -f 1)
echo Downdloading $downloadlink
curl -L  https://github.com$downloadlink -o weblogic-image-tool.zip

echo Downloading latest WebLogic Deploy Tool

downloadlink=$(curl -sL https://github.com/oracle/weblogic-deploy-tooling/releases/latest | grep "/oracle/weblogic-deploy-tooling/releases/download" | awk '{ split($0,a,/href="/); print a[2]}' | cut -d\" -f 1)
echo $downloadlink
curl -L  https://github.com$downloadlink -o weblogic-deploy.zip

unzip weblogic-image-tool.zip
#
echo Setting up imagetool
#
IMGTOOL_BIN=${WORKDIR}/imagetool-*/bin/imagetool.sh
#source ${WORKDIR}/imagetool-*/bin/setup.sh
#
mkdir cache
export WLSIMG_CACHEDIR=`pwd`/cache
export WLSIMG_BLDDIR=`pwd`
#
${IMGTOOL_BIN} cache addInstaller --type jdk --version 8u221 --path `pwd`/server-jre-8u221-linux-x64.tar.gz
if [ "${DOMAINTYPE}" == "WLS" ] ; then
    ${IMGTOOL_BIN} cache addInstaller --type wls --version 12.2.1.3.0 --path `pwd`/V886423-01.zip
    IMGTYPE=wls
else 
    ${IMGTOOL_BIN} cache addInstaller --type fmw --version 12.2.1.3.0 --path `pwd`/V886426-01.zip
    IMGTYPE=fmw
fi
${IMGTOOL_BIN} cache addInstaller --type wdt --version latest --path `pwd`/weblogic-deploy.zip
#
echo Creating base image with patches
#
${IMGTOOL_BIN} create --tag model-in-image:x0 --user ${USERID} --password ${USERPWD} --patches 29135930_12.2.1.3.190416,29016089 --jdkVersion 8u221 --type ${IMGTYPE}
#
# Building sample app ear file
#
./build_app.sh
#

if [ "${DOMAINTYPE}" == "JRF" ] ; then
    cp image/model1.yaml.jrf image/model1.yaml
fi

echo Creating deploy image with wdt models
#
cd image
${IMGTOOL_BIN} update --tag model-in-image:x1 --fromImage model-in-image:x0 --wdtModel model1.yaml --wdtVariables model1.10.properties --wdtArchive archive1.zip --wdtModelOnly --wdtDomainType ${DOMAINTYPE}
cd ..

echo Setting Domain Type in domain.yaml
#
sed -i s/@@DOMTYPE@@/${DOMAINTYPE}/ domain.yaml


# cp weblogic-deploy.zip image
# cd image
# docker build --tag model-in-image:x1 .
# cd ..
#
# echo Settng up domain resources
# #
# ./k8sdomain.sh
# #
# echo "Getting pod status - ctrl-c when all is running and ready to exit"
# kubectl get pods -n sample-domain1-ns --watch
# #






