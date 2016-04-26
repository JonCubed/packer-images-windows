Function Get-ExternalResource 
{ 
 <# 
   .Synopsis 
    This function downloads a resource  
   .Description 
    This function downloads a resource 
   .Example 
    Get-ExternalResource -Url "https://mysite.com/resource.exe" -Destination "c:/temp" 
    Downloads a resource called resource.exe on the domain mysite.com to the local folder c:/temp.  
   .Parameter Url 
    Uri of the resource 
   .Parameter Destination 
    The path to where the resource should be downloaded. 
   .Notes 
    NAME:  Get-ExternalResource 
 #> 
 [CmdletBinding()] 
 Param( 
  [Parameter(Position=0, 
      Mandatory=$True, 
      ValueFromPipeline=$True)] 
  [string]
  $url, 
  
  [string]
  [Parameter(Mandatory=$True)]
  $destination
 ) 
  $destinationParent = Split-Path $destination -Parent
  if(-not (Test-Path $destinationParent)) 
  {
      New-Item $destinationParent -Type Directory
  }
  (New-Object System.Net.WebClient).DownloadFile($url, $destination)
} #end function Get-ExternalResource
 
function Update-PathVariable
{
 <# 
   .Synopsis 
    This function updates the Path Environment Variable  
   .Description 
    This function updates the session Path Environment Variable with the latest from the machine and user scope  
   .Example 
    Update-PathVariable  
   .Notes 
    NAME:  Update-PathVariable
 #> 
 
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
}  #end function Update-PathVariable
 
function Get-PackageManifest 
{
    <# 
    .Synopsis 
        This function gets a manifest of packages 
    .Description 
        This function reads a manifest of packages 
    .Example 
        Get-PackageManifest -Path "../config/packages.json" -Type Chocolatey 
    .Parameter Path 
        Path to where the manifest file is located 
    .Parameter Type 
        Filters manifest to a type of package manager   
    .Notes 
        NAME:  Get-PackageManifest
    #> 
    [CmdletBinding()] 
    Param( 
    [Parameter(Position=0, 
        Mandatory=$True, 
        ValueFromPipeline=$True)] 
    [string]
    $path, 
    
    [string]
    [ValidateSet('Chocolatey','NPM','JSPM')]
    [Parameter(Mandatory=$false)]
    $type
    ) 
    
    if (-not (Test-Path $path))
    {
        Write-Error "Could not find manifest file at '$path'"
    }
    
    $packages = Get-Content $path -Raw | ConvertFrom-Json 
    
    if ($type) {
        $packages = $packages.$type
    }

    return $packages
    
}  #end function Get-PackageManifest

function Install-PackageManifest 
{
    <# 
    .Synopsis 
        This function gets a manifest of packages 
    .Description 
        This function reads a manifest of packages 
    .Example 
        Get-PackageManifest -Path "../config/packages.json" -Type Chocolatey 
    .Parameter Path 
        Path to where the manifest file is located 
    .Parameter Type 
        Filters manifest to a type of package manager   
    .Notes 
        NAME:  Install-PackageManifest 
    #> 
    [CmdletBinding()] 
    Param( 
    [Parameter(Position=0, 
        Mandatory=$True, 
        ValueFromPipeline=$True)] 
    [string]
    $path, 
    
    [string]
    [ValidateSet('Chocolatey','NPM','JSPM')]
    [Parameter(Mandatory=$false)]
    $type
    ) 
    
    if (-not (Test-Path $path))
    {
        Write-Error "Could not find manifest file at '$path'"
    }
    
    Write-Verbose "$packages = Get-PackageManifest -Path '$path'"
    $packages = Get-PackageManifest -Path $path 
    
    if (-not $type -or $type -eq 'Chocolatey') {      
        $package = $packages.chocolatey
        Install-ChocolateyPackageManifest $package -Verbose
    }   
    
    if (-not $type -or $type -eq 'NPM') {
        #Install-NPMPackageManifest $packages.npm
    }   
    
    if (-not $type -or $type -eq 'JSPM') {
        #Install-JSPMPackageManifest $packages.jspm
    }   
    
}  #end function Install-PackageManifest 

function Install-ChocolateyPackageManifest 
{
    <# 
    .Synopsis 
        This function installs all Chocolatey packages 
    .Description 
        This function installs all packages in a Chocolatey package manifest
    .Example 
        Install-ChocolateyPackageManifest -Manifest @(@{Name="googlechrome"};@{Name="powershell"}) 
        This will install the google chrome and powershell packages
    .Parameter Manifest 
        Array of package objects 
    .Notes 
        NAME:  Install-ChocolateyPackageManifest
    #> 
    [CmdletBinding()] 
    Param( 
    [Parameter(Position=0, 
        Mandatory=$True, 
        ValueFromPipeline=$True)]
    [Array]     
    $manifest
    )        

    if ($manifest.Count -eq 0) 
    {
        Write-Warning "Chocolatey manifest is empty"
        return
    }

    foreach ($package in $manifest) 
    {     
        if (-not $package.name)  
        {
            Write-Warning "Invalid package, skipping"
            continue
        }

        $packageName = $package.name
        $packageParameters = @{}
        $params = @()
        $versionText = "lastest version"
        $pathText = "default location"
        $paramFlag = ''
	    $versionFlag = ''
        $sourceFlag = ''
    
        if ($package.version)
        {
            $versionFlag = "-version $Version"
            $versionText = "version $Version"
        }
	
        if ($package.source)
        {
            $sourceFlag = "-source $Source"
        }

        if ($package.parameters.Count -gt 0)
        {
            $packageParameters.Keys | ForEach-Object { 
                $params += "/$($_):'$($packageParameters.Item($_))'"		

			    if ($_ -eq "InstallationPath")
			    {
				    $pathText = $packageParameters.Item($_)
			    }
            };
		
            $paramFlag = "-params `"$params`""
        }

        Write-Verbose "Installing $versionText of $PackageName to $pathText"
        Write-Verbose "& choco install $packageName $versionFlag $paramFlag $sourceFlag"
        & choco install $packageName $versionFlag $paramFlag $sourceFlag
    }
}  #end function Install-ChocolateyPackageManifest

$PasswordNeverExpiresFlag = 0x10000
function Reset-UserPassword
{
	param([string]$username, [string] $password)
	$user = [adsi]"WinNT://localhost/$username,user"
	$user.userFlags = $user.userFlags.Value -bor $PasswordNeverExpiresFlag
	$user.SetPassword($password)
	$user.SetInfo()
}