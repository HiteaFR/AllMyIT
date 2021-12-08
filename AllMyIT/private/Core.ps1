function Import-Configuration() {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$Profile
    )

    if (Test-Path $Profile) {
        #$OutputFile = Split-Path $Profile -leaf
        #Start-BitsTransfer -Source $Profile -Destination (Join-Path $InstallPath ("\config\" + $OutputFile))
        $Configuration = (Get-Content $Profile | ConvertFrom-Json)
        $Configuration | Add-Member Filename $Profile -Force
        Write-Verbose -Message "Config file imported !"
        return $Configuration
    }
    else {
        Read-Host "Profile error, exit... "
        exit
    }
}

function Save-Configuration() {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        $Configuration
    )
    
    $excluded = @('Filename')
    $Configuration | Select-Object -Property * -ExcludeProperty $excluded | ConvertTo-Json | Set-Content -Encoding UTF8 -Path $Configuration.Filename
    Write-Verbose -Message "Config file saved !"
}

function Confirm-Configuration() {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        $Configuration,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $StrictMode
        
    )

    $Template = (Get-Content (Join-Path $BaseFolder ("Config/Template.json")) | Out-String | ConvertFrom-Json)

    foreach ($ConfigItem in $Configuration.PSobject.Properties) {
        if ([bool]($Template.PSobject.Properties.name -match $ConfigItem.Name) -or [bool]($ConfigItem.Name -match "Filename")) { 
            Write-Verbose -Message ($ConfigItem.Name + " is set in template")
        }
        else {
            Write-Verbose -Message ($ConfigItem.Name + " is no set in template, removing it !")
            $Configuration.PSObject.Properties.Remove($ConfigItem.Name)
        }
    }

    foreach ($TemplateItem in $Template.PSobject.Properties) {
        if (!([bool]($Configuration.PSobject.Properties.name -match $TemplateItem.Name)) -and ($StrictMode -eq $true)) {
            Write-Verbose -Message ($ConfigItem.Name + " is no set in config file ! it's a required field, exiting...")
            Read-Host "Press Enter !"
            exit
        }
    }

    return $Configuration
}

function Test-HtPsRunAs {  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}