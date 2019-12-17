# Power Query Example for CxSAST OData
* Author:   Pedric Kng  
* Updated:  17 Dec 2019

CxSAST OData examples using Power Query
* [List last scans of CxSAST projects ](#List-last-scans-of-CxSAST-projects)
* [Check if result query is of OWASP TOP 10 category](#Check-if-result-query-is-of-OWASP-TOP-10-category)

***

## List last scans of CxSAST projects

```PowerQuery
let
    Source = OData.Feed("http://192.168.137.45/Cxwebinterface/odata/v1/Projects?$expand=LastScan($expand=Results)"),
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Id", "Name", "LastScanId"})
in
    #"Removed Other Columns"
```

## Check if result query is of OWASP TOP 10 category

```PowerQuery
let
    Id=Number.ToText(1),
    ScanId=Number.ToText(1060719),
    ServiceUrl="http://192.168.137.45/Cxwebinterface/odata/v1/Results(Id=" & Id & ",ScanId=" & ScanId & ")/Query?$expand=QueryCategories($filter=TypeId eq 6)",
    ResultSource = OData.Feed(ServiceUrl, null,
    [
      Query=[],
      ODataVersion=4
    ])
in
    ResultSource
```
