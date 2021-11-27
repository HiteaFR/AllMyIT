function Ami {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Path to one locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProfilPath
    )

    begin {
        if (!(Test-HtPsRunAs)) {
            Write-Host "You must launch Ami as admin, exit..."
            pause
            exit
        }
    
        if (!(Test-Path "$($InstallPath)/Installed.txt") -or !(Test-Path $InstallPath)) {
            ForEach ($Folder in @("data", "download", "config")) {
                New-Item -Path (Join-Path $InstallPath $Folder) -ItemType Directory | Out-Null
            }
            Install-PackageProvider -Name Nuget -Force
            Get-Date | Out-File -Encoding UTF8 -FilePath "$($InstallPath)/Installed.txt"
        }
        else {
            Write-Host "Install folder is Already created !"
        }

        Read-Host "Start..., press enter"
    }
    process {
        if ([string]$ProfilPath) {
            $configuration = Confirm-Configuration -Configuration (Import-Configuration -Profile $ProfilPath)

            Foreach ($Section in $configuration.PSobject.Properties | Select-Object Name, Value) {
                if (($Section.Value).count -gt 1) {
                    foreach ($Item in $Section.Value) {
                        if (Test-Command -cmdname $Section.Name) {
                            Write-Host $Section.Name
                            $params = '-Args $Item'
                            Invoke-Expression "$($Section.Name) $params"
                        }
                    }
                }
                else {
                    if (Test-Command -cmdname $Section.Name) {
                        Write-Host $Section.Name
                        $params = '-Args $Section.Value'
                        Invoke-Expression "$($Section.Name) $params"
                    }
                }
            }

            Save-Configuration -Configuration $configuration
        }
    
        Read-Host "End..., press enter"
    }
}
