# OK
function Set-SmbSource {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    try {
        if ($Args.Credential) {
            New-PSDrive -Name $Args.DriveName -Root $Args.DrivePath -PSProvider "FileSystem" -Credential $Args.Credential -Scope Global
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