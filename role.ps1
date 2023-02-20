#Import du module Azure AD et connexion à l'AD via le tenant ID
Import-Module AzureAD
Connect-AzAccount -TenantId 860cec36-ec77-482a-a750-04750df95efd



function Set-UserRole {
    param (
    [String]$name
    )
    $name = Read-Host "Enter the display name of a user "
    Get-AzureADUser -SearchString $name
    $role = Read-Host "Enter the display name of a role"
    $ok =  Get-AzureADDirectoryRoleTemplate | Select-Object "DisplayName"
    $strArray = ($ok | Foreach {"$($_.DisplayName)"})
    #$strArray2 = [String]($strArray -join ',')
    if ($strArray -match $role) {
        write-host  "The name supplied is inside the rarray"  }
    }
    else {
        write-host "not contained"
     }
    Start-Sleep -Seconds 5
}