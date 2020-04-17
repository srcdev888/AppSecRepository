#! /usr/bin/pwsh

<#
.SYNOPSIS
Powershell script to send email via 'Send-MailMessage'

.DESCRIPTION
Powershell script to send email via 'Send-MailMessage'

.PARAMETER from
Email author

.PARAMETER to
Receipients, support multiple separated by ','

.PARAMETER subject
Subject

.PARAMETER body
Body

.PARAMETER bodyAsHtml
Body includes HTML

.PARAMETER attachments
Attachments, support multiple separated by ','

.PARAMETER smtpServer
SMTP Server URL

.PARAMETER smtpPort
SMTP Server port

.PARAMETER smtpUsername
SMTP login username

.PARAMETER smtpPassword
SMTP login password

.PARAMETER smtpUseSSL
SMTP use SSL, default=true

.PARAMETER DeliveryNotificationOption
Delivery notification option

.LINK
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/send-mailmessage

.NOTES
Author: Pedric Kng
Date:   April 15, 2020

#>

param(
	[Parameter(Mandatory, HelpMessage="From")]
	[string]$from,

	[Parameter(Mandatory, HelpMessage="To")]
	[string[]]$to,

	[Parameter(Mandatory, HelpMessage="Subject")]
	[string]$subject,

	[Parameter(Mandatory, HelpMessage="Body")]
	[string]$body,

	[Parameter(HelpMessage="Body includes HTML")]
	[switch]$bodyAsHtml = $true,

	[Parameter(HelpMessage="Attachments")]
	[string[]]$attachments,

	[Parameter(Mandatory, HelpMessage="Smtp Server")]
	[string]$smtpServer,

	[Parameter(HelpMessage="Smtp Port, default=587")]
	[Int32]$smtpPort = 587,

	[Parameter(Mandatory, HelpMessage="Smtp Username")]
	[string]$smtpUsername,

	[Parameter(Mandatory, HelpMessage="Smtp Password")]
	[string]$smtpPassword,

	[Parameter(HelpMessage="Smtp Use Ssl, default=true")]
	[switch]$smtpUseSSL = $true,

	[Parameter(HelpMessage="DeliveryNotificationOption")]
	[string[]]$DeliveryNotificationOption
)

write-host "smtpUsername" $smtpUsername
write-host "smtpPassword" $smtpPassword

$smtpSecurePassword = ConvertTo-SecureString $smtpPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($smtpUsername, $smtpSecurePassword)
$sendMailParams = @{
    From = $from
    To = $to
    Subject = $subject
    Body = $body
    BodyAsHtml = $true
    SMTPServer = $smtpServer
    Port = $smtpPort
    UseSsl = $smtpUseSSL
    Credential = $credential
}

write-host "attachments.count" $attachments.count

If($attachments.count -gt 0 ) { $sendMailParams.Add('Attachments', $attachments)}
If($DeliveryNotificationOption.count -gt 0 ) { $sendMailParams.Add('DeliveryNotificationOption', $DeliveryNotificationOption) }

write-host("List all parameters")
$sendMailParams.GetEnumerator() | Sort-Object -Property key

Send-MailMessage @sendMailParams
