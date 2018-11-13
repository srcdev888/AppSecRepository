# Example on adding sanitizers
* Author:   Pedric Kng  
* Updated:  02 Nov 2018

This project showcases different sanitizers implementation and how it can be introduced into CxQL.
* [Detect sanitizer used in method condition](#Detect-sanitizer-used-in-method-condition)
* [Paired hook sanitizers](#Paired-hook-sanitizers)

***
### Detect sanitizer used in method condition
 Method 'urlWhiteList.indexOf()' is used indirectly in [OK_SourceCode.xml](OK_SourceCode.java) to sanitize/filter parameter 'origin', this is in the detection of CORS where request header been used in 'Access-Control-Allow-Origin' to prevent CORS.
```java
// Source Code
  String origin = request.getHeader("Origin");

	if(urlWhiteList.indexOf(origin) != -1){
	   ((HttpServletResponse) res).setHeader("Access-Control-Allow-Origin", origin);
     ...
  }
```
```csharp
// CxQL
  /**
   * Tested on CxSAST 8.9
   * Update: pedric.kng@checkmarx.com 31-OCT-2018
   *  - Parameter sanitized by urlWhiteList.indexOf
   */
  CxList validator = All.NewCxList();

  CxList urlWhiteList = allMethods.FindByMemberAccess("urlWhiteList.indexOf*");
  validator.Add(All.GetSanitizerByMethodInCondition(urlWhiteList));

  CxList storedOrigin = headerValue.InfluencedByAndNotSanitized(influencers, validator);
```

### Paired hook sanitizers
Paired hook sanitizers 'startSSRFNetHookCheckingWithExpirationCache', 'startSSRFNetHookChecking' and 'stopSSRFNetHookChecking' is implemented to prevent SSRF attacks in [ThreadSSRFHook.java](ThreadSSRFHook.java)
```java
// Source Code
  try {
    SecurityUtil.startSSRFNetHookChecking();
    HttpClient client = HttpClients.createDefault();
    HttpGet get = new HttpGet(urlNameString);
    HttpResponse response = client.execute(get);
  } catch (Exception e) {
    throw e;
  } finally {
    SecurityUtil.stopSSRFNetHookChecking();
  }
```
```java
// CxQL
  /**
  *  Update: pedric.kng@checkmarx.com 09-NOV-2018 - Detect no usage of Aliyun SSRFNetHook
  */
  CxList methods = Find_Methods();
  CxList allStatementCollection = Find_StatementCollection();
  // Find SSRF start methods
  CxList startSSRF = All.NewCxList();
  startSSRF.Add(methods.FindByMemberAccess("SecurityUtil.startSSRFNetHookCheckingWithExpirationCache"));
  startSSRF.Add(methods.FindByMemberAccess("SecurityUtil.startSSRFNetHookChecking"));
  // Find SSRF stop methods
  CxList stopSSRF = methods.FindByMemberAccess("SecurityUtil.stopSSRFNetHookChecking");
  // Find usage of client.execute
  CxList Sinks = methods.FindByMemberAccess("HttpClient.execute*");
  // Loop through sink
  foreach(CxList sink in Sinks){

	// Find ancs of type TryCatchFinally Stmt
	CxList Trys = sink.GetAncOfType(typeof(TryCatchFinallyStmt));

	// If sink must have anc of type 'TryCatchFinallyStmt'
	if(Trys.Count > 0){
		foreach(CxList tryCatch in Trys){
			try{
				TryCatchFinallyStmt tryGraph = tryCatch.TryGetCSharpGraph<TryCatchFinallyStmt>();
        CxList TryBlocks = All.NewCxList();
        CxList FinallyBlocks = All.NewCxList();
        TryBlocks.Add(tryGraph.Try.NodeId, tryGraph.Try);
        FinallyBlocks.Add(tryGraph.Finally.NodeId, tryGraph.Finally);

        // Check for startSSRF
        CxList startFound = startSSRF.GetByAncs(TryBlocks);
        if(startFound.Count > 0){

					// Check for stop SSRF
					CxList stopFound = All.NewCxList();
					stopFound.Add(stopSSRF.GetByAncs(TryBlocks));
					stopFound.Add(stopSSRF.GetByAncs(FinallyBlocks));
					if(stopFound.Count > 0){
						requests -= sink;
					}
				}
			}catch(Exception ex){
				cxLog.WriteDebugMessage(ex);		
			}
		}

	}
}
```

*
