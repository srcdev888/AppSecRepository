# Example using CxxPath API
* Author:   Pedric Kng  
* Updated:  23 Oct 2018

The purpose of this project is to share XML query via CxAudit using cxXPath APIs.
***
## cxXPath
cxXPath is available since 8.6.0 and is a wrapper of .NET’s XPath C# API. Note that malformed XML is not supported i.e., missing xml header.

### Examples

* Retrieve 'book' nodes in [books.xml](books.xml) that contains author named "Corets, Eva"

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

* Check that encryption is enforced in session 'cookie-store' as declared via 'session-encrypters' is in [webx.xml](webx.xml) 

```csharp
try {

	// Path declaration for <session-stores> node
	string xPathStore = @"/beans:beans/services:request-contexts/" +
		"request-contexts:session/stores/session-stores:cookie-store" +
		"[count(.//session-encrypters:aes-encrypter)=0]" +
		"";

	foreach (CxXmlDoc doc in cxXPath.GetXmlFiles(@"webx.xml", true)) {

		// XPath Navigator
		XPathNavigator navigator = doc.CreateNavigator();  

		// Register namespace
		XmlNamespaceManager manager = new XmlNamespaceManager(navigator.NameTable);  
		manager.AddNamespace("beans", "http://www.springframework.org/schema/beans");  
		manager.AddNamespace("services", "http://www.alibaba.com/schema/services");
		manager.AddNamespace("request-contexts", "http://www.alibaba.com/schema/services/request-contexts");
		manager.AddNamespace("session-stores", "http://www.alibaba.com/schema/services/request-contexts/session/stores");
		manager.AddNamespace("session-encoders", "http://www.alibaba.com/schema/services/request-contexts/session/encoders");
		manager.AddNamespace("session-encrypters", "http://www.alibaba.com/schema/services/request-contexts/session/encrypters");

		// Declaration of a navigator for <session-stores> node
		XPathExpression storeQuery = navigator.Compile(xPathStore);
		storeQuery.SetContext(manager);  
		XPathNodeIterator storeIterator = navigator.Select(storeQuery);

		foreach(XPathNavigator storeNode in storeIterator) {
			result.Add(cxXPath.CreateXmlNode(storeNode, doc, 2, true));
		}
	}

}catch(Exception e){
	cxLog.WriteDebugMessage(e.Message);
}
```


### References
How to navigate XML with the XPathNavigator class by using Visual C# [[1]]  
XPath Examples [[2]]  
CxAudit Guide [[3]]  


[1]:https://support.microsoft.com/en-sg/help/308343/how-to-navigate-xml-with-the-xpathnavigator-class-by-using-visual-c "How to navigate XML with XPathNavigator class by using Visual C#"
[2]:https://msdn.microsoft.com/en-us/library/ms256086(v=vs.110).aspx "XPath Examples"
[3]:https://checkmarx.atlassian.net/wiki/spaces/KC/pages/5406733/CxAudit+Overview "CxAudit Guide"
