#!/bin/bash
nrsysmond-config --set license_key=${NEW_RELIC_LICENSE_KEY} && /usr/sbin/nrsysmond -c /etc/newrelic/nrsysmond.cfg -n ${CUSTOM_HOSTNAME} -l /dev/stdout -f
