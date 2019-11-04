param([string]$resultsFile)
###### VARIABLES ######

$queries = New-Object System.Collections.ArrayList
$queriesResults = New-Object System.Collections.ArrayList
$languages = New-Object System.Collections.ArrayList
$highs = 0
$mediums = 0
$lows = 0
$infos = 0
$confirmed = 0
$not_exploitable = 0
$to_verify = 0
$high_to_verify = 0
$medium_to_verify = 0
$low_to_verify = 0
$info_to_verify = 0
$status_new = 0
$status_recurrent = 0

###### READ/PARSE FILE ######

[xml]$fileXmlContent = Get-Content $resultsFile
$nodes = $fileXmlContent.CxXMLResults
$attrs = $nodes.Attributes

###### Get Scan Config ######
$initiator = $attrs["InitiatorName"].Value
$owner = $attrs["Owner"].Value
$preset = $attrs["Preset"].Value
$projectName = $attrs["ProjectName"].Value
$projectId = $attrs["ProjectId"].Value
$teamFull = $attrs["TeamFullPathOnReportDate"].Value
$teamShort = $attrs["Team"].Value
$loc = $attrs["LinesOfCodeScanned"].Value
$files = $attrs["FilesScanned"].Value
$cxVersion = $attrs["CheckmarxVersion"].Value

$scanId = $attrs["ScanId"].Value
$scanLink = $attrs["DeepLink"].Value
$scanComments = $attrs["ScanComments"].Value
$scanType = $attrs["ScanType"].Value
$sourceOrigin = $attrs["SourceOrigin"].Value
$scanStart = $attrs["ScanStart"].Value

$reportCreationTime = $attrs["ReportCreationTime"].Value

$description = "Scan Link : " + $scanLink +
               "`nProject Name : " + $projectName +
               "`nProject ID : "  + $projectId +
               "`nPreset : "  + $preset +
               "`nLOC : "  + $loc +
               "`nFiles Count : "  + $files +
               "`nCX Version : "  + $cxVersion +
               "`nTeam : "  + $teamFull +
               "`nOwner : "  + $owner +
               "`n`nInitiator : "  + $initiator +
               "`nScan ID : "  + $scanId +
               "`nScan Type : "  + $scanType +
               "`nScan Comments : "  + $scanComments +
               "`nSource Origin : "  + $sourceOrigin +
               "`nScan Start : "  + $scanStart +
               "`nReport Creation Date : "  + $reportCreationTime

###### Get Scan Details (Results, Languages, Queries) ######
foreach($node in $nodes.ChildNodes){
    foreach($result in $node.ChildNodes){

        $state = $result.Attributes["state"].Value
        if($state.equals("0")){
            $to_verify++
        } elseif($state.equals("1")){
            $not_exploitable++
        } elseif($state.equals("2")){
            $confirmed++
        }

        $severity = $result.Attributes["Severity"].Value
        if($severity.equals("High")){
            $highs++
            if($state.equals("0")){
                $high_to_verify++
            }
        } elseif($severity.equals("Medium")){
            $mediums++
            if($state.equals("0")){
                $medium_to_verify++
            }
        } elseif($severity.equals("Low")){
            $lows++
            if($state.equals("0")){
                $low_to_verify++
            }
        } elseif($severity.equals("Information")){
            $infos++
            if($state.equals("0")){
                $info_to_verify++
            }
        }

        $status = $result.Attributes["Status"].Value
        if($status.equals("New")){
            $status_new++
        } elseif($status.equals("Recurrent")){
            $status_recurrent++
        }
    }

    $lang = $node.Attributes["Language"].Value

    if(!$languages.Contains($lang)){
        $languages.Add($lang) > $null
    }
    $queries.Add($node.Attributes["name"].Value) > $null
    $queriesResults.Add($node.ChildNodes.Count) > $null
}

###### Get Languages ######
$description = $description + "`n`nLanguages ("+ $languages.Count + ") : "
foreach($language in $languages){
    $description = $description + "`n" + $language
}

###### Get Results ######
$total = $highs + $mediums + $lows + $infos
$description = $description +
                "`n`nResults (" + $total + ") : " +
                "`n`nNew : " + $status_new +
                "`nRecurrent : " + $status_recurrent +
                "`n`nHigh : " + $highs +
                "`nMedium : " + $mediums +
                "`nLow : " + $lows +
                "`nInfo : " + $infos +
                "`n`nConfirmed : " + $confirmed +
                "`nTo Verify : " + $to_verify +
                "`nNot Exploitable : " + $not_exploitable +
                "`n`nHigh : " + $high_to_verify +
                "`nMedium : " + $medium_to_verify +
                "`nLow : " + $low_to_verify +
                "`nInfo : " + $info_to_verify +
                "`n`nQueries ("+$queries.Count+") : "

###### Get Queries ######
For($i=0; $i -le $queries.Count - 1; $i++) {
    $description = $description + "`n" + $queries[$i] + " (" + $queriesResults[$i] + ")"
}

###### Majority of APIs does not accept punctuation ######
Function Remove-Diacritics ($sToModify){
  foreach ($s in $sToModify){
    if ($sToModify -eq $null) {
        return [string]::Empty
    }
    $sNormalized = $sToModify.Normalize("FormD")

    foreach ($c in [Char[]]$sNormalized){
      $uCategory = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c)
      if ($uCategory -ne "NonSpacingMark") {
        $res += $c
      }
    }
    return $res
  }
}

$description = Remove-Diacritics $description
$summary = "New Checkmarx Scan - ${projectName} - ${scanId}"
return @($status_new, $status_recurrent, $highs, $mediums, $lows, $to_verify, $summary, $description, $scanLink)
