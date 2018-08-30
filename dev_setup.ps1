# Description: Boxstarter Script
# Author: Microsoft
# Common dev settings for machine learning using Windows and Linux native tools

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$Boxstarter | Foreach-Object { write-host "The key name is $_.Key and value is $_.Value"  }
$helperUri = $Boxstarter['ScriptToCall']
write-host "ScriptToCall is $helperUri"
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

# see if we can't get calling URL somehow, that would eliminate this need

# should move to a config file

$user = "Microsoft";
$baseBranch = "master";
$finalBaseHelperUri = "https://raw.githubusercontent.com/$user/Dev-Advocacy-Samples/$baseBranch/scripts";

#--- Dev tools ---
write-host "Downloading VS Code ..."
choco install -y vscode
write-host "Enabling WSL ..."
choco install -y Microsoft-Windows-Subsystem-Linux -source windowsfeatures
#--- Ubuntu ---
write-host "Installing Ubuntu 18.04 ..."
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx
# run the distro once and have it install locally with a blank root user
Ubuntu1804 install --root

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
