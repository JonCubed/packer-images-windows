<powershell>

function Set-WinRMProperty 
{
    param([String] $Path, [string] $PropertyName, [string] $Value)
    
    $winRmPath = "winrm/config" 
    
    if ($Path)
    {
        $winRmPath = $winRmPath, $Path -join "/"
    }
    
    Start-Process -FilePath winrm `
    -ArgumentList "set $winRmPath @{$PropertyName=`"$Value`"}" `
    -NoNewWindow -Wait
}

Write-Output "Running Packer Bootstrap Script"

Write-Output "Configuring Users..."
$PasswordNeverExpiresFlag = 0x10000
$user = [adsi]"WinNT://localhost/Administrator,user"
$user.userFlags = $user.userFlags.Value -bor $PasswordNeverExpiresFlag
$user.SetPassword("N0tsosecret")
$user.SetInfo()

Write-Output "Configuring WinRM..."
Set-WinRMProperty -PropertyName "MaxTimeoutms" -Value "7200000"
Set-WinRMProperty -PropertyName "MaxMemoryPerShellMB" -Value "0" -Path "winrs"
Set-WinRMProperty -PropertyName "AllowUnencrypted" -Value "true" -Path "service"
Set-WinRMProperty -PropertyName "Basic" -Value "true" -Path "service/auth"
    
Write-Output "Configuring Firewall..."
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
    
Write-Output "Restarting WinRM Service..."
Stop-Service winrm
Set-Service winrm -StartupType "Automatic"
Start-Service winrm

# turn off PowerShell execution policy restrictions
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

Write-Output "Finished Running Packer Bootstrap Script"

</powershell>