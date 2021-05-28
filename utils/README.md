# Quick guide on Java Keytool

* Author:   Pedric Kng
* Updated:  28-May-21
* Purpose:  This article is a quick guide with Java keytool 

# Abbreviations
| Label | Description |  
| --- | --- |
| jks | Java keystore filetype |
| pfx | PKCS#12 keystore | 
| p7b | PKCS#7 Certificate chain, usually reply from certificate signing request |
| cer | X509 certificate |
| csr | certificate signing request | 

# Contents
* [Generate Self-signed Subject Alternate Name(SAN) Certificate](#Generate-Self-signed-Subject-Alternate-Name(SAN)-Certificate)
* [Convert from keystore to pfx format](#Convert-from-keystore-to-pfx-format)
* [List keystore](#List-keystore)
* [Export certificate(cer)](#Export-certificate(cer))
* [Generate certificate signing request(csr)](#Generate-certificate-signing-request(csr))
* [Print certificate signing request(csr)](#Print-certificate-signing-request(csr))
* [Import certificate signing reply(p7b) or X509 certificate(cer)](#Import-certificate-signing-reply(p7b)-or-X509-certificate(cer))
* [Change key alias](#Change-key-alias)

## Generate Self-signed Subject Alternate Name(SAN) Certificate

The command below will create a pkcs12 Java keystore server.jks with a self-signed SSL certificate:
- Two types are supported for external extensions;
  - IP - refers to the site IP address
  - DNS - refers to the site name as recognized by the DNS

```bash
keytool ^
 -keystore "server.jks" -storepass "mysecret" ^
 -alias "10.100.0.1" ^
 -deststoretype pkcs12 ^
 -genkeypair -keyalg RSA -validity 365 ^
 -dname "CN=10.100.0.1" ^
 -ext "SAN=IP:10.100.0.1"
```

## Convert from keystore to pfx format
The command below will copy the key and cert inside the JKS keystore into PKCS12 format
```bash
keytool -importkeystore ^
    -srckeystore "server.jks" ^
    -destkeystore "server.pfx" ^
    -deststoretype PKCS12 ^
    -srcstorepass "mysecret" ^
    -deststorepass "mysecret"
```

## List keystore
```bash
keytool -list -v ^
    -keystore "server.jks" ^
    -storepass "mysecret"
```

## Export certificate(cer)
```bash
keytool -exportcert ^
    -alias "10.100.0.1" ^
    -file "10.100.0.1.cert" ^
    -keystore "server.jks" ^
    -storepass "mysecret"
```

## Generate certificate signing request(csr)
```bash
keytool -certreq ^
    -alias "10.100.0.1" ^
    -file "10.100.0.1.csr" ^
    -keystore "server.jks" ^
    -storepass "mysecret"
```
## Print certificate signing request(csr)
```bash
keytool -printcertreq ^
    -file "10.100.0.1.csr" ^
```

## Import certificate signing reply(p7b) or X509 certificate(cer)

```bash
keytool -importcert ^
    -alias "10.100.0.1" ^
    -file "10.100.0.1.p7b" ^
    -keystore "server.jks" ^
    -storepass "mysecret" ^
    -keypass "mysecret"
```

Specify '-trustcacerts' and keytool will attempt to construct chain of command using cacerts keystore installed with JRE.

## Change key alias
```bash
keytool -changealias ^
    -alias "current-alias" ^
    -destalias "new-alias" ^
    -keypass "keypass" ^
    -keystore "server.jks" ^
    -storepass "mysecret"
```


# References
Simple way to generate a Subject Alternate Name (SAN) certificate [[1]]  
keytool - Key and Certificate Management Tool [[2]]  
Generate self-signed certificates with the .NET CLI [[3]]  
"How Can I Get Public And Private Keys Out Of IIS?" [[4]]

[1]: https://ultimatesecurity.pro/post/san-certificate "Simple way to generate a Subject Alternate Name (SAN) certificate"
[2]:https://docs.oracle.com/javase/7/docs/technotes/tools/solaris/keytool.html "keytool - Key and Certificate Management Tool"
[3]:https://docs.microsoft.com/en-us/dotnet/core/additional-tools/self-signed-certificates-guide "Generate self-signed certificates with the .NET CLI"
[4]:https://support.accessdata.com/hc/en-us/articles/207830957-How-can-I-get-public-and-private-keys-out-of-IIS- "How Can I Get Public And Private Keys Out Of IIS?"