
# Common Active Directory Attack Vectors and Vulnerabilities

## Overview
AD’s complexity and integrations create multiple attack entry points.

## Attack Vectors

### Authentication Protocol Exploits
- **Kerberos**:
  - **Definition**: A network authentication protocol using tickets to allow nodes to prove their identity securely. It relies on a trusted third party, the Key Distribution Center (KDC), to issue tickets for access to resources.
  - **Usage**: Widely used in Active Directory environments for authenticating users and services, ensuring secure communication across a network.
  - **Hacking Usage**: Attackers exploit Kerberos through techniques like Kerberoasting, where they extract service account ticket hashes from memory and crack them offline to gain unauthorized access, and AS-REP Roasting, which targets accounts with pre-authentication disabled to obtain crackable hashes.
  - **Example Scenario**: An attacker gains initial access to a low-privilege account in a company’s AD. Using Kerberoasting, they request a ticket for a service account (like a database server) from the KDC, extract the ticket hash, and use a tool like Hashcat to crack it offline. With the cracked password, they log into the database server and steal sensitive customer data.
- **NTLM**:
  - **Definition**: A suite of Microsoft security protocols for authentication, integrity, and confidentiality, primarily using a challenge-response mechanism.
  - **Usage**: Used in Windows environments for authentication when Kerberos is unavailable, often in legacy systems or cross-domain scenarios.
  - **Hacking Usage**: Attackers exploit NTLM via Relay attacks, intercepting authentication requests and relaying them to other servers for unauthorized access, and Pass-the-Hash, where stolen NTLM hashes are reused to authenticate without knowing the actual password.
  - **Example Scenario**: An attacker sets up a malicious server on a corporate network. When a user tries to access a shared printer, their NTLM authentication request is intercepted and relayed to a critical server using an NTLM Relay attack. The attacker gains access to the server without ever knowing the user’s password, allowing them to install ransomware.
- **LDAP**:
  - **Definition**: Lightweight Directory Access Protocol, a protocol for accessing and maintaining distributed directory information services over a network.
  - **Usage**: Used in AD to query and modify directory services, such as user and group information, facilitating centralized management.
  - **Hacking Usage**: Attackers target LDAP through anonymous binds, gaining unauthorized access to directory data without credentials, and injection attacks, manipulating queries to extract sensitive information or bypass authentication.
  - **Example Scenario**: An attacker discovers that a company’s LDAP server allows anonymous binds due to a misconfiguration. They connect to the server without credentials and query the directory to retrieve a full list of employee usernames and email addresses. This information is then used to craft targeted phishing emails to steal credentials.

### AD Misconfigurations and Privilege Escalation
- **GPOs**:
  - **Definition**: Group Policy Objects, used to manage user and computer settings in AD environments.
  - **Usage**: Administrators use GPOs to enforce security policies, deploy software, and configure system settings across domains.
  - **Hacking Usage**: Attackers exploit permissive GPO settings to execute malicious scripts or gain control over systems by modifying policies.
  - **Example Scenario**: An attacker compromises a mid-level IT staff account and discovers a GPO that applies to all workstations with a script to run at startup. They modify the GPO to include a malicious script that installs a keylogger on every employee’s computer, harvesting credentials over time.
- **AD CS**:
  - **Definition**: Active Directory Certificate Services, a Microsoft service for issuing and managing digital certificates.
  - **Usage**: Provides public key infrastructure (PKI) for secure communication, authentication, and data encryption in AD environments.
  - **Hacking Usage**: Attackers forge certificates to impersonate legitimate users or services, gaining unauthorized access to systems.
  - **Example Scenario**: An attacker exploits a vulnerability in AD CS to request a certificate for a high-privilege admin account. Using the forged certificate, they authenticate to a secure VPN as the admin, gaining full access to the internal network and downloading confidential company plans.
- **ACLs**:
  - **Definition**: Access Control Lists, defining permissions for users and groups to access AD objects.
  - **Usage**: Used to control access to resources, ensuring only authorized entities can modify or view sensitive data.
  - **Hacking Usage**: Overly broad permissions in ACLs allow attackers to escalate privileges or access restricted resources.
  - **Example Scenario**: An attacker with basic user access scans AD for misconfigured ACLs and finds that their account has write permissions to a critical security group. They add themselves to the group, instantly gaining admin rights and locking out legitimate administrators.
- **Credentials**:
  - **Definition**: Usernames and passwords or other authentication tokens used to verify identity.
  - **Usage**: Essential for user and system authentication within AD.
  - **Hacking Usage**: Attackers target default or hard-coded passwords to gain initial access or move laterally within the network.
  - **Example Scenario**: An attacker targets a legacy server in the network still using the default ‘Administrator’ password. After logging in, they use this foothold to dump credentials from memory and access other systems, eventually reaching the payroll database.

### Integrated Service Vulnerabilities
- **Exchange**:
  - **Definition**: Microsoft’s email and calendaring server software integrated with AD for user authentication.
  - **Usage**: Manages email, calendar, and contacts for organizations, relying on AD for access control.
  - **Hacking Usage**: Exploited through web vulnerabilities (e.g., ProxyLogon) and SMTP flaws to gain access or extract data.
  - **Example Scenario**: An attacker exploits the ProxyLogon vulnerability in an unpatched Exchange server. They upload a malicious web shell through the exploit, gaining a foothold to access employee mailboxes and extract sensitive emails containing financial data.
- **SQL Server**:
  - **Definition**: Microsoft’s relational database management system, often integrated with AD for authentication.
  - **Usage**: Stores and manages critical data for applications, using AD for user access control.
  - **Hacking Usage**: Targeted via SQL injection to manipulate databases or exploit authentication flaws for unauthorized access.
  - **Example Scenario**: An attacker targets a web application connected to an AD-integrated SQL Server. Using SQL injection in a login form, they bypass authentication and query the database to extract user credentials, which are then used to access other systems.
- **RDP**:
  - **Definition**: Remote Desktop Protocol, used for remote access to Windows systems.
  - **Usage**: Allows administrators and users to connect to systems remotely for management or work.
  - **Hacking Usage**: Exploited through weak credentials or unpatched vulnerabilities to gain remote control of systems.
  - **Example Scenario**: An attacker scans a company’s external IP range and finds an exposed RDP server. Using a brute-force attack on a weak password, they log in as an admin, install malware, and use the server as a launchpad for further attacks inside the network.
- **SMB**:
  - **Definition**: Server Message Block, a protocol for file sharing and printer access in Windows networks.
  - **Usage**: Facilitates resource sharing across networked devices in AD environments.
  - **Hacking Usage**: Attackers use null sessions to access shares without credentials or perform relay attacks to escalate access.
  - **Example Scenario**: An attacker exploits a null session vulnerability in SMB to connect to a file share without credentials. They access shared folders containing HR documents, download employee contracts, and use the information for blackmail.
- **DNS**:
  - **Definition**: Domain Name System, resolves domain names to IP addresses, integral to AD functionality.
  - **Usage**: Supports name resolution for AD services and client access to resources.
  - **Hacking Usage**: Exploited through zone transfers to map network infrastructure or dynamic updates to inject malicious records.
  - **Example Scenario**: An attacker performs a DNS zone transfer on a misconfigured AD-integrated DNS server, obtaining a full map of the company’s internal servers and workstations. They use this intel to target high-value assets like the finance server for a ransomware attack.
- **SSO**:
  - **Definition**: Single Sign-On, allows users to authenticate once and access multiple systems.
  - **Usage**: Simplifies access management using protocols like OAuth and SAML in AD-integrated environments.
  - **Hacking Usage**: Misconfigurations in OAuth/SAML implementations allow attackers to bypass authentication or steal tokens.
  - **Example Scenario**: An attacker finds a misconfigured SAML response in an SSO setup. They forge a SAML token to impersonate a CEO, gaining access to cloud applications like the company’s CRM system, and extract customer data for sale on the dark web.
- **APIs**:
  - **Definition**: Application Programming Interfaces, used for system and application integration with AD.
  - **Usage**: Enable programmatic access to AD services for automation and integration.
  - **Hacking Usage**: Exploited through weak authentication or authorization controls to access sensitive data or functions.
  - **Example Scenario**: An attacker discovers an exposed API endpoint for an AD management tool with weak authentication. They use stolen low-level credentials to query the API, enumerate all admin accounts, and launch targeted attacks to compromise those accounts.

## Attack Methods Summary

| Attack Method    | Description                     | Tools/Techniques           |
|------------------|---------------------------------|----------------------------|
| Kerberoasting    | Cracks service account hashes   | Hashcat, Rubeus            |
| NTLM Relay       | Relays auth for access          | Responder, NTLMrelayx      |
| GPO Misconfigs   | Exploits policy settings        | GPOZaurr, manual review    |
| AD CS Exploits   | Forges certificates             | Certipy, Certify           |

