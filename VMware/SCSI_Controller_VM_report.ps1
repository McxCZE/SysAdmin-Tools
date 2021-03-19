Get-Module -ListAvailable | Where-Object {$_.Name -like "VMware*"} | Import-Module

Connect-VIServer -Server "myvsphere.example.com"

#ReportFile
$ReportPath = "C:\MyAwesomeReports\"

$VMs = Get-VM

$ReportObject = @()
$MessageObject = @()


Foreach ($VM in $VMs) {
    $SCSI_Controller = Get-ScsiController -VM $VM.Name | Select-Object -ExpandProperty Type
    If ($SCSI_Controller -eq "VirtualLsiLogic") {
        $MessageObject = "" | Select-Object Jmeno, SCSI_Radic
        $MessageObject.Jmeno = $VM.Name
        $MessageObject.SCSI_Radic = $SCSI_Controller
        $ReportObject += $MessageObject
        "Spatne nastaveno"
    } else {
        "Spravne nastaveno"
    }
}

$ReportObject | Out-File -FilePath "$($ReportPath)LsiLogic.txt"
