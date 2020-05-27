#!/bin/sh

while getopts u:t:n:p:l:c: option
do
case "${option}"
in
u) cxserver=${OPTARG};;
t) cxtoken=${OPTARG};;
n) projectname=${OPTARG};;
p) preset=${OPTARG};;
l) buildloc=${OPTARG};;
c) comment=${OPTARG};;
esac
done

wget -O cxcli.zip https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.2.3.zip --quiet
unzip cxcli.zip -d ./cxcli
rm -rf cxcli.zip
chmod +x ./cxcli/runCxConsole.sh

sh ./cxcli/runCxConsole.sh scan -v -cxserver "$cxserver" -cxtoken "$cxtoken" -projectname "$projectname" -locationtype 'folder' -LocationPath "$buildloc" -preset "$preset" -enableosa -executepackagedependency -Comment "$comment"