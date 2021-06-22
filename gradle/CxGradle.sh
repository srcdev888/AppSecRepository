#!/bin/sh
USERNAME="admin@cx"
PASS="You Password"
CX_HOST="http://192.168.1.10"
PROFILE="All"
CX_TEAM=CxServer\\SP\\Company\\Users\\
ENABLE_OSA=""
OSA_REPORT=""

# ###############################################
CX_CONSOLE_PATH=/home/andy/Documents/CxConsole
CX_XSLT=$CX_CONSOLE_PATH/extras

# locate xsltproc
XSLT_EXE=xsltproc
# ##############################################

HIGH_VULNERABILITY_THRESHOLD=0
MEDIUM_VULNERABILITY_THRESHOLD=0

while getopts "p:n:t:h:m:s:r:e" arg; do
	case $arg in
		p)
			echo "Profile: " $OPTARG
			PROFILE=$OPTARG
			;;
		n)
			echo "ProjectName: " $OPTARG
			PROJECT=$OPTARG
			;;
		t)
			echo "Team: " $OPTARG
			CX_TEAM=$OPTARG
			;;
			
		r)
			echo "OsaReportPDF: " 
			OSA_REPORT="-OsaReportPDF"
			;;
			
		e)
			echo "EnableOSA: " 
			ENABLE_OSA="-EnableOsa"
			;;
		h)
			echo "High Threshold: " $OPTARG
			HIGH_VULNERABILITY_THRESHOLD=$OPTARG
			;;
		m)
			echo "Medium Threshold: " $OPTARG
			MEDIUM_VULNERABILITY_THRESHOLD=$OPTARG
			;;
		s)
			echo "Source Path: " $OPTARG
			SOURCE_PATH=$OPTARG
			;;

	esac
done



if [ -z $WORKSPACE ]
then
    WORKSPACE=.
    JOB_NAME=CxDemo
fi

echo WORKSPACE $WORKSPACE
CX_RESULTS_XML=CxResults.xml
CX_RESULTS_PDF=CxResults.pdf
CX_RESULTS_HTML=CxResults.html
CX_LOG=$WORKSPACE/${JOB_NAME}/logs

CX_CONSOLE_EXE=$CX_CONSOLE_PATH/runCxConsole.sh
XSLT_HTML_OUTPUT=CxResult.xslt
XSLT_VULN_COUNT=CxHigh.xslt

echo $CX_RESULTS_XML
echo $CX_RESULTS_PDF
echo $CX_RESULTS_HTML
echo $CX_CONSOLE_EXE

if [ -f $CX_RESULTS_HTML ] 
then
 rm  $CX_RESULTS_HTML
fi
if [ -f $CX_RESULTS_PDF ] 
then
 rm  $CX_RESULTS_PDF
fi
if [ -f $CX_RESULTS_XML ] 
then
  rm  $CX_RESULTS_XML
  echo "$CX_RESULTS_XML"
fi

echo XML Report $CX_RESULTS_XML

# Scan the workspace, saving the results in xml and pdf

$CX_CONSOLE_EXE Scan -CxServer $CX_HOST -ProjectName $CX_TEAM$PROJECT -CxUser $USERNAME -CxPassword "$PASS" -LocationType folder -LocationPath $SOURCE_PATH -reportPDF "$CX_RESULTS_PDF" -reportXML "$CX_RESULTS_XML" -Preset $PROFILE $ENABLE_OSA $OSA_REPORT

[ -f $CX_CONSOLE_PATH/$PROJECT/$CX_RESULTS_XML ] && echo found || echo not found


# Process the xml results if they exist

    echo found xml

    $XSLT_EXE  -o "$CX_CONSOLE_PATH/$PROJECT/$CX_RESULTS_HTML" "$CX_XSLT/$XSLT_HTML_OUTPUT" "$CX_CONSOLE_PATH/$PROJECT/$CX_RESULTS_XML" 


    RES=`$XSLT_EXE "$CX_XSLT/$XSLT_VULN_COUNT" "$CX_CONSOLE_PATH/$PROJECT/$CX_RESULTS_XML" `
    
    HIGH=`echo "$RES"   | awk '/High/ { print $2; }'`
    MEDIUM=`echo "$RES" | awk '/Medium/ { print $2; }'`
    if [ $HIGH -gt $HIGH_VULNERABILITY_THRESHOLD -o $MEDIUM -gt $MEDIUM_VULNERABILITY_THRESHOLD ]
    then
        echo "Threshold exceeded"
	echo Found $HIGH, Policy was $HIGH_VULNERABILITY_THRESHOLD
	echo Found $MEDIUM, Policy was $MEDIUM_VULNERABILITY_THRESHOLD
		exit 1
    fi