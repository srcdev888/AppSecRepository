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

.PARAMETER deliveryNotificationOption
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

	[Parameter(HelpMessage="DeliveryNotificationOption")]
	[string[]]$deliveryNotificationOption
)

write-host "SendEmail.ps1 version 1.0 17 Apr 2020"

$smtpSecurePassword = ConvertTo-SecureString $smtpPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($smtpUsername, $smtpSecurePassword)

#write-host "username " $credential.Username
#write-host "password " $credential.GetNetworkCredential().Password

$sendMailParams = @{
    From = $from
    To = $to
    Subject = $subject
    Body = $body
    BodyAsHtml = $true
    SMTPServer = $smtpServer
    Port = $smtpPort
    UseSsl = $true
    Credential = $credential
}

#write-host("print Size")
#$sendMailParams.Count
#write-host "attachments.count" $attachments.count

If($attachments.count -gt 0 ) { $sendMailParams.Add('Attachments', $attachments)}
If($DeliveryNotificationOption.count -gt 0 ) { $sendMailParams.Add('DeliveryNotificationOption', $deliveryNotificationOption) }

#write-host("List all parameters")
#$sendMailParams.GetEnumerator() | Sort-Object -Property key

Send-MailMessage -WarningAction SilentlyContinue @sendMailParams
