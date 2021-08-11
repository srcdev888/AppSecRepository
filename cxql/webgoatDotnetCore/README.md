# CxQL Customization for WebGoat.NetCore
* Author:   Pedric Kng  
* Updated:  11 Aug 21

This page describes the CxQL queries provided by the ASA team for WebGoat.NetCore

***

```csharp
# General\Find_Outputs

result = base.Find_Outputs();

/*
* Author: antonio.duarte@checkmarx.com
* Date: 2021-08-03
* Version: 9.3.0
* Description: Flag xml file output
*/
CxList unknownRef = All.FindByType(typeof(UnknownReference));
CxList declarators = Find_Declarators();

CxList xmlDocument = unknownRef.FindByShortName("xmlDocument").GetMembersOfTarget().FindByShortName("Save");

result.Add(xmlDocument);

```

```csharp
# CSharp_Medium_Threat

/*
* Author: antonio.duarte@checkmarx.com
* Date: 2021-08-03
* Version: 9.3.0
* Description: credit card stored in XML file 
* 
*	<?xml version="1.0" encoding="utf-8"?>
*	<CreditCards>
*  		<CreditCard>
*    		<Username>MyUser</Username>
*    		<Number>5541466776341107</Number>
*   		<Expiry>10/1/2023 0:00:00</Expiry>
* 		</CreditCard>
*	</CreditCards>
*
*/

CxList methodDecl = Find_MethodDecls();
CxList methods = Find_Methods();
CxList unknownRef = All.FindByType(typeof(UnknownReference));


CxList SaveCardForUserMethod = methods.FindByShortName("SaveCardForUser");
CxList SaveCardForUserMethodDecl = methodDecl.FindByShortName("SaveCardForUser");

CxList path1 = SaveCardForUserMethod.ConcatenatePath(SaveCardForUserMethodDecl);

CxList InsertCardForUserMethod = methods.FindByShortName("InsertCardForUser");
CxList InsertCardForUserMethodDecl = methodDecl.FindByShortName("InsertCardForUser");

CxList path2 = path1.ConcatenatePath(InsertCardForUserMethod);
CxList path3 = path2.ConcatenatePath(InsertCardForUserMethodDecl);

CxList WriteCreditCardFile = All.GetByAncs(InsertCardForUserMethodDecl).FindByType(typeof(MethodInvokeExpr)).FindByShortName("WriteCreditCardFile");

CxList path4 = path3.ConcatenatePath(WriteCreditCardFile);

CxList xmlDocument = unknownRef.FindByShortName("xmlDocument").GetMembersOfTarget().FindByShortName("Save");

result.Add(path4.ConcatenatePath(xmlDocument.DataInfluencedBy(All.GetParameters(WriteCreditCardFile))));

/*
* Author: antonio.duarte@checkmarx.com
* Date: 2021-08-03
* Version: 9.3.0
* Description: user info in txt file
*/

result += All.FindByRegexExt("<Number>").FindByFileName("*.xml");
result += All.FindByRegexExt("jeffortson").FindByFileName("*.txt");
result += All.FindByRegexExt("kmitnick").FindByFileName("*.txt");
result += All.FindByRegexExt("RapPayne").FindByFileName("*.txt");
result += All.FindByRegexExt("rappayne").FindByFileName("*.txt");

```

```csharp
# CSharp_High_Risk

result = base.SQL_Injection();

/*
* Author: antonio.duarte@checkmarx.com
* Date: 2021-08-03
* Version: 9.3.0
* Description: Flag sql injection results 
*/
CxList methods = Find_Methods();
CxList declarators = Find_Declarators();
CxList methodDecl = Find_MethodDecls();

CxList inputs = Find_Interactive_Inputs().FindByFileName("*checkoutcontroller.cs");

CxList order = declarators.FindByShortName("order");

List<string> dangerousInputs = new List<string>(){
		"ShippingMethod",
		"ShipTarget",
		"Address",
		"City",
		"Region",
		"PostalCode",
		"Country"
		};

inputs = All.FindAllReferences(inputs.FindByShortName("model")).GetMembersOfTarget().FindByShortNames(dangerousInputs);
inputs -= All.GetByAncs(methods.FindByShortName("GetShipperByShipperId"));

CxList order_path = order.DataInfluencedBy(inputs);

CxList createOrderMethod = methods.FindByShortName("CreateOrder");
CxList createOrderRepMethodDecl = methodDecl.FindByShortName("CreateOrder");
CxList createOrderRepMethodDeclAncs = All.GetByAncs(createOrderRepMethodDecl);

CxList path1 = order_path.ConcatenatePath(createOrderMethod);

//flow between create orders methods
CxList createOrderFlow = path1.ConcatenateAllPaths(All.GetParameters(createOrderRepMethodDecl));

CxList createOrderFlowEndNodes = createOrderFlow.GetStartAndEndNodes(CxList.GetStartEndNodesType.EndNodesOnly);

CxList orderReferences = All.FindAllReferences(createOrderFlowEndNodes).GetMembersOfTarget();


CxList firstFlow = All.NewCxList();

//create first flow
foreach(CxList cof in createOrderFlow.Clone().GetCxListByPath()) {
	
	CxList firstFlowAllNodes = cof.GetStartAndEndNodes(CxList.GetStartEndNodesType.AllNodes);
	
	CxList firstFlowSearch = createOrderRepMethodDeclAncs.FindByShortName(firstFlowAllNodes.FindByShortName(orderReferences));
	
	firstFlow.Add(cof.ConcatenatePath(firstFlowSearch));

}

//db out
CxList executeReader = methods.FindByShortName("ExecuteReader");

//create second flow
foreach(CxList ff in firstFlow.Clone().GetCxListByPath()) {
	
	CxList secondFlowEndNodes = ff.GetStartAndEndNodes(CxList.GetStartEndNodesType.EndNodesOnly);
	CxList secondFlow = executeReader.DataInfluencedBy(secondFlowEndNodes);
	
	//create final flow
	result.Add(ff.ConcatenatePath(secondFlow));

}

```

## References
WebGoat.NetCore [[1]]  

[1]:https://github.com/tobyash86/WebGoat.NET "WebGoat.NetCore"
