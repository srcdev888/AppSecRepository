#!/bin/sh -x

# Execute CxSCA resolver scan

# General
LOG_LEVEL='--log_level Verbose'

# CxSCA Cloud
URL_AUTHSERVER='--authentication-server-url https://platform.checkmarx.net'
ACCOUNT='-a <account>'
USERNAME='-u <username>'
PASSWORD='-p <password>'

# Project
PROJECT_NAME='-n NodeGoat'
SCAN_PATH='-s /data'

# Fail criteria
SEVERITY_THRESHOLD='--severity_threshold High'

# SCA-Resolver will execute dependency check
# npm i --package-lock-only

docker run --rm -v $NODEGOAT_DIR:/data  cxsca-resolver:1.5.45 $LOG_LEVEL $URL_AUTHSERVER $ACCOUNT $USERNAME $PASSWORD $PROJECT_NAME $SCAN_PATH $SEVERITY_THRESHOLD