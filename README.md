Customized CxQL
===============

Customized queries

Version:  1.0  
Author:   Pedric Kng

# Queries

## Jackson/FasterXML

### Vulnerability
CWE 502: Command injection via deserialization
- 'Class' JsonTypeInfo annotation vulnerable
- Usage of 'EnableDefaultTyping' vulnerable

### Queries
Extend 'Corp/Java_General/Find_Unsafe_Deserializers'
