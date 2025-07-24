# Prompt for domain and DC
$domain = Read-Host "Enter the domain name (e.g., example.com)"
$dc = Read-Host "Enter the DC (e.g., com)"

# Step 1: Check ACL for the specified domain and DC
$acl = Get-Acl -Path "AD:\DC=$domain,DC=$dc" | Format-List -Property Access | Out-String

if ($acl -match "Everyone\s+Allow") {
    Write-Host "WARNING: Default permissions allowed to Everyone."
    $response = Read-Host "Do you want to disable? (y/n)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        dsacls "DC=$domain,DC=$dc" /R "Everyone"
        Write-Host "Everyone permissions removed."
    }
} else {
    Write-Host "Default permissions not allowed to Everyone ✓"
}

# Step 2: Check Pre-Windows 2000 Compatible Access group membership
$preWin2000 = Get-ADGroupMember -Identity "Pre-Windows 2000 Compatible Access" | Select-Object Name, SamAccountName, ObjectClass

if ($preWin2000) {
    Write-Host "Pre-Windows 2000 Compatible Access group members found:"
    $preWin2000 | Format-Table -AutoSize
    $response = Read-Host "Do you want to disable Pre-Windows 2000 Compatible Access? (y/n)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        dsacls "DC=$domain,DC=$dc" /R "Pre-Windows 2000 Compatible Access"
        Write-Host "Pre-Windows 2000 Compatible Access permissions removed."
    }
} else {
    Write-Host "No members found in Pre-Windows 2000 Compatible Access group ✓"
}