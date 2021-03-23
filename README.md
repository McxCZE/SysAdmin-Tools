# SysAdmin-Tools
PowerShell Code Snippets for managing Windows Server and vSphere/VMware infrastructure. 



23.03.2021 - Added vSphere snapshots deletion script, script deletes snapshot and by variable $maxjobs keeps deleting limited to maximum 5 jobs at a time. When the script finishes it sends report to specified e-mail.
21.03.2021 - Added script that lists AAD users who have a special AAD group, and their Azure AD registered devices, the script formats it into HTML and sends e-mail to specified address.
21.03.2021 - Added script that checks whether VM is using SCSI old "VirtualLsiLogic". The output should be manualy checked. 
