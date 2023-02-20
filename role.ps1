Import-Module AzureAD
connect-azuread -TenantId #insérer le numéro TenantId

Import-Module MSOnline
connect-msolservice

function Show-Menu {
    param (
        [string]$title = "L'option 1 permet de remplir le role d'un utilisateur alors que la 2eme permet d'en remplir plusieurs simultanement"
    )
    Clear-Host
    Write-Host " `n  $title "
    Write-Host " `n Entrez 1 pour remplir le role d'un utilisateur"
    Write-Host " `n Entrez 2 pour remplir plusieurs utilisateurs"
    Write-Host " `n Entrez q pour quitter le programme"
}

#Import du module Azure AD et connexion à l'AD via le tenant ID
function Set-UserRole {
    param (
    [String]$name
    )
    $name = Read-Host "Entrer le display name d'un utilisateur "
    Get-AzureADUser -SearchString $name
    write-host "Administrators roles :" 
    Get-AzureADDirectoryRoleTemplate | Select-Object "DisplayName"
    $role = Read-Host "Entrez le display name d'un role"
    $selectRole =  Get-AzureADDirectoryRoleTemplate | Select-Object "DisplayName"
    $roleArray = ($selectRole | Foreach {"$($_.DisplayName)"})
    if ($roleArray -match $role) {
        write-host  "Le role fourni existe"
        $role_final = Get-AzureADDirectoryRole | Where {$_.displayName -eq $role}
        write-host $role.gettype()
        write-host $role
        if ($role_final -eq $null) {
            $roleTemplate = Get-AzureADDirectoryRoleTemplate | Where {$_.displayName -eq $role}
            Enable-AzureADDirectoryRole -RoleTemplateId $roleTemplate.ObjectId
            $role_final = Get-AzureADDirectoryRole | Where {$_.displayName -eq $role}
        }
        Add-AzureADDirectoryRoleMember -ObjectId $role_final.ObjectId -RefObjectId (Get-AzureADUser | Where {$_.DisplayName -eq $name}).ObjectID
     }
    else {
        write-host "Le role fourni n'existe pas"
     }
    Start-Sleep -Seconds 5
}
function Set-MultipleUsers {
    #Display the available roles 
    Get-MsolRole | Sort Name | Select Name,Description
    $csv_file = "C:\Users\role\role.csv"
    $role_changes = Import-Csv $csv_file | ForEach {Add-MsolRoleMember -RoleMemberEmailAddress $_.UserPrincipalName -RoleName $_.RoleName }    
    write-host $role_changes

}
#Main class
do {
    Show-Menu
    $choosenOption = Read-Host "Entrez l'option choisie :"
    Clear-Host
    switch($choosenOption){
       '1'{Set-UserRole;break}
       '2'{Set-MultipleUsers;break}
       'q'{break}
       default{
        Write-Host "L'option entrée est '$choosenOption'" -ForegroundColor Red
        Write-Host "Sélectionner une des options possibles" -ForegroundColor Red
       }
    }
    Pause
} until($choosenOption -eq 'q')
