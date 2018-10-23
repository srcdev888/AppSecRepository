# Example using CxxPath API
* Author:   Pedric Kng  
* Updated:  23 Oct 2018

The purpose of this project is to share XML query via CxAudit using cxXPath APIs.
***
## cxXPath
cxXPath is available since 8.6.0 and is a wrapper of .NET’s XPath C# API. Note that malformed XML is not supported i.e., missing xml header.

The example based on [books.xml](books.xml) illustrates
* Retrieve 'book' nodes that contains author named "Corets, Eva"

```csharp
foreach (CxXmlDoc doc in cxXPath.GetXmlFiles("books.xml", true)) {
  //declaration of a navigator for <book> node
  string xPath = @"/catalog/book[author = 'Corets, Eva']";

  XPathNavigator navigator = doc.CreateNavigator();  
  XPathNodeIterator nodeIterator = navigator.Select(xPath);

  foreach(XPathNavigator bookNode in nodeIterator) {
    result.Add(cxXPath.CreateXmlNode(bookNode, doc, 8, true));
  }
}
```


### References
How to navigate XML with the XPathNavigator class by using Visual C# [[1]]  
XPath Examples [[2]]  
CxAudit Guide [[3]]  


[1]:https://support.microsoft.com/en-sg/help/308343/how-to-navigate-xml-with-the-xpathnavigator-class-by-using-visual-c "How to navigate XML with XPathNavigator class by using Visual C#"
[2]:https://msdn.microsoft.com/en-us/library/ms256086(v=vs.110).aspx "XPath Examples"
[3]:https://checkmarx.atlassian.net/wiki/spaces/KC/pages/5406733/CxAudit+Overview "CxAudit Guide"
