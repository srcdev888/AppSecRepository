# MyBatis Vulnerable Example
* Author:   Pedric Kng
* Updated:  01 August 2018

***

## MyBatis Framework
MyBatis is a fork of iBatis since 2012; java persistence framework, iBatis has been discontinued since the birth of MyBatis

This example was build on the latest Version 3.4.6 (March 11, 2018)

### Includes
The example illustrates;
* [XML-based Configuration and/or Mapper](src/main/java/com/concretepage/village)
* [Java API Mapper](src/main/java/com/concretepage/user)
* [Dynamic SQL (not to be confused with MyBatis Dynamic SQL)](src/main/java/com/concretepage/village)
* [Java Annotation (Lack in flexibility and capabilities)](src/main/java/com/concretepage/blog)

### Vulnerabilities
MyBatis is vulnerable to SQL injection due to sql concatenation function using '$', illustrated in the example;
* [UserMapper :: getUserByFirstname](src/main/resources/com/concretepage/user/UserMapper.xml)
* [VillageMapper :: selectVillageByName](src/main/resources/com/concretepage/village/VillageMapper.xml)
* [VillageMapper :: selectVillageByCountryAndDistrict](src/main/resources/com/concretepage/village/VillageMapper.xml)


### References
MyBatis Official Website [[1]]  
Fixing SQL Injection in MyBatis [[2]]  
Dynamic SQL [[3]]  


[1]:http://www.mybatis.org/ "MyBatis Official Website"
[2]:https://software-security.sans.org/developer-how-to/fix-sql-injection-in-java-mybatis "Fixing SQL Injection in MyBatis"
[3]:http://www.mybatis.org/mybatis-3/dynamic-sql.html "Dynamic SQL"
