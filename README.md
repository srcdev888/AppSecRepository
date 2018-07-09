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

```bash
      ObjectMapper om = new ObjectMapper();
      om.enableDefaultTyping();
      Object o = om.readValue(json, List.class);
```

- Usage of 'EnableDefaultTyping' vulnerable

```bash
```

### Queries
Extend 'Corp/Java_General/Find_Unsafe_Deserializers'
