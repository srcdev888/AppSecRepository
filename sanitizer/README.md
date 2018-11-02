# Example on adding sanitizers
* Author:   Pedric Kng  
* Updated:  02 Nov 2018

This project showcases different sanitizers implementation and how it can be introduced into CxQL.

***
## Examples

* Method 'urlWhiteList.indexOf()' is used indirectly in [OK_SourceCode.xml](OK_SourceCode.java) to sanitize/filter parameter 'origin', this is in the detection of CORS where request header been used in 'Access-Control-Allow-Origin' to prevent CORS.
```java
  String origin = request.getHeader("Origin");

	if(urlWhiteList.indexOf(origin) != -1){
	   ((HttpServletResponse) res).setHeader("Access-Control-Allow-Origin", origin);
     ...
  }
```

```csharp
  /**
   *  Update: pedric.kng@checkmarx.com 31-OCT-2018
   *  - Parameter sanitized by urlWhiteList.indexOf
   */
  CxList validator = All.NewCxList();

  CxList urlWhiteList = allMethods.FindByMemberAccess("urlWhiteList.indexOf*");
  validator.Add(All.GetSanitizerByMethodInCondition(urlWhiteList));

  CxList storedOrigin = headerValue.InfluencedByAndNotSanitized(influencers, validator);

```
