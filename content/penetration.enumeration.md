
# Active Directory Enumeration: Techniques and Tools

## Overview
Enumeration extracts critical AD data to map attack paths.

## Techniques

### Enumerating Domain Structure
- **Focus**: Forests, domains, OUs.
- **Tools**: 
  - **Get-ADForest, Get-ADDomain (PowerShell)**  
    - **Explanation**: Retrieves information about AD forests and domains, including trust relationships and domain controllers.  
    - **Link**: [Microsoft Docs - Get-ADForest](https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-adforest), [Microsoft Docs - Get-ADDomain](https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-addomain)  
    - **Requirements**: Active Directory PowerShell module, appropriate permissions.  
    - **Usage Environment**: Windows Server or client with RSAT tools installed.
  - **dsquery ou, nltest /dclist (CMD)**  
    - **Explanation**: `dsquery ou` lists organizational units in AD, while `nltest /dclist` lists domain controllers in a domain.  
    - **Link**: [Microsoft Docs - dsquery](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/cc732952(v=ws.11)), [Microsoft Docs - nltest](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-xp/bb490706(v=technet.10))  
    - **Requirements**: Native Windows command-line tools, domain access.  
    - **Usage Environment**: Any Windows system with AD access.
  - **BloodHound, PingCastle**  
    - **Explanation**: BloodHound maps AD relationships for attack path visualization; PingCastle audits AD security and identifies vulnerabilities.  
    - **Link**: [BloodHound GitHub](https://github.com/BloodHoundAD/BloodHound), [PingCastle Website](https://www.pingcastle.com/)  
    - **Requirements**: BloodHound requires Neo4j and SharpHound for data collection; PingCastle needs domain credentials.  
    - **Usage Environment**: Typically used in penetration testing or security auditing environments.

### Discovering Users and Groups
- **Focus**: User accounts, group memberships.
- **Tools**: 
  - **net user, net localgroup (CMD)**  
    - **Explanation**: `net user` retrieves information about user accounts, while `net localgroup` lists local group memberships on a system.  
    - **Link**: [Microsoft Docs - net user](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-xp/bb490714(v=technet.10)), [Microsoft Docs - net localgroup](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-xp/bb490711(v=technet.10))  
    - **Requirements**: Native Windows command-line tools, appropriate permissions.  
    - **Usage Environment**: Any Windows system with access to the target.
  - **Get-ADUser, Get-ADGroup (PowerShell)**  
    - **Explanation**: `Get-ADUser` retrieves detailed information about AD user accounts, and `Get-ADGroup` lists group memberships and properties.  
    - **Link**: [Microsoft Docs - Get-ADUser](https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-aduser), [Microsoft Docs - Get-ADGroup](https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-adgroup)  
    - **Requirements**: Active Directory PowerShell module, domain access.  
    - **Usage Environment**: Windows Server or client with RSAT tools installed.
  - **ldapdomaindump, AdExplorer**  
    - **Explanation**: `ldapdomaindump` extracts user and group data from AD via LDAP queries; AdExplorer provides a GUI to browse and analyze AD objects.  
    - **Link**: [ldapdomaindump GitHub](https://github.com/dirkjanm/ldapdomaindump), [AdExplorer - Sysinternals](https://docs.microsoft.com/en-us/sysinternals/downloads/adexplorer)  
    - **Requirements**: `ldapdomaindump` requires Python and LDAP access; AdExplorer needs domain credentials.  
    - **Usage Environment**: Typically used in penetration testing or administrative environments.

### Identifying Computers and Devices
- **Focus**: Device inventory for lateral movement.
- **Tools**: 
  - **Get-ADComputer (PowerShell)**  
    - **Explanation**: Retrieves information about computer objects in Active Directory, useful for identifying potential targets for lateral movement.  
    - **Link**: [Microsoft Docs - Get-ADComputer](https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-adcomputer)  
    - **Requirements**: Active Directory PowerShell module, appropriate permissions.  
    - **Usage Environment**: Windows Server or client with RSAT tools installed.
  - **dsquery computer (CMD)**  
    - **Explanation**: Lists computer objects in Active Directory, helping to map out devices in the domain.  
    - **Link**: [Microsoft Docs - dsquery](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/cc732952(v=ws.11))  
    - **Requirements**: Native Windows command-line tool, domain access.  
    - **Usage Environment**: Any Windows system with AD access.
  - **CrackMapExec, Nmap**  
    - **Explanation**: CrackMapExec enumerates Windows hosts and services, including SMB and WinRM, for device discovery; Nmap scans networks to identify live hosts and open ports.  
    - **Link**: [CrackMapExec GitHub](https://github.com/byt3bl33d3r/CrackMapExec), [Nmap Official Site](https://nmap.org/)  
    - **Requirements**: CrackMapExec requires Python and network access; Nmap requires installation and network access.  
    - **Usage Environment**: Typically used in penetration testing environments.

### Mapping Trust Relationships
- **Focus**: Inter-domain/forest trust paths.
- **Tools**: 
  - **nltest /domain_trusts (CMD)**  
    - **Explanation**: Lists trust relationships for a domain, helping to identify inter-domain and forest trusts that can be exploited for lateral movement.  
    - **Link**: [Microsoft Docs - nltest](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-xp/bb490706(v=technet.10))  
    - **Requirements**: Native Windows command-line tool, domain access.  
    - **Usage Environment**: Any Windows system with AD access.
  - **Get-ADForest (PowerShell)**  
    - **Explanation**: Retrieves detailed information about the Active Directory forest, including trust relationships and forest-wide configuration.  
    - **Link**: [Microsoft Docs - Get-ADForest](https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-adforest)  
    - **Requirements**: Active Directory PowerShell module, appropriate permissions.  
    - **Usage Environment**: Windows Server or client with RSAT tools installed.
  - **BloodHound, PowerView**  
    - **Explanation**: BloodHound visually maps trust relationships and attack paths across domains and forests; PowerView provides detailed enumeration of trusts and domain relationships.  
    - **Link**: [BloodHound GitHub](https://github.com/BloodHoundAD/BloodHound), [PowerView GitHub](https://github.com/PowerShellMafia/PowerSploit/tree/master/Recon)  
    - **Requirements**: BloodHound requires Neo4j and SharpHound for data collection; PowerView requires PowerShell and domain access.  
    - **Usage Environment**: Typically used in penetration testing or security auditing environments.

## Tools Summary

| Tool             | Purpose                          | Key Features                     |
|------------------|----------------------------------|----------------------------------|
| BloodHound       | Maps AD relationships            | Visual attack path analysis      |
| PowerView        | Deep AD object enumeration       | Get-NetUser, Get-NetGroup        |
| ldapdomaindump   | Dumps AD data via LDAP           | HTML/JSON output                 |
| CrackMapExec     | Enumerates Windows hosts         | SMB, WinRM, LDAP support         |
| PingCastle       | Audits AD security               | Identifies vulnerabilities       |
| AdExplorer       | Browses AD objects               | GUI for AD analysis              |
| Nmap             | Network scanning                 | Identifies live hosts, open ports|
| Get-ADForest     | Retrieves AD forest info         | Trust relationships, domain data |
| Get-ADDomain     | Retrieves AD domain info         | Domain controllers, policies     |
| Get-ADUser       | Retrieves AD user info           | User account details             |
| Get-ADGroup      | Retrieves AD group info          | Group memberships, properties    |
| Get-ADComputer   | Retrieves AD computer info       | Device inventory for lateral move|
| dsquery          | Lists AD objects                 | OUs, computers, users            |
| nltest           | Lists domain controllers, trusts | Trust relationships, DC info     |
| net user         | Retrieves user account info      | User details on local/domain     |
| net localgroup   | Lists local group memberships    | Group details on local system    |

