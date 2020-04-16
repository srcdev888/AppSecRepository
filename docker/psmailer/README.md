# Powershell script mailer
* Author: Pedric Kng
* Updated: 15 Apr 2020

Illustrate how to use powershell script to send email over SMTP


***
## Overview
This article will leverage on powershell script ['SendEmail.ps1'](SendEmail.ps1) to send email over SMTP. We will cover the following scenarios;
1. [Walkthrough powershell script](#Walkthrough-powershell-script)
2. [Integration into Gitlab CI](#Integration-into-Gitlab-CI)


## Walkthrough powershell script
The powershell script ['SendEmail.ps1'](SendEmail.ps1) uses powershell function Send-MailMessage[[1]] to send out email messages, and encapsulates common arguments.

| Arguments     | Type               | Description               |
| ------------- |-----------|-----------------|
| -from            | String     | Email author|
| -to           | String[] | Receipients, support multiple separated by ',' |
| -subject            |  String | Email subject|
| -body            | String | Email Body|
| -bodyAsHtml            | Switch | Body includes HTML |
| -attachments            | String[] | Attachments, support multiple separated by ','|
| -smtpServer            | String | SMTP Server URL|
| -smtpPort            | String | SMTP Server port|
| -smtpUsername            | String | SMTP login username|
| -smtpPassword            | String | SMTP login password|
| -smtpUseSSL            | Switch | Smtp use SSL, default=true|
| -DeliveryNotificationOption            | String[] | Delivery notification option|

```powershell
# See script parameters
PS > Get-Help SendEmail.ps1 -Detailed

# Send an email
PS > .\SendEmail.ps1 -from 'from <from@gmail.com>' -to 'to <to@gmail.com>' -subject 'test' -body @"
<p>Here is your scan report</p>
"@ -attachments "BookstoreDemo_Net@TFSBuild.pdf","WebGoat.Net@TFSBuild.pdf" -smtpServer 'smtp.gmail.com' -smtpUsername '*********' -smtpPassword '*********' -DeliveryNotificationOption 'OnSuccess'
```

## Integration into Gitlab CI
```yml
# .gitlab-ci.yml



```



## References
Powershell Send-MailMessage [[1]]  

[1]:https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/send-mailmessage "Powershell Send-MailMessage"
