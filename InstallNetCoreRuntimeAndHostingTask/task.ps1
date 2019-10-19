  
[CmdletBinding()]
param() 
Trace-VstsEnteringInvocation $MyInvocation
try 
{
    $ErrorActionPreference = "Stop"

    Import-VstsLocStrings "$PSScriptRoot\Task.json"
    . "$PSScriptRoot\functions.ps1"

    $dotNetVersion = Get-VstsInput -Name version -Require
    $norestart = Get-VstsInput -Name norestart -Require
    $useProxy = Get-VstsInput -Name useProxy -Require
    $proxyServerAddress = ""
    if ($useProxy)
    {
        $proxyServerAddress = Get-VstsInput -Name proxyServerAddress -Require
    }

    $workingDirectory = Get-VstsTaskVariable -Name "System.DefaultWorkingDirectory"
    $workingDirectory = Join-Path $workingDirectory $dotNetVersion
    $outputFilePath = Join-Path $workingDirectory "dotnet-hosting-win.exe"

    $installerFilePath = Download-DotNetCoreInstaller -dotNetVersion $dotNetVersion -useProxy $useProxy -proxyServerAddress $proxyServerAddress -outputFilePath $outputFilePath
    Install-DotNetCore -installerFilePath $installerFilePath -norestart $norestart
}
finally
{
	Trace-VstsLeavingInvocation $MyInvocation
}