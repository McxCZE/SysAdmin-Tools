#Connect to Azure
Connect-AzureAD

#Group_File_GeneralReport
$Report_Group_File = ".\Azure Active Directory\GroupReport\"
#Report_Intune_Devices
$Report_Devices_File = ".\Intune\Intune Devices\"
#Script Location
$ScriptLocation = ".\Intune"
#Dnesni datum
$Date = Get-Date
#SMTP Server for e-mail to send.
$smtpServer = "mail.example.com" 
#Azure_Report@example.com - E-mail
$strFrom = "Azure_Reporting@example.com"
#$strTo = "administrator@example.com" 
$strTo = "cihak@example.com" #(pouze pro testovani)
$strSubject = "Intune - Device List"
#AAD Group for Intune Users
$intuneAADgroup = "Intune_Users_Example_Group"
#Script Name
$ScriptName = "List_AAD_Group_Members_And_Their_Devices.ps1"

#Set path to script location.
Set-Location -Path $ScriptLocation

$Intune_Group_Members = Get-AzureADGroup -SearchString $intuneAADgroup | Get-AzureADGroupMember #Find whoever has this AAD group.
$Intune_Group_Members | Out-File -FilePath "$($Report_Group_File)Intune_Group_Members.txt"

$Intune_Group_Members_HashTable = @()

Foreach ($Intune_Group_Member in $Intune_Group_Members) {
    $HashTable_Temporary = @()
    $HashTable_Temporary = "" | Select-Object User, Device

    $Devices = Get-AzureADUserRegisteredDevice -OBjectId $Intune_Group_Member.ObjectId

        If ($Devices.DisplayName.Count -ge "2") {
            $HashTable_Temporary.Device = $Devices[0].DisplayName + ", etc..."
        } else {
            $HashTable_Temporary.Device = $Devices.DisplayName
        }

    $HashTable_Temporary.User = $Intune_Group_Member.DisplayName
    $Intune_Group_Members_HashTable += $HashTable_Temporary

}

$HTML_PreContent = @("
<div id='nadpis'>
    <H1>Intune - CSOBL Devices</H1>
</div>
<hr>
<div id='head_text'>
    Users with assigned AAD group <b>$($intuneAADgroup)</b>, and their devices.
</div>
<hr>
<div id='Generated'>
    Report generated @ $($Date)
</div>
<hr>

<div id='body_div'>
")

$HTML_Body = $Intune_Group_Members_HashTable | Sort-Object Device | ConvertTo-Html -Fragment `
-PreContent $HTML_PreContent `
-PostContent "</div><hr><div id='Azure_Scripts_Sign'>PowerShell Script : $($ScriptName)</div>" #| Out-File -FilePath "$($ScriptLocation)Report_Intune.html"

$HTML_Head = @("
<style type='text/css'>
    body {
        font-family: monospace;
    }

    h1 {color:red;}
    table {}
    td {
        border: 1px solid black;
    }
    tr {border:1px solid black}
    #Azure_Scripts_Sign {
        margin-top: 20px;
        background-color: #1701ff;
        color: white;
        padding-left: 3%;
        font-size: 10px;
    }
    #nadpis {
        text-align: center;
    }
    #Generated {
        text-align: center;
        font-weight: bold;
    }
    #head_text {
        text-align: center;
    }
    table {
        table-layout:fixed;
    }

    #body_div {
        margin: auto;
        width: 575px;
    }
</style>
")

ConvertTo-Html -Body $HTML_Body -Head $HTML_Head | Out-File -FilePath "$($Report_Devices_File)Report_Intune.html" 

$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg = new-object Net.Mail.MailMessage

$msg.From = $strFrom
$msg.To.Add($strTo)
$msg.Subject = $strSubject
$msg.IsBodyHtml = 1
$msg.Body = ConvertTo-Html -Body $HTML_Body -Head $HTML_Head
#$msg.Headers.Add("message-id", "<3BD50098E401463AA228377848493927-1>")	# Adding a Bell Icon for Outlook users
$smtp.Send($msg)

Disconnect-AzureAD
