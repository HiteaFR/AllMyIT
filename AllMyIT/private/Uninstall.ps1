#OK
function Uninstall-Appx {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    ForEach ($AppPackage in $Args.Appx) {
        if (Get-AppxPackage $AppPackage) {
            Write-Verbose "Package found"
            Get-AppxPackage -Name $AppPackage -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue

            Get-AppXProvisionedPackage -Online | Where-Object DisplayName -EQ $AppPackage | Remove-AppxProvisionedPackage -Online
        }
        else {
            Write-Verbose "Package not found"
        }
    }

}

#OK
function Uninstall-Msi {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [psobject]$Args
    )

    $Win32AppObj = Get-WmiObject -Class Win32_Product

    ForEach ($Win32App in $Args.Msi) {
        $ObjFilter = $Win32AppObj | Where-Object { $_.Name -match $Win32App }
        if ($ObjFilter -and $ObjFilter.Count -eq 1) {
            Write-Verbose "Package found"
            $Win32AppID = $Win32AppObj.properties["IdentifyingNumber"].value.toString()
            Start-Process -FilePath "msiexec.exe" -ArgumentList '/uninstall', $Win32AppID, '/quiet' -Wait -Verb "RunAs"
        }
        elseif ($ObjFilter -and $ObjFilter.Count -gt 1) {
            Write-Verbose "Package found"
            $Win32AppID = $Win32AppObj[0].properties["IdentifyingNumber"].value.toString()
            Start-Process -FilePath "msiexec.exe" -ArgumentList '/uninstall', $Win32AppID, '/quiet' -Wait -Verb "RunAs"
        }
        else {
            Write-Verbose "Package not found"
        }

    }

}