#!/bin/bash
# Sample on SAST, SCA & KICS scanning via CxAST CLI

## Global Properties
agent="MyASTCLI"
apikey="<api key>"

## Note that there exists US and EU instance
base_auth_uri="https://eu.iam.checkmarx.net/"
base_url="https://eu.ast.checkmarx.net/"
tenant="<tenant>"

## Project Properties
projectName="service-discovery-java-apps"

## Use scan presets below;
## 'Checkmarx Default' for Web and API applications
## 'Android' for Android
## 'Mobile' for ObjectiveC/Swift
preset="Checkmarx Default"
scantype="sast,sca,kics"

## Pull source code from git into a local folder
GitURL=https://github.com/yevgenykuz/service-discovery-demo-parent.git
filesource=$pwd/service-discovery-demo-parent
branch="master"
git clone --branch $branch $GitURL $filesource

## Execute Scans
file_include="Dockerfile"
file_filter="!.git,!.github,!docker-compose-cross-http.yml,!dotnet-core-apps,!nodejs-apps,!java-kafka-entry-point,!java-kafka-http-entry-point,!java-kafka-propagator,!java-kafka-sink,!java-rabbitmq-entry-point,!java-rabbitmq-http-entry-point,!java-rabbitmq-propagator,!java-rabbitmq-sink,!docker-compose-java-kafka.yml"
tags="service-discovery-demo,java"

./cx scan create -v --agent $agent --apikey $apikey --base-auth-uri $base_auth_uri --base-uri $base_url --tenant $tenant --project-name $projectName --sast-preset-name $preset --scan-types $scantype --branch $branch --tags $tags --file-source $filesource --file-include $file_include --file-filter $file_filter --nowait