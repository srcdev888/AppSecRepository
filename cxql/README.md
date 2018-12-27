# Miscellaneous CxQL Exercises
* Author:   Pedric Kng  
* Updated:  29 Nov 2018

## Basic Exercises
* [Quick elimination of SQL Injection using CxAudit UI](#Quick-elimination-of-SQL-Injection-using-CxAudit-UI)
* [Finding sources and sinks](#Finding-sources-and-sinks)
* [Building flows](#Building-flows)
* [Adding proprietary sanitizers](#Adding-proprietary-sanitizers)

## Advanced Exercises
* [Filter based on iteration statement conditions](#Filter-based-on-iteration-statement-conditions)
* [Sanitize path by node](#Sanitize-path-by-node)
* [Find String array](#Find-string-array)

***
## Basic Exercises
### Quick elimination of SQL Injection using CxAudit UI
This exercise [AccountDao.cs](SQLi/AccountDao.cs) illustrates 4 scenarios using CxAudit quick add functionality;
1. Parameters not sanitized leading to a SQL injection
2. Parameters are sanitized using prepared statements
3. Sanitization method not recognized not CxSAST; add to sanitizers
4. Interactive input not detected; add to interactive inputs

### Finding sources and sinks
This exercise consists of 3 parts based on [1.cs](basic/Exercise-1/1.cs);
1. Find all nodes whose name is "input" (not case sensitive)
```csharp
CxList nodesNamedInput = All.FindByName("*input", false);
result = nodesNamedInput;
```

2. Find all methods whose name is "input" (not case sensitive)
```csharp
CxList methodNamedInput = All.FindByName("*input", false).FindByType(typeof(MethodDecl));
result = methodNamedInput;
```

3. Find all nodes whose name is "input" (not case sensitive) under an "if" statement
```csharp
CxList blocks = All.GetBlocksOfIfStatements(true);
result = nodesNamedInput.GetByAncs(blocks);
```

### Building flows
This exercise consists of 2 parts based on [2.cs](basic/Exercise-2/2.cs);

1. Build Flow from input to sink, where:
	* input is method "GetSpeed" invocation
	* sink is parameter invocation of Car.Drive

  ```csharp
CxList input = All.FindByShortName("GetSpeed").FindByType(typeof(MethodInvokeExpr));
CxList memberAccess = All.FindByMemberAccess("Car.Drive");
CxList sink1 = All.GetParameters(memberAccess);
result = input.DataInfluencingOn(sink1); //GetSpeed
  ```

2. Input is similar to previous exercise, but the sink is the parameter of method declaration "Drive" that overrides Car.Drive
```csharp
CxList methodDecl = All.FindDefinition(memberAccess);
CxList sink2 = All.GetParameters(methodDecl);
result = input.DataInfluencingOn(sink2); //GetSpeed
```

### Adding proprietary sanitizers
This exercise consists of 3 parts based on [3.cs](basic/Exercise-3/3.cs);
1. Find flow from the input to the sink.
	* The input is the method 'GetName()'
	* The sink is the first parameter of Database.execute

 ```csharp
CxList input = All.FindByShortName("GetName");
CxList sink = All.GetParameters(All.FindByMemberAccess("Database.execute"), 0);
result = input.InfluencingOn(sink);
```
2. Continuing the earlier exercise, check that Function 'encode' sanitizes the input.
```csharp
CxList input = All.FindByShortName("GetName");
CxList sink = All.GetParameters(All.FindByMemberAccess("Database.execute"), 0);
CxList sanitizer = Find_Methods().FindByShortName("encode");
result = input.InfluencingOnAndNotSanitized(sink, sanitizer);
```

3. Continuing the previous exercise, with the following addition:
	* Function 'CheckIfValid' sanitizes the input.

 ```csharp
CxList input = All.FindByShortName("GetName");
CxList sink = All.GetParameters(All.FindByMemberAccess("Database.execute"), 0);
CxList validator = All.NewCxList();
CxList sanitizer = Find_Methods().FindByShortName("encode");
validator.Add(sanitizer);
CxList checkIfValid = Find_Methods().FindByShortName("CheckIfValid");
validator.Add(All.GetSanitizerByMethodInCondition(checkIfValid));
result = input.InfluencingOnAndNotSanitized(sink, validator);
```

***
## Advanced Exercises
### Filter based on iteration statement conditions
Query: Look for flow from source to sink,
- Source:  creation of Mary object
- Sink:   writeln invoke expression

Conditions:
- Function Mary inherits from function Person and overrides the method run.
- Source and sink are in different files [b.js](mary/b.js) and [codeForBadQuery.html](mary/codeForBadQuery.html)
- Sink is located under a "for" statement of the following signature:
```js
for(int i=0; i<j; i++)
```
- Check that the test part of the iteration statement is comparing "i" to a variable (as opposed to i<10)

Assumptions:
- any iteration statement is fine e.g., for, while
- test part of the iteration statement is a single expression

Tips:
- First audit the two files and make sure that there is a flow to "Writeln" from Mary "Object creation”.

Solutions:
```csharp
CxList mary = All.FindByShortName("Mary");
CxList person = All.FindByShortName("Person");
CxList methodDecl = All.FindByType(typeof(MethodDecl));
CxList run = methodDecl.FindByShortName("run");
CxList personClass = person.FindByType(typeof(ClassDecl));
personClass = personClass.GetClass(run);
CxList inheritsFromPerson = mary.InheritsFrom(personClass);
CxList marytyperef = mary.FindByType(typeof(TypeRef));
CxList relevantObjCreate = marytyperef.FindAllReferences(inheritsFromPerson).GetAncOfType(typeof(ObjectCreateExpr));
CxList methods = Find_Methods();

// Find if in for loop
CxList writeln = methods.FindByShortName("writeln", false);
CxList iter = writeln.GetAncOfType(typeof(IterationStmt));
CxList sink = All.NewCxList();
foreach(CxList l in iter)
{
	// find the condition
	IterationStmt it = l.GetFirstGraph() as IterationStmt;
	CxList cond = All.FindById(it.Test.NodeId);
	if( All.FindByShortName("i").GetByAncs(cond).Count > 0)
		sink.Add(writeln.GetByAncs(l));
}

// Get the flow from sources to sinks
CxList tempResult = relevantObjCreate.InfluencingOn(sink);

// Make sure source and sink are at different files
foreach(CxList l2 in tempResult.GetCxListByPath())
{
	CxList s = l2.GetStartAndEndNodes(Checkmarx.DataCollections.CxQueryProvidersInterface.CxList.GetStartEndNodesType.StartNodesOnly);
	CxList e = l2.GetStartAndEndNodes(Checkmarx.DataCollections.CxQueryProvidersInterface.CxList.GetStartEndNodesType.EndNodesOnly);

	CSharpGraph gs = s.GetFirstGraph() as CSharpGraph;
	string firstFile = gs.LinePragma.FileName;

	CSharpGraph ge = e.GetFirstGraph() as CSharpGraph;
	string lastFile = ge.LinePragma.FileName;

	if(!firstFile.Equals(lastFile))
	{
		result.Add(l2);
	}

}
```

### Sanitize path by node
This exercise illustrates an example of extending a SSRF query to sanitize by a specific node 'addParameter'.
The sample code is located in [TestSSRFController.java](TestSSRFController.java)

```csharp
result = base.SSRF();

CxList sanitizeNodes = All.FindByMemberAccess("URIBuilder.addParameter");
result = result.SanitizeCxList(sanitizeNodes);
```

### Find String array
This exercise seeks to find variable declarator of Java String array type.

```java
	String notAnArray;
	String[] isAnArray;
```

The below CxQL uses the unique property 'Checkmarx.Dom.RankSpecifierCollection' to identify the array.

```csharp
// Find all declarators
CxList allDeclarators = All.FindByType(typeof(Declarator));

// Find all generic type refs
CxList genericTypeRefs = All.FindByType(typeof(GenericTypeRef));

// Transverse all the declarators
CxList mylist = All.NewCxList();
foreach(CxList declarator in allDeclarators){

	// Find variable decl stmt
	CxList tmp = declarator.GetAncOfType(typeof(VariableDeclStmt));

	// Find type reference of 'string', remove the genericTypeRefs
	CxList typeRef = All.GetByAncs(tmp).FindByType(typeof(TypeRef)).FindByShortName("string");
	typeRef -= genericTypeRefs;

	if(typeRef != null){
		cxLog.WriteDebugMessage("found string");

		TypeRef type = typeRef.TryGetCSharpGraph<TypeRef>();
		if(type != null){
			Checkmarx.Dom.RankSpecifierCollection ranks = type.ArrayRanks;
			if(ranks.Count != 0){
				mylist.Add(typeRef);
			}
		}
	}
}
result = mylist;
```
