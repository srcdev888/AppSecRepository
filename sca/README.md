# Exploitable path using CxSCA Resolver 
* Author:   Pedric Kng  
* Updated:  22-Jul-21

This article describes the usage of CxSCA Resolver in a Jenkins declarative pipeline.

***

## Overview
CxSCA is an on-premise package resolver to capture open source package in a project working in sync with the installed package managers, and sent the signatures/manifest to CxSCA cloud for analysis capability. 

Additionally, CxSCA Resolver also provides capability to correlate with CxSAST to trace exploitable path from your proprietary source codes invoking vulnerable functions in open source packages. This helps in speedy triaging and prioritization of of CxSCA results.

## Pre-requisites
- Jenkins declarative pipeline
- Installed [package managers](https://checkmarx.atlassian.net/wiki/spaces/CD/pages/1975713967/CxSCA+Resolver+Package+Manager+Support) 
- Existing CxSAST scan with [imported queries](https://checkmarx.atlassian.net/wiki/spaces/CD/pages/2697101665/Query+Configuration+for+Exploitable+Path+with+Resolver)

## Setup
The sample [Jenkinsfile](Jenkinsfile) includes 4 stages; 
1. Cleanup -- Clean-up workspace
2. Checkout -- Checkout source from git repository
3. Build -- Execute maven build
4. CxSCA -- Download CxSCA resolver, and execute scans

## Miscellenous
CxSCA Resolver can also be dockerized as a base image for extension to include the relevant package managers, refer to [dockerfile](dockerfile).


# References
CxSCA Resolver [[1]]  

[1]:https://checkmarx.atlassian.net/wiki/spaces/CD/pages/2010809574/CxSCA+Resolver "CxSCA Resolver"