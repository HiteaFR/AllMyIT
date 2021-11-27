function Install-Features {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    if (Test-Command -cmdname "Get-WindowsFeature") {
        
        $InstalledFeatures = Get-WindowsFeature | Where-Object InstallState -eq "Installed"

        foreach ($Feature in $Args.Features) {
    
            if (!($InstalledFeatures.Name -match $Feature)) {
                Write-Host "Installing $Feature"
                Install-WindowsFeature $Feature
            }
            else {
                Write-Host "Feature $Feature is already installed"
            }
        } 
    }
    else {
        Write-Host "Command not supported"
    }

   

}

# OK
Function Install-NiniteApps {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    Write-Host "Downloading Ninite ..."
   
    $ofs = '-'
    $niniteurl = "https://ninite.com/" + $Args.Apps + "/ninite.exe"
    $output = (Join-Path $InstallPath "\download\ninite.exe")
    if (Test-Path $Output) {
        Write-Verbose -Message "File alreday exist"
    }
    Invoke-WebRequest $niniteurl -OutFile $output
    Start-Process -FilePath $Output -Wait -PassThru -Verb "RunAs"

}

# OK
Function Install-ChocoApps {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    If (!(Test-Path -Path "$env:ProgramData\Chocolatey")) {
        Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }

    choco install $Args.Apps -y

}

function Install-WinGetApps {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    if (!(Test-Command "winget")) {
        $Output = (Join-Path $InstallPath ("\download\Winget.msixbundle"))
        Invoke-WebRequest "https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "$Output"
        Add-AppxPackage $Output
    }

    foreach ($app in $Args.Apps) {
        winget install $app -e
    }
 
}

# OK
Function Copy-FileApp {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    $OutputFile = Split-Path $Args.Path -leaf
    $Output = (Join-Path $InstallPath ("\data\" + $OutputFile))
    Write-Host "Downloading from $($Args.Path)"
    if (Test-Path $Output) {
        Write-Verbose -Message "File alreday exist"
    }
    Start-BitsTransfer -Source $Args.Path -Destination $Output
    if ($Args.DesktopLink -eq $true) {
        $ShortcutFile = "$env:Public\Desktop\" + $OutputFile + ".lnk"
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
        $Shortcut.TargetPath = $Output
        $Shortcut.Save()
        Write-Host "Shortcut created"
    }

}

# OK
Function Install-ExeApp {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    $Output = (Join-Path $InstallPath ("\download\" + $Args.Name))
    Write-Host "Downloading from $($Args.Path)"
    if (Test-Path $Output) {
        Write-Verbose -Message "File alreday exist"
    }
    Start-BitsTransfer -Source $Args.Path -Destination $Output

    if ($Args.SetupArgs) {
        Start-Process -FilePath $Output -ArgumentList $Args.SetupArgs -Wait -PassThru -Verb "RunAs"
    }
    else {
        Start-Process -FilePath $Output -Wait -PassThru -Verb "RunAs"
    }
    Write-Host ("$($Output) Installed")
}

Function Install-MsiApp {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    $Output = (Join-Path $InstallPath ("\download\" + $Args.Name))
    Write-Host "Downloading from $($Args.Path)"
    if (Test-Path $Output) {
        Write-Verbose -Message "File alreday exist"
    }
    Start-BitsTransfer -Source $Args.Path -Destination $Output

    if ($Args.SetupArgs) {
        Start-Process msiexec.exe -ArgumentList $Args.SetupArgs -Wait -PassThru -Verb "RunAs"
        Write-Host ("$($Output) Installed")
    }
    else {
        
    }

}


Function Install-WacApp {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    $Output = (Join-Path $InstallPath ("\download\WAC.msi"))
    $Logfile = (Join-Path $InstallPath ("\download\Wac_Install_log.txt"))

    Invoke-WebRequest "https://aka.ms/WACDownload" -OutFile "$Output"

    if ($Args.CertOption) {
        $msiArgs = @("/i", "$Output", "/qn", "/L*v", "$Logfile", "SME_PORT=$($Args.Port)", "SSL_CERTIFICATE_OPTION=$($Args.CertOption)")
    }
    else {
        $msiArgs = @("/i", "$Output", "/qn", "/L*v", "$Logfile", "SME_PORT=$($Args.Port)", "SSL_CERTIFICATE_OPTION=generate")
    }

    Start-Process msiexec.exe -ArgumentList $msiArgs -Wait -PassThru -Verb "RunAs"
    
    New-NetFirewallRule -DisplayName "Allow Windows Admin Center" -Direction Outbound -profile Domain -LocalPort $Port -Protocol TCP -Action Allow

    New-NetFirewallRule -DisplayName "Allow Windows Admin Center" -Direction Inbound -profile Domain -LocalPort $Port -Protocol TCP -Action Allow
    
}