$acl = Get-Acl -Path "AD:\DC=lab,DC=local"
$rulesToRemove = $acl.Access | Where-Object { $_.IdentityReference -eq "NT AUTHORITY\Authenticated Users" -and $_.ActiveDirectoryRights -notlike "*Read*" }

if ($rulesToRemove) {
    foreach ($rule in $rulesToRemove) {
        $result = [PSCustomObject]@{
            IdentityReference    = $rule.IdentityReference
            ActiveDirectoryRights = $rule.ActiveDirectoryRights
            AccessControlType    = $rule.AccessControlType
            Removed              = $acl.RemoveAccessRule($rule)
        }
        Write-Output $result
    }
    Set-Acl -Path "AD:\DC=lab,DC=local" -AclObject $acl
} else {
    Write-Output "No matching rules found for 'NT AUTHORITY\Authenticated Users' without Read permissions."
}

do {
    Write-Output "`nCurrent permissions for 'NT AUTHORITY\Authenticated Users':"
    $currentAcl = Get-Acl -Path "AD:\DC=lab,DC=local"
    $currentAcl.Access | Where-Object { $_.IdentityReference -eq "NT AUTHORITY\Authenticated Users" } | Format-Table IdentityReference, ActiveDirectoryRights, AccessControlType -AutoSize

    $choice = Read-Host "`nEnter additional permission to grant (e.g., WriteProperty, CreateChild), 'next' to proceed, or 'exit' to quit"

    if ($choice -eq 'exit') {
        break
    } elseif ($choice -eq 'next') {
        Write-Output "Proceeding to next step or exiting."
        break
    } elseif ($choice) {
        try {
            $newRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
                [System.Security.Principal.NTAccount]"NT AUTHORITY\Authenticated Users",
                [System.DirectoryServices.ActiveDirectoryRights]$choice,
                [System.Security.AccessControl.AccessControlType]::Allow
            )
            $acl.AddAccessRule($newRule)
            Set-Acl -Path "AD:\DC=lab,DC=local" -AclObject $acl
            Write-Output "Added $choice permission successfully."
        } catch {
            Write-Output "Error adding permission: $_"
        }
    } else {
        Write-Output "Invalid input. Please enter a valid permission, 'next', or 'exit'."
    }
} while ($true)