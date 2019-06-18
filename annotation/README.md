# Example checking for annotation and its attribute
* Author:   Pedric Kng  
* Updated:  02 Nov 2018

Spring 4.2 has introduced @CrossOrigin annotation to handle Cross-Origin-Resource-Sharing (CORS). This annotation is used at class level as well as method level in RESTful Web service controller.

Usage of 'CrossOrigin' annotation could prevent CORS but wrong usage could lead to vulnerabilities i.e., not specifying a 'origins' attribute or wildcard usage.
Example of correct usage: @CrossOrigin(origins = http://localhost:9000)

***
## Examples

* Retrieve 'CrossOrigin' nodes in [Error_SpringFrameConfig.xml](Error_SpringFrameConfig.java) where attribute 'origins' is not declared or wildcard is specified in the attribute value.
```java
// Source Code
  public class Error_SpringFrameConfig {
    @CrossOrigin
    @RestController
    public class ChannelController {
      public void test(){
      }
    }
    @CrossOrigin(origins="*")
    @RestController
    public class AllOriginsController {
      public void test(){
      }
    }
    @CrossOrigin(origins = "http://domain2.com")
    @RestController
    public class DomainOriginsController {
      public void test(){
      }
    }
  }
```
```csharp
// CxQL
  /**
   * Tested on CxSAST 8.9
   * Update: pedric.kng@checkmarx.com 29-OCT-2018 - Detect CrossOrigin annotations
   */
   CxList crossOriginAnnotations = Find_CustomAttribute().FindByCustomAttribute("CrossOrigin");
   cxLog.WriteDebugMessage("crossOriginAnnotations>Count: " + crossOriginAnnotations.Count);

   foreach(CxList crossOriginAnn in crossOriginAnnotations){
     // Look for annotation attributes @CrossOrigin(origins="*")
     CxList crossOriginExpr = All.GetByAncs(crossOriginAnn).FindByType(typeof(AssignExpr));
     cxLog.WriteDebugMessage("crossOriginExpr>Count: " + crossOriginExpr.Count);
     // Add to result if there is no attribute
     if(crossOriginExpr.Count == 0){
       result.Add(crossOriginAnn);
     }else{
       // Find the attribute 'origin="*"'
       CxList wildcardOrigins = All.GetByAncs(crossOriginExpr).FindByAssignmentSide(CxList.AssignmentSide.Left).FindByShortName("origins").GetAssigner().FindByType(typeof(StringLiteral)).FindByRegex("\"\\*\"");
       cxLog.WriteDebugMessage("wildcardOrigins>Count: " + wildcardOrigins.Count);
       if(wildcardOrigins.Count != 0) result.Add(crossOriginAnn);
     }
   }
```
