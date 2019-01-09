#!/bin/bash -v
DESTINATION=${1:-~/elexis/rcptt/rcptt_result.h2.db}
mkdir -p `dirname ${DESTINATION}`
cp -pv /tmp/elexis*h2.db ${DESTINATION}
logger "Saved: $0 ${DESTINATION}"
