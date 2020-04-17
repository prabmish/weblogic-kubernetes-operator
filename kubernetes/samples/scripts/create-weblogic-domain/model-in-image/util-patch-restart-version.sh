# !/bin/sh
# Copyright (c) 2019, 2020, Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#

function usage() {

  cat << EOF

  This is a helper script for changing the 'spec.restartVersion' field
  of a deployed domain. This change will cause the operator to initiate
  a rolling restart of the resource's WebLogic pods.
 
  Usage:
 
    $(basename $0) [-n mynamespace] [-d mydomainuid]
  
    -d <domain_uid>     : Default is \$DOMAIN_UID if set, 'sample-domain1' otherwise.
    -n <namespace>      : Default is \$DOMAIN_NAMESPACE if set, 'DOMAIN_UID-ns' otherwise.
    -?                  : This help.
   
EOF
}

set -e

WORKDIR=${WORKDIR:-/tmp/$USER/model-in-image-sample-work-dir}
[ -e "$WORKDIR/env-custom.sh" ] && source $WORKDIR/env-custom.sh

DOMAIN_UID="${DOMAIN_UID:-sample-domain1}"
DOMAIN_NAMESPACE="${DOMAIN_NAMESPACE:-${DOMAIN_UID}-ns}"

while [ ! "$1" = "" ]; do
  if [ ! "$1" = "-?" ] && [ "$2" = "" ]; then
    echo "Syntax Error. Pass '-?' for usage."
    exit 1
  fi
  case "$1" in
    -n) DOMAIN_NAMESPACE="${2}"
        ;;
    -d) DOMAIN_UID="${2}"
        ;;
    -?) usage
        exit 1
        ;;
    *)  echo "Syntax Error. Pass '-?' for usage."
        exit 1
        ;;
  esac
  shift
  shift
done

set -eu
set -o pipefail

currentRV=`kubectl -n ${DOMAIN_NAMESPACE} get domain ${DOMAIN_UID} -o=jsonpath='{.spec.restartVersion}'`

nextRV=$((currentRV + 1))

echo "@@ Info: Patching domain '${DOMAIN_UID}' in namespace '${DOMAIN_NAMESPACE}' from restartVersion='${currentRV}' to restartVersion='${nextRV}'."

kubectl -n ${DOMAIN_NAMESPACE} patch domain ${DOMAIN_UID} --type='json' \
  -p='[{"op": "replace", "path": "/spec/restartVersion", "value": "'${nextRV}'" }]'

echo "@@"
echo "@@ Info: Domain '${DOMAIN_UID}' in namespace '${DOMAIN_NAMESPACE}' successfully patched!"
echo "@@"
echo "@@ Info: To monitor the domain's pods, call 'kubectl -n ${DOMAIN_NAMESPACE} get pods --watch=true --show-labels=true'. Expect the operator to restart the domain's pods until all of them have label 'weblogic.domainRestartVersion=\"$nextRV\"."
echo "@@"
