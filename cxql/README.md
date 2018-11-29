# Miscellaneous CxQL Exercises
* Author:   Pedric Kng  
* Updated:  29 Nov 2018

## Basic Exercises
* [SQL Injection](#SQL-Injection)

## Advanced Exercises
* [Filter based on iteration statement conditions](#Filer-based on-iteration-statement-conditions)

***
## Basic Exercises
### SQL Injection
This exercise demostrates 4 scenarios using CxAudit UI features e.g., add to sanitizers;
1. Parameters not sanitized leading to a SQL injection
2. Parameters are sanitized using prepared statements
3. Sanitization method not recognized not CxSAST; add to sanitizers
4. Interactive input not detected; add to inputs

###

***
## Advanced Exercises
### Filer based on iteration statement conditions
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
