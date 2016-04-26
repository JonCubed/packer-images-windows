$ErrorActionPreference = "Stop";

Import-Module Boxstarter.Chocolatey

$username = $env:packer:user:name
$userPassword = $env:packer:user:password
$secpasswd = ConvertTo-SecureString $userPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
Install-BoxstarterPackage -PackageName 'c:/.automation/config/base-box.ps1' -Credential $cred