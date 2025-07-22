# Active Directory Groups

## Overview

**Groups** in Active Directory (AD) are objects used to simplify the administration of access control and permissions to shared resources. They allow administrators to organize users, computers, and other entities into logical units, making it easier to assign permissions and manage access rights across a network. Groups are a fundamental component of AD, enabling efficient security and distribution management within domains.

## Key Characteristics

- **Permission Management**: Groups streamline the process of granting access to resources by allowing permissions to be assigned to a group rather than individual users, reducing administrative overhead and errors.
- **Types of Groups**: AD groups are categorized into two primary types based on their purpose: Security Groups (for access control) and Distribution Groups (for email distribution).
- **Scope**: Groups have defined scopes that determine their visibility and applicability across the AD environment, including Universal, Global, and Domain Local scopes.

## Types of Groups

- **Security Groups**: Used to assign permissions to shared resources and user rights. Members of a security group automatically inherit the rights and permissions assigned to that group. Security groups can also function as email entities in certain configurations.
- **Distribution Groups**: Primarily designed for creating email distribution lists, these groups cannot be used to assign permissions. They are used exclusively for communication purposes, such as sending emails to multiple recipients.

## Group Scopes

Active Directory defines three primary group scopes, each with specific characteristics regarding membership and permission assignment:
- **Universal Groups**: Used to assign permissions to resources across multiple domains within a given forest. Universal groups can include members from any domain in the forest and can be used for permissions in any domain.
- **Global Groups**: Can be granted permissions to resources in any trusting domain, but their membership is restricted to accounts from their own domain. They are often employed as role-based groups to define specific roles within an organization.
- **Domain Local Groups**: Manage access permissions to various domain resources, such as file shares or remote desktop access, but their application is confined to a single domain. They can include members from any domain but are limited to granting permissions within their own domain.
- **Builtin Local Groups**: Default groups located in the "Builtin" container with a specific scope for local system access. These include groups like Administrators and Backup Operators, which have predefined permissions on domain controllers or local machines.

## Built-in Security Groups

Active Directory automatically creates several built-in security groups with preconfigured rights and permissions for specific administrative tasks. Key examples include:
- **Administrators**: Complete and unrestricted access to the computer or domain. On domain controllers, members have unrestricted domain-wide access.
- **Domain Admins**: Authorized to administer the entire domain, automatically added to the local Administrators group on all domain-joined computers.
- **Enterprise Admins**: Exists only in the forest root domain, authorized to make forest-wide changes, with highest privileges across all domains in the forest.
- **Schema Admins**: Exists only in the forest root domain, with full administrative access to modify the Active Directory schema.
- **Account Operators**: Limited account creation privileges, can create and modify most user accounts and groups but cannot manage administrative accounts.
- **Backup Operators**: Can back up and restore all files on a computer, regardless of permissions, considered service administrators due to their capabilities.
- **Server Operators**: Exists only on domain controllers, can administer domain controllers by managing services, shares, and backups.
- **Print Operators**: Can manage printers connected to domain controllers and related AD objects.
- **DnsAdmins**: Provides access to network DNS information, exists only if the DNS server role is installed.
- **Protected Users**: Introduced in Windows Server 2012 R2, provides extra protection against credential compromise by restricting authentication methods.

## Operational Importance

- **Simplified Administration**: Assigning permissions to groups rather than individual users consolidates access management, making it easier to update permissions as roles change.
- **Scalability**: Groups support scalability in large environments by allowing centralized management of access rights across thousands of users and resources.
- **Group Nesting**: The concept of group nesting, where a global group is made a member of a domain local group, simplifies access management while adhering to the principle of least privilege. However, overly complex nesting can complicate auditing and lead to excessive permissions.

## Security Considerations

- **Principle of Least Privilege**: Grant users and groups only the minimum necessary privileges to perform their tasks, reducing the attack surface.
- **Careful Group Nesting**: Limit nesting to a few levels to avoid excessive permissions and maintain clarity in access control.
- **Unique and Descriptive Naming**: Establish naming standards to ensure consistency and clarity in understanding group purpose and membership.
- **Regular Auditing**: Monitor and audit group memberships and permissions for unauthorized changes or unusual activity, implementing alerts for suspicious actions.
- **Establish Group Owners**: Assign owners to groups to maintain accountability for membership and permissions, preventing "orphaned groups."
- **Secure Privileged Groups**: Restrict membership in highly privileged groups like Domain Admins and Enterprise Admins, using privileged access management (PAM) solutions.

## Best Practices

- **Use Security Groups for Permissions**: Always assign permissions to security groups rather than individual users to streamline management and ensure consistency.
- **Minimize Administrative Group Membership**: Limit the number of users in administrative groups and use separate accounts for administrative tasks.
- **Document Group Structures**: Maintain thorough documentation of group purposes, memberships, and nesting to facilitate troubleshooting and audits.
- **Periodic Reviews**: Regularly review group memberships to remove unnecessary access, especially for privileged groups.
- **Leverage Role-Based Access Control (RBAC)**: Use global groups to define roles and domain local groups to assign resource access, aligning permissions with job functions.

## Conclusion

Active Directory Groups are essential for efficient access control and resource management within an AD environment. By categorizing users and entities into logical units with defined scopes and purposes, groups enable administrators to apply permissions systematically, enhancing security and operational efficiency. Proper management, adherence to security best practices, and regular auditing are critical to maintaining a secure and scalable group structure.

#### References
- Microsoft Learn: Active Directory Security Groups
- Active Directory Security Groups - Permissions, Best Practices & Tools - Comparitech
- Active Directory Groups: How To Manage Them Effectively - Netwrix