#!/bin/bash

JIRA_VERSION=8.5.1

JIRA_DOWNLOAD_URI="https://www.atlassian.com/software/jira/downloads/binary"
JIRA_DL_ARCHIVE="atlassian-jira-software-${JIRA_VERSION}.tar.gz"

# Make directories
mkdir -p ${PLATFORM_APP_DIR}/jira;

# Download and Extract JIRA
tar xz -C ${PLATFORM_APP_DIR}/jira --strip 1 < <(wget --no-cookies --no-check-certificate -q -O - ${JIRA_DOWNLOAD_URI}/${JIRA_DL_ARCHIVE})


# Fix missing EOL char in jira/conf/logging.properties files
echo "" >> ${PLATFORM_APP_DIR}/jira/conf/logging.properties
# EOL Chars
sed -i 's/\r$//' ${PLATFORM_APP_DIR}/jira/conf/logging.properties

# Apply Platform.sh Patches
OLD_DIR=`pwd`
cd ${PLATFORM_APP_DIR}
for PATCH_FILE in ${PLATFORM_APP_DIR}/patches/*.patch; do    
    patch -p0 < $PATCH_FILE
done

