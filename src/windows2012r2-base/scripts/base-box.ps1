try {
	# Configure windows
	Write-Output 'Configuring windows...'
	Disable-InternetExplorerESC
	Set-CornerNavigationOptions -EnableUsePowerShellOnWinX
	Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -DisableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
	Set-TaskbarOptions -Combine Never

	# Install Windows features that all images should have
	
	Write-Output 'Installing packages...'
	
	# save us from having to have -y
	choco feature enable --name=allowGlobalConfirmation		
	
	# Install apps/tools that all images should have
	Install-PackageManifest -Path c:/.automation/config/packages.json -verbose
		
	# re-enable chocolate confirmation behaviour
	choco feature disable --name=allowGlobalConfirmation
	
	Write-Output 'Installing packages was successful'
} catch {
	Write-Output 'Installing packages failed with ' $($_.Exception.Message)
	throw $_.Exception
}

