# SysAdmin-Tools
PowerShell Code Snippets for managing Windows Server and vSphere/VMware infrastructure. 



23.03.2021 - Added vSphere snapshots deletion script, script deletes snapshot and by variable $maxjobs keeps deleting limited to maximum 5 jobs at a time. When the script finishes it sends report to specified e-mail.

25.03.2021 - Added script that lists AAD users who have a special AAD group, and their Azure AD registered devices, the script formats it into HTML and sends e-mail to specified address.

27.03.2021 - Added script that checks whether VM is using SCSI old "VirtualLsiLogic". Then generates a report file in .txt. 
