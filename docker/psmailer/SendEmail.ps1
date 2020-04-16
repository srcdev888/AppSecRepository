#! /usr/bin/pwsh

param(
    [Parameter(Mandatory, HelpMessage="From")][string]$from,
    [Parameter(Mandatory, HelpMessage="To")][string[]]$to,
    [Parameter(Mandatory, HelpMessage="Subject")][string]$subject,
    [Parameter(Mandatory, HelpMessage="Body")][string]$body,
    [Parameter(HelpMessage="Body includes HTML")][switch]$bodyAsHtml = $true,
    [Parameter(HelpMessage="Attachments")][string[]]$attachments,
    [Parameter(Mandatory, HelpMessage="Smtp Server")][string]$smtpServer,
    [Parameter(HelpMessage="Smtp Port, default=587")][string]$smtpPort=587,
    [Parameter(Mandatory, HelpMessage="Smtp Username")][string]$smtpUsername,
    [Parameter(Mandatory, HelpMessage="Smtp Password")][string]$smtpPassword,
    [Parameter(HelpMessage="Smtp Use Ssl, default=true")][switch]$smtpUseSSL = $true,
    [Parameter(HelpMessage="DeliveryNotificationOption")][string[]]$DeliveryNotificationOption
)
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
If($attachments.count -gt 0 ) { $sendMailParams.Add('Attachments',$attachments)}
If($DeliveryNotificationOption.count -gt 0 ) { $sendMailParams.Add('DeliveryNotificationOption', $DeliveryNotificationOption) }

Send-MailMessage @sendMailParams
