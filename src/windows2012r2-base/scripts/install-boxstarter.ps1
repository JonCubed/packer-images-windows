$ErrorActionPreference = "Stop";

# install chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# update path variable so we can run chocolatey commands
Update-PathVariable

# install boxstarter
& choco install Boxstarter -y