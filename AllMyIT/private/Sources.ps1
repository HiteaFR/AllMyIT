# OK
function Set-SmbSource {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    try {
        if ($Args.Credential) {
            $Credential = Get-Variable $Args.Credential -ValueOnly
            New-PSDrive -Name $Args.DriveName -Root $Args.DrivePath -PSProvider "FileSystem" -Credential $Credential -Scope Global
        }
        else {
            New-PSDrive -Name $Args.DriveName -Root $Args.DrivePath -PSProvider "FileSystem" -Scope Global
            Write-Verbose "New PsDrive Created"
        }
    }
    catch {
        Write-Host "Set-SmdSource error"
    }
    
}

function Set-AmiCreds {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    [securestring]$Password = ConvertTo-SecureString $Args.Password -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PsCredential($Args.Username, $Password)

    Set-Variable -Name $Args.Name -Value $Credential

}