# Powershell Quick guide: Generating self signed certificate

* Author:   Pedric Kng
* Updated:  14-Jun-21
* Purpose:  This article is a quick guide to generate self-signed certificate with powershell

***
Execute below with powershell ISE with administrator rights

```powershell

$Params = @{
    "Subject"           = "CN=192.168.137.255"
    "DnsName"           = @("mywebsite.com","www.mywebsite.com")
    "CertStoreLocation" = "Cert:\LocalMachine\My"
    "NotAfter"          = (Get-Date).AddYears(5)
    "KeyAlgorithm"      = "RSA"
    "KeyLength"         = "2048"
}

New-SelfSignedCertificate @Params

```
# References
How to Create a Self-Signed Certificate with PowerShell [[1]]  
Create a Self-Signed Server Certificate in IIS [[2]]  


[1]: http://woshub.com/how-to-create-self-signed-certificate-with-powershell/ "How to Create a Self-Signed Certificate with PowerShell"
[2]: https://checkmarx.atlassian.net/wiki/spaces/SD/pages/2880045528/Create+a+Self-Signed+Server+Certificate+in+IIS "Create a Self-Signed Server Certificate in IIS"

