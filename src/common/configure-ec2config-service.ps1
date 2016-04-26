
$ec2ConfigPath = Join-Path (Get-Item Env:\ProgramFiles).Value "Amazon\Ec2ConfigService\Settings"

$ec2ConfigFile = Join-Path $ec2ConfigPath "Config.xml"

#EC2Config
$config = (Get-Content -Path $ec2ConfigFile) -As [Xml]

foreach ($settingElem in $config.EC2ConfigurationSettings.Plugins.Plugin) {
    if ($settingElem.Name -eq "Ec2SetPassword") {
        $settingElem.State = "Enabled"
		Write-Output "Enabled Ec2SetPassword"
    }
    elseif ($settingElem.Name -eq "Ec2HandleUserData") {
        $settingElem.State = "Enabled"
		Write-Output "Enabled Ec2HandleUserData"
    }
    elseif ($settingElem.name -eq "Ec2SetComputerName")
    {
        $settingElem.State="Enabled"
		Write-Output "Enabled Ec2SetComputerName"
    }
}

$config.Save($ec2ConfigFile)
