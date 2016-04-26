$ErrorActionPreference = "Stop";

# Clean up directories and files that are no longer needed
Remove-Item -Path c:/.automation/config/packages.json
Remove-Item -Path c:/.automation/config/base-box.ps1