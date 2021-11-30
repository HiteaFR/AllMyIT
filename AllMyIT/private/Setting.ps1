# OK
function New-LocalAdmin {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    if (Get-LocalUser -Name $Args.NewLocalAdmin) {
        Write-Verbose -Message "User already exist, reseting the password..."
        Get-LocalUser -Name $Args.NewLocalAdmin | Set-LocalUser -Password (ConvertTo-SecureString -AsPlainText $Args.Password -Force)
    }
    else {
        New-LocalUser -Name $Args.NewLocalAdmin -Password (ConvertTo-SecureString -AsPlainText $Args.Password -Force) -FullName $Args.NewLocalAdmin -Description "Ami-User"
        Write-Verbose -Message "$($Args.NewLocalAdmin) local user created"
    }
    if ([bool]((Get-LocalGroupMember -Group "Administrateurs").Name -like ("*$($Args.NewLocalAdmin)*"))) {
        Write-Verbose -Message "$($Args.NewLocalAdmin) added to the local administrator group"
    }
    else {
        Write-Verbose -Message "$($Args.NewLocalAdmin) is already in administrator group"
        Add-LocalGroupMember -Group "Administrateurs" -Member $Args.NewLocalAdmin
    }
}


function Set-ConfigMode {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    if ($Args.Statut -eq $true) {
        netsh advfirewall set allprofiles state off
        Enable-WSManCredSSP -Role server
    }
    elseif ($Args.Statut -eq $False) {
        netsh advfirewall set allprofiles state on
        Disable-WSManCredSSP -Role server
    }
}

function Set-Accessibility {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    if ($Args.Statut -eq $true) {
        Enable-PSRemoting -Force
        winrm quickconfig -q
        Start-Service WinRM
        Set-Service WinRM -StartupType Automatic
    }
    elseif ($Args.Statut -eq $false) {
        Disable-PSRemoting -Force
        Stop-Service WinRM -Force
        Set-Service WinRM -StartupType Disabled
    }

}

function Set-RdpAccess {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )
    
    if ($Args.Statut -eq $true) {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
        Enable-NetFirewallRule -DisplayGroup $FirewallGroup
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
    }
    elseif ($Args.Statut -eq $false) {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 1
        Disable-NetFirewallRule -DisplayGroup $FirewallGroup
    }

}

# OK
function Set-ComputerName {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    Rename-Computer -NewName $Args.NewName

}

function Set-WindowsActivation {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    Slmgr -ipk $Args.WinKey

    Slmgr -ato

    Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | where { $_.PartialProductKey } | select Description, LicenseStatus

}

function Set-DiskStorage {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    Initialize-Disk $Args.DiskNumber
    
    New-Partition -DiskNumber $Args.DiskNumber -UseMaximumSize -DriveLetter $Args.DriveLetter

    Format-Volume -DriveLetter $Args.DriveLetter
    
    Set-Volume -DriveLetter $Args.DriveLetter -NewFileSystemLabel $Args.DriveLabel

}

function Set-Network {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    if ($Args.IPAddress) {
        New-NetIPAddress -InterfaceIndex $Args.InterfaceIndex -IPAddress $Args.IPAddress -PrefixLength $Args.PrefixLength -DefaultGateway $Args.DefaultGateway
    }
    elseif ($Args.Dns) {
        Set-DnsClientServerAddress -InterfaceIndex $Args.InterfaceIndex -ServerAddress $Args.Dns
    }

}

function Install-Printer {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    $Port = "IP_" + $Args.IPAddress
    $checkExist = Get-PrinterPort -Name $Port -ErrorAction SilentlyContinue

    if ($Args.DriverName -and ![bool]((Get-PrinterDriver).Name -match $Args.DriverName)) {
        pnputil.exe -a $Args.DriverInfPath
        Add-PrinterDriver -Name $Args.DriverName -InfPath $Args.DriverInfPath
        Write-Verbose -Message "$($Args.DriverName) driver installed"
    }

    if (-not $checkExist) {
        Add-PrinterPort -Name $Port -PrinterHostAddress $Args.IPAddress
        Write-Verbose -Message "$($Args.PrinterName) and $Port port created"
    }

    if ([bool]((Get-PrinterDriver).Name -match $Args.DriverName)) {
        Add-Printer -Name $Args.PrinterName -DriverName $Args.DriverName -PortName $Port
    }  
    
}

function Add-ComputerDomain {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    $Credential = Get-Variable $Args.Credential -ValueOnly

    Add-Computer -DomainName $Args.DomaineName -Credential $Credential -force -verbose

}

function Set-RegKey {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )
    
    if ($Args.Param -and $Args.Value) {
        New-ItemProperty -Path $Args.path\$Args.key -Name $Args.Param -Value $Args.Value -PropertyType DWORD -Force
    }
    else {
        New-Item -Path $Args.Path -Name $Args.Key -Force
    }

    
}