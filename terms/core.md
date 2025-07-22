

# **Active Directory Encyclopedia: Core Modules, Terms, Usage, and Technical Specifications for Enterprise Environments**

## **Introduction**

This report serves as a comprehensive technical reference for understanding Microsoft Active Directory (AD), detailing its core components, services, and integrated protocols. The objective is to provide in-depth technical specifications, operational mechanisms, and practical usage contexts for IT professionals building an internal knowledge base or public-facing encyclopedia. The focus is on stable and current implementations of Active Directory within enterprise environments.

Active Directory, primarily Active Directory Domain Services (AD DS), stands as a cornerstone of Windows-based networking. It offers centralized management of network resources, user accounts, and security policies, providing essential services such as authentication, authorization, and directory lookups. This foundational role enables the secure and efficient operation of large-scale IT environments.1 Its hierarchical structure is designed to allow organizations to scale effectively, accommodating growth from small businesses to large enterprises with thousands of users and computers.1

## **I. Active Directory Core Architecture and Components**

Active Directory's architecture is fundamentally divided into logical and physical structures, each designed to optimize management, security, and performance across diverse network environments.

### **A. Logical Structure**

The logical structure of Active Directory defines how directory data is organized and managed, irrespective of physical network topology. This organization is crucial for administrative delegation and policy application.

#### **Domains, Trees, and Forests: Hierarchical Organization and Trust Relationships**

At the core of Active Directory's logical design are domains, which serve as the fundamental organizational units. A domain defines administrative boundaries within a network and contains objects such as users, computers, and groups. Each domain maintains its own security and management policies, along with a dedicated database. Any network built upon Active Directory requires at least one domain and a corresponding domain controller to authenticate access.1

Domains can be organized into hierarchical collections known as domain trees. A domain tree shares a common root domain and a contiguous Domain Name System (DNS) namespace. For instance, work.com could be a root domain with europe.work.com as a child domain. A significant feature of domains within a tree is the establishment of automatic two-way transitive trust relationships. These trusts simplify information sharing and management across the domains in the tree, eliminating the need for manual trust configurations between every pair of domains.3

The highest level of Active Directory organization is the forest. A forest is a collection of one or more domain trees that share a common Active Directory Domain Services (AD DS) root, a unified schema, a common configuration partition, and a shared global catalog.4 Forests consolidate multiple domains into a single, cohesive structure, with each forest maintaining its own database security boundary and global address list.2

This hierarchical design, from domains to trees and forests, is not merely for organizational neatness; it directly addresses scalability challenges inherent in large networks. By partitioning the directory into domains, Active Directory facilitates data replication only where it is essential, enabling global scaling even over networks with limited bandwidth.6 The automatic trust relationships within trees and forests simplify cross-domain access and management, which is a significant advantage over complex manual trust configurations. This architecture inherently supports decentralized administration while preserving centralized control. Organizations can delegate administrative duties at the domain or Organizational Unit (OU) level 6, allowing the logical structure to align seamlessly with the organizational or geographical layout. This alignment is critical for efficient IT management in large enterprises and helps to contain potential security breaches to specific domains, though a forest-level compromise would have widespread impact.

#### **Organizational Units (OUs) and Containers: Delegation of Administration and Object Grouping**

Within domains, Organizational Units (OUs) function as flexible containers for managing and organizing various entities, including computers, groups, and users. OUs provide a granular framework for delegating administrative rights and applying Group Policy Objects (GPOs) to specific subsets of objects.1 This capability offers a finer level of control below the domain level, making it considerably easier to apply policies to particular user groups or departments.4

Containers, while similar to OUs in providing an organizational framework for objects within AD DS, possess distinct characteristics. Unlike OUs, default containers cannot have GPOs directly linked to them, nor can they be modified or deleted with the same flexibility as OUs.4 Microsoft generally recommends the use of OUs for structuring the directory and simplifying policy implementation and administration.8

The ability of OUs to serve as "bag or container objects" for users, groups, and computers, and their designation as the smallest unit for delegating permissions or applying GPOs 2, allows for more precise control than applying policies at the broader domain level. This means that instead of applying a policy to every user in a large domain, administrators can apply it to a specific OU, which is a more efficient approach and reduces the risk of over-privileging users. This directly supports the principle of least privilege, enabling IT teams to assign administrative duties and enforce security settings with fine-grained control.1 The distinction between OUs and default containers highlights a deliberate design choice by Microsoft: built-in, immutable containers are provided for core AD objects, while OUs offer administrators the flexibility to customize their directory structure to meet specific business needs. This emphasizes the importance of careful design when planning GPO application and administrative delegation.

#### **Objects: Users, Computers, and Groups (Security vs. Distribution)**

Objects are the fundamental building blocks or entities from which Active Directory is constructed. These objects represent both physical entities, such as users, printers, and servers, and organizational entities, like folders and groups. Each object serves to store its mandatory and optional attributes; for example, a user object stores attributes like username, password, and group memberships.3 Objects are arranged in a hierarchical manner within the Active Directory structure.3

Common types of objects include:

* **User Accounts:** These represent individual people or can be configured as dedicated service accounts for various applications, enabling access to network resources for a given user.5  
* **Computer Accounts:** These represent physical computer entities within the network and are essential for their authentication and for auditing their access to resources.5  
* **Groups:** Groups are utilized to simplify the administration of access control and permissions to shared resources.5  
  * **Security Groups:** These are specifically used to assign permissions to shared resources and user rights. Members of a security group automatically inherit the rights and permissions assigned to that group.9 Security groups can also function as email entities.9  
  * **Distribution Groups:** Primarily designed for creating email distribution lists, these groups cannot be used to assign permissions.9

Active Directory defines three primary group scopes: Universal, Global, and Domain Local. Additionally, default groups located in the "Builtin" container possess a "Builtin Local" scope.9

* **Universal Groups:** These groups are used to assign permissions to resources across multiple domains within a given forest.9  
* **Global Groups:** Global groups can be granted permissions to resources in any trusting domain, but their membership is restricted to accounts from their own domain.9 They are frequently employed as role-based groups.10  
* **Domain Local Groups:** These groups manage access permissions to various domain resources, such as file shares or remote desktop access, but their application is confined to a single domain.9

The distinction between security groups (for permissions) and distribution groups (for email) 9, along with their defined scopes, is fundamental to how permissions are managed within Active Directory. This design supports the explicit recommendation to assign permissions to security groups rather than to individual users.9 This approach significantly streamlines administrative tasks, reduces the potential for errors, and ensures consistent security practices, especially in large and dynamic environments. Instead of assigning permissions repeatedly to individual users, the process is consolidated to a single assignment for the group.9

Furthermore, the concept of group nesting, where a global group is made a member of a domain local group, and permissions are then granted to the domain local group 11, represents a best practice for simplifying access management while adhering to the principle of least privilege. However, it is important to note that overly complex nesting structures can lead to excessive permissions and complicate auditing efforts.11 This highlights the critical need for meticulous design and thorough documentation of all group structures to maintain effective control and security.

#### **Schema: The Blueprint of Active Directory Objects and Attributes**

The Active Directory schema serves as the definitive blueprint for the entire directory. It is the comprehensive set of rules that dictates the structure and properties of all objects within the directory, encompassing their classes, attributes, and naming conventions.2 Essentially, the schema defines the fundamental layout and content of the Active Directory database.14

There is only one schema partition per forest, and this single schema is replicated to every domain controller throughout that forest. This ensures that schema information is consistent and available forest-wide.15

While administrators possess the capability to extend or modify the schema, schema updates are a highly controlled process. Such modifications are exclusively permitted on the domain controller that holds the Schema Master Flexible Single Master Operations (FSMO) role.14 Modifying the schema is a critical operation because any change automatically affects the entire Active Directory system. New objects defined in the schema cannot be deleted, only deactivated.8 Therefore, schema changes require meticulous planning and execution.

The fact that the schema defines all object types and attributes in Active Directory 2 and is replicated to every domain controller in the forest 12, with only one domain controller holding the Schema Master role 14, underscores a fundamental design principle: a single, unified definition across the entire forest. This design choice ensures consistency but also means that any modification to the schema immediately impacts all domains and objects within the entire forest.8 This centralized control, enforced through the Schema Master, prevents conflicting definitions but elevates schema changes to extremely high-impact operations. Incorrect changes can fundamentally alter or disrupt the entire Active Directory deployment.8 This design prioritizes forest-wide consistency and integrity over localized flexibility for schema definitions, emphasizing the necessity for rigorous change management processes and highly privileged access for schema administrators.

#### **Partitions: Schema, Configuration, Domain, and Application Partitions (Content and Replication Scope)**

The Active Directory database, stored primarily in a single file named NTDS.DIT, is logically segmented into multiple partitions. This division is implemented to facilitate efficient organization and replication of directory data.4 Each partition functions as an independent unit of replication, possessing its own distinct replication topology.15

The primary types of Active Directory partitions include:

* **Schema Partition:** This partition contains the definitions of all object classes and attributes that can be created within the directory. It is replicated to every domain controller across the entire forest.4  
* **Configuration Partition:** This partition stores forest-wide configuration data, which includes information about the Active Directory sites, the replication topology, and the various services available throughout the forest. Like the Schema Partition, it is replicated to all domain controllers in the forest.15  
* **Domain Partition:** This partition holds information specific to a particular domain, such as user accounts, groups, computer accounts, and organizational units. Each domain controller stores a writable copy of its respective domain partition, and this data is replicated among other domain controllers within the *same domain*.4  
* **Application Partitions:** These are user-defined partitions designed to store application-specific data. A key characteristic of application partitions is their customizable replication scope, which allows data to be replicated to a specific set of domain controllers within a forest, regardless of domain boundaries.14 A common and prominent example of their use is for DNS Integrated Active Directory Zones.14 It is important to note that objects stored in application partitions are generally not replicated to the global catalog.15

The utilization of distinct partitions with varying replication scopes (forest-wide, domain-specific, or custom) 15 underscores a design philosophy that balances consistency with operational efficiency. The existence and customizable replication scope of Application Partitions 19 represent a significant optimization. Instead of replicating all data, such as DNS zone information, to every domain controller in the forest or domain, it can be precisely targeted only to the domain controllers running the specific service (e.g., DNS servers).17 This approach substantially reduces replication traffic and enhances performance, particularly for dynamic data.20 This design enables Active Directory to function as a robust and fault-tolerant data store for applications without imposing a rigid or inefficient replication model. It exemplifies how Active Directory can be extended and customized to meet specific application requirements while fully leveraging its underlying replication infrastructure. The limitation that Active Directory Administrative Center (ADAC) cannot restore objects from non-domain partitions 22 further highlights the specialized nature and management requirements of these partition types.

The following table provides a summary of Active Directory partitions, detailing their content and replication scope.

| Partition Type | Content | Replication Scope | Key Characteristics |
| :---- | :---- | :---- | :---- |
| **Schema Partition** | Definitions of all object classes and attributes that can be created in the directory. 4 | Forest-wide; replicated to all domain controllers in the forest. 15 | Defines the fundamental structure of the AD database. Only writable on the Schema Master FSMO role holder. 14 |
| **Configuration Partition** | Forest-wide configuration data, including sites, replication topology, and available services. 15 | Forest-wide; replicated to all domain controllers in the forest. 15 | Contains information critical for the entire forest's operation and inter-site communication. 15 |
| **Domain Partition** | Domain-specific information: users, groups, computers, organizational units. 4 | Domain-specific; replicated to all domain controllers within that particular domain. 15 | Each domain has its own writable domain partition. Data is used by Active Directory Users and Computers. 14 |
| **Application Partition** | Application-specific data (e.g., DNS Integrated Zones). 14 | Customizable; replicated to a specific set of domain controllers within a forest, irrespective of domain boundaries. 15 | User-defined, flexible replication. Objects are generally not replicated to the global catalog. Optimizes replication for dynamic data. 15 |

### **B. Physical Structure**

The physical structure of Active Directory refers to the tangible components and their geographical arrangement that ensure the directory service operates effectively and efficiently across a network.

#### **Domain Controllers (DCs) and Global Catalog (GC): Core Services and Data Storage**

Domain Controllers (DCs) are physical servers with the Active Directory Domain Services (AD DS) server role installed and promoted to function as domain controllers. They are central to the operation of an Active Directory environment, hosting the AD DS database (the ntds.dit file) and containing all information about users, computers, and network resources. DCs are responsible for providing authentication and authorization services, managing security policies, and replicating directory information across the network.1

The Global Catalog (GC) is a critical component that enhances search capabilities across an Active Directory forest. A Global Catalog server holds a full, writable copy of its own domain's partition and a partial, read-only replica of every other domain in the forest.1 This distributed data repository enables users and applications to search for any object in the Active Directory forest without needing to know which domain the object resides in. The partial replicas in the Global Catalog contain a subset of attributes for every object, sufficient for common search queries.

The distributed nature of Domain Controllers, which replicate the Active Directory database among themselves 1, ensures high availability and fault tolerance. If one Domain Controller fails, other DCs can seamlessly take over its responsibilities, minimizing downtime and ensuring business continuity.1 The Global Catalog specifically enhances this distributed model by enabling efficient, forest-wide searches. This means that clients can locate objects anywhere in the forest without having to traverse multiple domains, which significantly improves user experience and application performance, especially in large, multi-domain environments. This architectural design is fundamental to Active Directory's ability to provide both high availability and scalable performance.

#### **Sites and Subnets: Optimizing Replication and Client Authentication**

Active Directory sites are logical groupings of well-connected IP subnets, designed to optimize replication traffic and client authentication processes. Sites are an essential solution for managing organizations with branches spread across different geographical locations, allowing for efficient management of an Active Directory network without altering its logical structure.2

Within sites, subnets are entities that group neighboring computer systems based on their IP addresses. Each subnet is identified by a range of associated IP addresses, and a site is essentially an aggregation of all well-connected subnets.12 Site links are then used to establish connections between Active Directory sites, governing the flow of replication that occurs between them. By configuring properties such as site link schedules, replication costs, and intervals, inter-site replication can be managed for optimal efficiency.24

Client site awareness plays a crucial role in optimizing domain controller location and authentication. When a client needs to find a domain controller, it initiates a DC Locator algorithm, which primarily uses DNS-based discovery. Domain controllers register various Service (SRV) records in DNS, indicating their capabilities (e.g., Key Distribution Center, Global Catalog) and their locality (Active Directory site records). Clients query DNS for these SRV records and then send UDP-based LDAP pings to the discovered servers. This process allows clients to locate the closest and most optimal domain controller within their site.25 If a client is communicating with a DC that is not in its closest site, the DC will return the name of the client's optimal site, prompting the client to seek a more local DC.27 In scenarios where DNS-based discovery fails or is not configured, a fallback to NetBIOS-based discovery (using WINS or broadcasts) may occur.27

Active Directory replication occurs in two main types: intra-site and inter-site. Intra-site replication, which happens within the same site, is designed to be frequent and fast, typically occurring within five minutes of a change to a DC's local AD copy, requiring substantial bandwidth. Inter-site replication, on the other hand, occurs between different sites and is designed to conserve bandwidth. Administrators can schedule inter-site replication during off-peak hours to minimize network impact.24 Replication connections are represented by connection objects in Active Directory, which can be automatically created by the Knowledge Consistency Checker (KCC) or manually configured.28 The KCC dynamically generates and maintains the replication topology, ensuring efficient data transfer.29

The physical structure of Active Directory, particularly the design of sites and subnets, is explicitly engineered to optimize network traffic and enhance performance.23 By grouping high-bandwidth subnets into sites, Active Directory ensures that frequent intra-site replication occurs over fast, local links, while less frequent, scheduled inter-site replication is directed over potentially slower Wide Area Network (WAN) connections.24 This approach significantly minimizes bandwidth consumption and improves overall replication efficiency. Furthermore, client site awareness ensures that users authenticate against the closest available domain controller 24, which reduces logon times and minimizes network latency for authentication requests. This design directly addresses the inherent challenges of operating a distributed directory service across geographically dispersed locations, ensuring both data consistency and a responsive user experience.

## **II. Active Directory Services and Protocols**

Beyond its core architecture, Active Directory encompasses a suite of services and integrates various protocols to deliver comprehensive identity and access management capabilities.

### **A. Active Directory Domain Services (AD DS)**

Active Directory Domain Services (AD DS) is the foundational server role within Active Directory, serving as the central repository for managing users, computers, and other network resources. Its core purpose is to provide robust authentication and authorization services, enabling secure access to network assets. AD DS facilitates centralized management of network elements, allowing administrators to organize data into logical hierarchies, which simplifies administrative tasks and enhances security by enforcing uniform access controls.2

Key features provided by AD DS include:

* **Security Certificates:** Support for digital certificates, which are crucial for secure communication and identity verification.2  
* **Single Sign-On (SSO):** Enables users to access multiple applications and services with a single set of credentials, simplifying the user experience and bolstering security.2  
* **LDAP (Lightweight Directory Access Protocol):** The primary protocol used by AD DS for accessing and managing directory information, providing a standardized way for services to interact with the directory.2  
* **Rights Management:** Controls information rights and data access policies, determining who can access specific folders or perform certain actions.2

Operationally, AD DS stores information in a distributed database, which is replicated across multiple domain controllers. This distributed database design ensures built-in redundancy and fault tolerance; if one domain controller fails, another can seamlessly take over its responsibilities, minimizing service disruption. All access to network resources is channeled through AD DS, centralizing network access rights management.1

### **B. Active Directory Certificate Services (AD CS)**

Active Directory Certificate Services (AD CS) is a Windows server role that provides Public Key Infrastructure (PKI) functionality. Its primary purpose is to issue, manage, and validate digital certificates within an organization. These certificates underpin various security functionalities on the Windows domain, including file encryption, email encryption, network traffic encryption, and secure authentication.30 AD CS enables organizations to build a robust PKI, ensuring the confidentiality, integrity, and availability of information by managing digital identities.31

The main components of AD CS include:

* **Certification Authority (CA):** The core component responsible for issuing and managing digital certificates.31  
* **Certificate Templates:** Define the properties and usage of certificates, ensuring consistency and adherence to organizational policies.31  
* **Certification Authority Web Enrollment:** Allows users and computers to request certificates through a web-based interface.31  
* **Online Responder:** Implements the Online Certificate Status Protocol (OCSP) to check the real-time revocation status of certificates.31  
* **Network Device Enrollment Service (NDES):** Automates the enrollment of network devices that do not support the native certificate enrollment process.31

AD CS operates by implementing a PKI framework. The Certification Authority (CA) verifies the identity of users or computers and issues them digital certificates. These certificates contain a public key and other information, such as the issuer's identity and validity period. When a user or computer needs to establish a secure connection or authenticate itself, it uses its private key to digitally sign or encrypt data. The recipient then uses the public key in the sender's certificate to verify the signature or decrypt the data, with the CA's public key verifying the certificate's authenticity.31

AD CS integrates seamlessly with Active Directory Domain Services (AD DS), simplifying user and computer authentication and authorization. When deployed, AD CS can store issued certificates and Certificate Revocation Lists (CRLs) in AD DS for easy access by domain-joined clients. AD DS can also automate the enrollment of users and computers for certificates, streamlining the issuance process. Furthermore, AD CS can leverage information from AD DS, such as user or computer attributes, to automatically populate certificate fields and enforce certificate policies, enhancing overall security.31

Security best practices for AD CS emphasize securing the underlying infrastructure, implementing robust backup and recovery procedures, and performing regular monitoring and maintenance. This includes limiting administrative access to dedicated accounts, using application whitelisting on CAs, regularly backing up the AD CS database and private keys, and storing backups offsite. Continuous monitoring of event logs, certificate expiration, and revocation checking through CRLs or OCSP is crucial. Developing a clear PKI policy and using certificate templates are also vital for consistent and secure certificate usage.32

### **C. Active Directory Federation Services (AD FS)**

Active Directory Federation Services (AD FS) is a Single Sign-On (SSO) feature developed by Microsoft that provides secure, authenticated access to various resources. This includes applications and systems within an organization's Active Directory (AD), as well as approved third-party systems. AD FS is "federated," meaning it centralizes the user's identity, allowing individuals to use their existing AD credentials to access applications both within the corporate network and with trusted external sources, such as cloud networks or SaaS applications. AD FS also enables users to access AD-integrated applications while working remotely via the cloud. The primary purpose of AD FS is to simplify the user experience while simultaneously allowing the organization to maintain strong security policies.2

AD FS operates similarly to a general SSO solution by authenticating the user's identity and verifying their access privileges. The operational mechanisms involve:

* **Verifying User Identity:** AD FS SSO leverages information from the company's data repository (e.g., full name, employee number, email address) to confirm the user's identity.34  
* **Managing User Claims:** AD FS employs a claims-based authentication model. It generates a secure token containing "claims" or access rights for each user. When a user attempts to access a system, AD FS checks the request against a list of approved systems and applications within the AD or Azure AD (now Microsoft Entra ID), covering both internal and third-party assets.34  
* **Federated Trust:** For third-party systems, AD FS authentication is achieved through a proxy service that combines the user's identity and claim rules. This "Federated Trust" or "party trust" allows users to bypass direct authentication with each individual application.34

The AD FS authentication process typically involves the user accessing an AD FS service link, entering credentials, AD FS authenticating the identity, generating a personalized authentication claim, and forwarding this claim to the target application, which then grants or denies access based on the claim's terms.34

Technical components of AD FS include the Federation Server (maintaining security tokens), the Federation Server Proxy (acting as a gateway between AD and external targets), and Azure AD Connect (linking Active Directory with Azure AD in hybrid deployments).34

Benefits of AD FS for end-users include simplicity (single set of credentials), improved user experience (seamless access), and efficiency gains. For organizations, benefits include reduced IT support requests (fewer password resets), simplified deactivation of accounts, and overall organizational efficiency.34 However, AD FS does come with limitations, such as infrastructure and maintenance costs (requiring Windows Server licenses and dedicated servers), complexity in configuration and deployment, and the fact that it does not inherently support file sharing, print servers, or most remote desktop connections.34

Security best practices for AD FS deployments are critical given its role as a central identity management component. These include implementing SSL/TLS to encrypt data in transit, securing the AD FS server through network isolation and operating system hardening, and mandating Multi-Factor Authentication (MFA) for all external users. Role-Based Access Control (RBAC) should be applied for managing AD FS administrative privileges. Continuous monitoring and auditing of AD FS activity, securing federation trusts with partner organizations, and conducting regular security assessments (e.g., penetration testing) are also paramount. Finally, planning for business continuity and disaster recovery, along with keeping all software updated, are essential to maintain a robust and available AD FS infrastructure.34

### **D. Active Directory Rights Management Services (AD RMS)**

Active Directory Rights Management Services (AD RMS) is an on-premises server role in Windows Server designed to provide Information Rights Management (IRM) functionality. Its primary purpose is to help organizations protect sensitive digital content from unauthorized access and usage. AD RMS achieves this by integrating with industry security technologies, including encryption, certificates, and authentication, to enable the creation of reliable information protection solutions.37

Operationally, AD RMS augments an organization's security strategy by enforcing usage policies directly on documents, workbooks, and presentations. Through IRM policies, administrators and individual users can specify precise access permissions, such as preventing unauthorized printing, forwarding, or copying of sensitive information. A critical aspect of AD RMS is that once permissions are applied using IRM, these access and usage restrictions remain enforced regardless of where the information is moved, sent, or forwarded, because the permission metadata is embedded within the document file itself.37

Practical applications of IRM solutions enabled by AD RMS include:

* **Persistent Usage Policies:** Policies travel with the information, maintaining control over its use even after it leaves the original storage location.  
* **Enhanced Privacy:** Provides an additional layer of protection for sensitive data (e.g., financial reports, customer data, confidential emails) from intentional or accidental disclosure.  
* **Prevention of Unauthorized Actions:** Prohibits authorized recipients from forwarding, copying, modifying, printing, faxing, or pasting content for unauthorized use.  
* **Screen Capture Prevention:** Helps prevent content from being copied using the Print Screen feature in Microsoft Windows.  
* **File Expiration Support:** Allows content to become unviewable after a specified period, enforcing data lifecycle policies.  
* **Corporate Policy Enforcement:** Aids in enforcing internal policies governing content use and dissemination.37

However, it is important to understand the limitations of IRM-based solutions supported by AD RMS. AD RMS does not mitigate all types of document security threats or prevent the disclosure of screen-readable information under all circumstances. For example, it does not protect against content being erased, stolen, or captured by malicious programs like Trojan horses or keyloggers. It also cannot prevent content loss due to viruses, manual retyping from a screen, digital photography of displayed content, or copying via third-party screen-capture programs.37

Security best practices for AD RMS revolve around its core principles of encryption and policy management. The system relies on its ability to encrypt files and apply granular usage policies to secure data effectively.39

### **E. Active Directory Lightweight Directory Services (AD LDS)**

Active Directory Lightweight Directory Services (AD LDS), formerly known as Active Directory Application Mode (ADAM) in earlier Windows Server versions, is a Microsoft technology that provides directory services in a more lightweight and flexible form than a full Active Directory domain controller. It is specifically designed for scenarios where applications require directory services but do not necessitate the full dependencies of Active Directory Domain Services (AD DS), such as domain-wide authentication or replication.40 AD LDS allows for the storage of application-specific data and management of identities without requiring a full AD domain.

Key technical specifications and operational mechanisms of AD LDS include:

* **Lightweight Nature:** AD LDS is a streamlined version of Active Directory, omitting some of the complexities and features of a full AD domain controller. This design makes it highly flexible and suitable for various directory-related purposes without the overhead of a complete AD deployment.41  
* **Directory Data Storage:** Similar to AD DS, AD LDS stores directory data, but it operates independently of a Windows domain structure. Data is organized hierarchically in a Directory Information Tree (DIT) structure, comprising objects with various attributes.41  
* **LDAP Protocol:** AD LDS primarily communicates using the Lightweight Directory Access Protocol (LDAP) standard. This adherence ensures compatibility with a broad range of directory-aware applications and services.41  
* **Custom Schemas:** A significant feature of AD LDS is its ability to define custom directory schemas and attributes. This allows administrators to tailor the directory service precisely to specific application requirements, particularly useful when standard AD schema might not adequately accommodate the data.41  
* **Application Directory Partitions:** AD LDS instances are organized into one or more application directory partitions. Each partition can maintain its own distinct schema, data, and security configurations, facilitating the isolation and management of different datasets.41  
* **Authentication and Authorization:** AD LDS can provide authentication and authorization services for applications by storing user and group information. It is crucial to note that AD LDS handles application-level access control and does *not* manage domain-level user authentication, which remains the purview of a full AD domain controller.41  
* **Replication:** AD LDS supports replication, enabling the distribution of directory data across multiple instances for redundancy and load balancing. Replication can be configured between different AD LDS instances or between an AD LDS instance and a full Active Directory domain controller.41

Common use cases for AD LDS include storing user profiles for web applications, managing application-specific directory data, and providing directory services for non-Windows applications.41

Security best practices for AD LDS deployments focus on mitigating risks associated with directory services. These include limiting LDAP access by implementing network segmentation and access controls to reduce exposure. Enforcing strong password policies (minimum length, character diversity, regular expiration) and implementing Multi-Factor Authentication (MFA) for AD LDS accounts are also crucial. Enabling LDAP Signing and LDAP Channel Binding helps protect against man-in-the-middle attacks. Adhering to the principle of least privilege, granting users, computers, and services only the minimum necessary privileges, is vital to reduce the attack surface.43

## **III. Core Protocols and Technologies in Active Directory**

Active Directory's functionality is deeply intertwined with several core networking protocols and technologies that facilitate its operations, from authentication to file sharing.

### **A. Single Sign-On (SSO)**

Single Sign-On (SSO) is an authentication method that allows users to sign in once with a single set of credentials and gain access to multiple independent software systems or applications. The primary benefit of SSO is that users do not have to sign in to every application they use, eliminating repetitive credential entry across different platforms.1

The benefits of SSO extend beyond convenience:

* **Seamless Integration with Applications:** SSO effortlessly integrates with a wide range of applications, providing smooth functionality across enterprise ecosystems.46  
* **Simplified User Access:** By centralizing authentication, SSO streamlines user access, boosting productivity by reducing disruptions from repeated logins.46  
* **Enhanced Security:** SSO minimizes risks associated with multiple login attempts and reduces password fatigue, which often leads to weak or reused credentials. Features like Multi-Factor Authentication (MFA) can be integrated to add an additional layer of security.46  
* **Reduced Password Fatigue:** Users no longer need to remember or manage multiple passwords, improving the user experience and enhancing security by discouraging poor password habits.46  
* **Streamlined IT Management:** SSO simplifies IT operations by reducing password reset requests and other login-related issues, allowing IT teams to focus on more strategic initiatives.46

Active Directory Single Sign-On (AD SSO) leverages authentication protocols such as SAML (Security Assertion Markup Language) and OAuth (Open Authorization) to provide seamless and secure user access. When a user first logs in, Active Directory generates an access token, a digital key that grants permission to the authorized suite of applications. This token is stored locally on the user's device and is checked each time the user accesses a new application, seamlessly validating their credentials.46

* **SAML:** An XML-based protocol for secure and efficient user authentication and authorization, enabling identity providers (like AD) to share authentication information with service providers (applications). It is typically used for legacy or on-premises applications that may not support OAuth or OpenID Connect.45  
* **OAuth (with OpenID Connect):** A modern protocol primarily for authorization, commonly used in cloud and mobile applications. When combined with OpenID Connect (OIDC), it also supports authentication workflows. OAuth allows users to grant limited access to applications without sharing their passwords and is suitable for cloud-based or third-party applications, enabling granular access control.45

The choice between SAML and OAuth depends on the application's environment and its protocol support.46 It is also important to differentiate between AD SSO (primarily for on-premises networks) and Azure AD SSO (designed for cloud services, providing SSO access to web-based applications from anywhere).46

The implementation of Single Sign-On (SSO) represents a significant convergence of user experience and security objectives. By simplifying user access through the reduction of repeated logins 1, SSO dramatically improves user productivity and satisfaction.34 Beyond mere convenience, SSO fundamentally enhances an organization's security posture by mitigating password fatigue, a common cause of weak or reused credentials.46 The centralization of authentication through SSO also facilitates the consistent enforcement of robust security policies, such as Multi-Factor Authentication (MFA), across a multitude of applications.46 This dual benefit of improved user convenience and strengthened security is a primary driver for the widespread adoption of SSO in modern enterprise identity management strategies.

### **B. Domain Name System (DNS)**

The Domain Name System (DNS) is arguably one of the most critical services for Active Directory, as AD is fundamentally built upon it. DNS provides name resolution services, translating human-readable hostnames, URLs, and Fully Qualified Domain Names (FQDNs) into machine-readable IP addresses. In the context of Active Directory, DNS maintains a database of services running on the network, stored as Service (SRV) records. These SRV records are crucial for clients in an Active Directory environment to locate necessary services, such as printers, and are also used to identify domain controllers.1

DNS operates through a distributed database, meaning information about domains, subdomains, and host mappings is spread across multiple DNS servers. To simplify management, the DNS namespace is divided into zones, with each zone's responsibility delegated to a specific server. An Active Directory DNS zone is a collection of hierarchical domain names where the root domain is delegated to one or more name servers.2 Common types of DNS resource records include:

* **A Record:** Maps a hostname to an IPv4 address.  
* **CNAME Record:** Creates an alias for a domain.  
* **MX Record:** Identifies the mail server for a domain.  
* **SRV Record:** Maps a service to a particular server.25

Active Directory supports Dynamic DNS, which automates updates to the DNS database. This is essential because manual entries are time-consuming and prone to errors when IP addresses change. Dynamic DNS allows newly installed servers to automatically register their IP addresses and SRV records with the DNS server.25 When a Domain Controller (DC) boots, it registers its AD DNS entry with an A record and also registers SRV records that map services like Kerberos and LDAP to itself. Clients locate DCs by querying DNS for these SRV records.25 Without DNS, clients would be unable to authenticate into Active Directory or find various network services.25

#### **DNS Proxy through Firewall: Implications and Best Practices**

A firewall can be configured to act as a DNS proxy, listening for DNS requests on specified interfaces and then forwarding them to appropriate DNS servers. This proxy object can include caching of resolved domains and static FQDN-to-address entries, allowing the firewall to resolve FQDNs without querying an external DNS server.48

However, allowing DNS traffic, even through a proxy, carries significant security implications. DNS is a common vector for data exfiltration, where attackers embed stolen data within DNS packets to bypass firewalls and security systems, as DNS traffic is generally allowed and not strictly monitored.49 This technique is often an outcome of DNS tunneling attacks, which exploit legitimate DNS protocols for covert communication.49 Other DNS-based threats include DNS spoofing (redirecting users to malicious websites) and DNS hijacking.51

To mitigate these risks, several security best practices are crucial:

* **Enable Evasion Signatures:** Configure the DNS proxy to trigger alerts if crafted requests are detected.48  
* **Restrict Outbound DNS Traffic:** Firewalls and proxies should be configured to prevent unauthorized connections to external DNS servers and block DNS requests to known malicious domains.49  
* **Implement DNSSEC:** Domain Name System Security Extensions add an extra layer of security by digitally signing DNS data, protecting against DNS spoofing and cache poisoning attacks.51  
* **Deploy DNS Firewalls:** These solutions inspect DNS traffic in real-time, leveraging threat intelligence to block malicious requests and data exfiltration attempts.49  
* **Monitor DNS Traffic:** Continuously monitor DNS traffic for unusual behavior, such as abnormal query volumes, unusual domain patterns, or suspicious query lengths, which can indicate exfiltration activities.50  
* **Keep DNS Servers Updated:** Regularly apply security patches and updates to DNS servers to address vulnerabilities and guard against known exploits.49  
* **Secure Active Directory-Integrated DNS Zones:** Utilize AD-integrated DNS zones for enhanced security through Access Control Lists (ACLs) and secure dynamic updates.52

DNS is fundamental to Active Directory's operation 25 and is often implicitly trusted by firewalls.49 This inherent trust makes DNS an attractive and often overlooked vector for attackers to exfiltrate data.49 While a firewall acting as a DNS proxy offers some level of control 48, relying solely on basic firewall rules is insufficient to counter sophisticated threats. Therefore, a multi-layered defense strategy is paramount. This includes implementing DNSSEC for data authenticity, employing DNS filtering to block malicious domains, and continuously monitoring DNS traffic for anomalies.49 This comprehensive approach is critical to protecting the integrity and security of the Active Directory environment, as even foundational protocols require advanced security measures to defend against modern threats.

### **C. Kerberos**

Kerberos is a highly secure, ticket-based authentication protocol that uses symmetric-key cryptography to verify the identity of users and hosts within Active Directory environments.1 It is the default authentication protocol in modern Windows Active Directory domains, designed to replace less secure methods like NTLM.55

The operational flow of Kerberos is based on a ticket system involving a trusted third party, the Key Distribution Center (KDC), which typically runs on a domain controller as part of AD DS.53 The KDC comprises two main components: the Authentication Server (AS) and the Ticket Granting Server (TGS).57

The authentication process unfolds as follows:

1. **Initial Authentication:** When a user logs into a client machine, their credentials (e.g., password) are used to encrypt an authenticator. This authenticator is sent to the KDC's Authentication Server (AS).53  
2. **Ticket Granting Ticket (TGT) Issuance:** The AS verifies the user's identity by decrypting the authenticator with the user's secret key (derived from their password). If successful, the AS issues a Ticket Granting Ticket (TGT) to the client. The TGT is encrypted with a key known only to the KDC and the client's secret key, and it is stored securely in the client's Kerberos tray.53  
3. **Service Ticket Request:** When the client needs to access a specific network resource (e.g., a file share, an application), it presents its TGT to the KDC's Ticket Granting Server (TGS), along with a request for a Service Ticket (ST) for the desired resource.53  
4. **Service Ticket Issuance:** The TGS verifies the TGT. If valid, the TGS issues a Service Ticket (ST) for the requested service. This ST is encrypted with the service's secret key (known only to the TGS and the target service) and sent back to the client.53  
5. **Service Authentication:** The client presents the ST directly to the target service. The service decrypts the ST using its own secret key, verifies the client's identity and authorization, and if successful, grants access. A secure session is then established for communication.53

Kerberos offers several significant benefits:

* **Single Sign-On (SSO):** After initial domain sign-on, Kerberos manages credentials throughout the forest, allowing users to access resources without multiple credential requests.53  
* **Mutual Authentication:** Both the client and the server can verify each other's identity, providing a higher level of security than protocols where only the client authenticates to the server.53  
* **Delegated Authentication:** Supports mechanisms for a service to act on behalf of its client when connecting to other services, crucial for distributed applications.53  
* **Efficient Authentication:** Uses renewable session tickets, reducing the need for servers to constantly contact domain controllers for client authentication.53  
* **Interoperability:** Microsoft's implementation is based on IETF standards, promoting interoperability with other Kerberos-enabled networks.53

Kerberos tickets have two distinct lifetimes: a **ticket lifetime** and a **renewable lifetime**. After the ticket lifetime expires, the ticket can no longer be used. However, if the renewable lifetime is longer, the ticket can be presented to the KDC for a new ticket with a fresh ticket lifetime, without requiring re-entry of credentials. This renewal can be automated by background utilities. Once the renewable lifetime is exhausted, or if the ticket is not renewed before its ticket lifetime expires, re-authentication with credentials is required. This renewable ticket mechanism allows the KDC to deny renewal requests if an account is compromised, enhancing security.57

Security best practices for Kerberos include using strong encryption (e.g., AES), auditing authentication service and service ticket operations, and securing the krbtgt account (the KDC's own account for issuing TGTs), which is a common target for Golden Ticket attacks.57

### **D. Lightweight Directory Access Protocol (LDAP)**

The Lightweight Directory Access Protocol (LDAP) is a fundamental software protocol used by Active Directory to access and manage directory information. It acts as a standardized communication language, enabling applications and services to interact with directory services for tasks such as retrieving, modifying, and authenticating user information.1

LDAP organizes directory information into a hierarchical, tree-like structure, where each entry represents a unique object (e.g., a user, device, or application) and contains a set of attributes describing its properties. This structure facilitates efficient data retrieval and management.61

LDAP supports two primary authentication types:

* **Simple Authentication:** This method requires only a distinguished username and password. While straightforward, it can pose a security risk if credentials are sent in cleartext. To mitigate this, simple authentication should ideally be used within an encrypted channel supported by the LDAP server.42  
* **SASL (Simple Authentication and Security Layer):** SASL provides a framework that allows an LDAP server to bind to other authentication mechanisms, such as Kerberos. This method enhances security by decoupling authentication mechanisms from application protocols, with the LDAP server attaching a security layer to protect data even if messages are sent in clear text to other authorization services.42

LDAP queries are commands used to retrieve specific information from the directory. For example, an LDAP query can be used to view expired user accounts or to list the groups a particular user belongs to.42 Active Directory leverages the LDAP protocol extensively for various directory access services, including searching for objects (computers, groups), adding new information, or removing existing data.42

LDAP contributes to Active Directory security by enabling the use of encrypted channels to prevent password exposure and by supporting more robust authentication methods like SASL. This helps protect against attacks that compromise AD accounts.42

Security best practices for LDAP in Active Directory environments include:

* **Using LDAPS (LDAP over SSL/TLS):** This encrypts LDAP traffic, protecting user credentials and sensitive directory data from interception. Implementing LDAPS requires setting up certificates and configuring all communicating systems to use secure connections.43  
* **Enabling LDAP Signing and Channel Binding:** These processes help protect against man-in-the-middle attacks that could lead to unauthorized access to service accounts.44  
* **Limiting LDAP Access:** Restricting access to LDAP by implementing network segmentation and access controls reduces the exposure of the directory service.44  
* **Strong Password Policies and MFA:** Enforcing complex password policies and implementing Multi-Factor Authentication (MFA) for AD accounts, especially for administrators, further strengthens security.43  
* **Principle of Least Privilege:** Granting users, computers, and services only the minimum necessary privileges to perform their tasks reduces the risk of unauthorized access.44

### **E. NT LAN Manager (NTLM)**

NT LAN Manager (NTLM) refers to a family of proprietary authentication protocols from Microsoft. Introduced with Windows NT 3.1, NTLM replaced the earlier LM hash method due to security vulnerabilities. While NTLMv2, introduced with Windows NT 4.0 SP4, improved upon NTLMv1, both are considered legacy protocols. Starting with Windows 2000, NTLM was largely superseded by Kerberos as the standard authentication protocol for Active Directory (AD) domains. However, NTLM versions are still supported in current Windows systems for backward compatibility, local logon, network logon for workgroups, some HTTP servers, and for certain Single Sign-On (SSO) scenarios.55

NTLM protocols authenticate users and computers based on a challenge-response mechanism, where the user proves knowledge of a password without transmitting it over the network.62 The operational flow typically involves three messages:

1. **NEGOTIATE:** The client sends a request to a server with the username and other configuration information.58  
2. **CHALLENGE:** The server generates a random number (a "challenge") and sends it to the client.58  
3. **AUTHENTICATE:** The client encrypts this random number using a hash of the user's password (NT hash for NTLMv2) and sends the encrypted response back. The server then verifies this response, either locally or by forwarding it to a domain controller for validation.58

Despite its continued presence for compatibility, NTLM has several significant security vulnerabilities:

* **Pass-the-Hash (PtH):** Attackers can exploit the reliance on password hashes. If an attacker obtains a user's password hash, they can use it directly for NTLM authentication without needing the actual password.62  
* **Brute Force Attacks:** NTLM's hashing algorithms (MD4/MD5) do not use "salt" (a random string added to the password before hashing), making them vulnerable to brute-force attacks and rainbow table attacks, especially with insufficient password complexity.58  
* **NTLM Relay Attacks:** The NTLM challenge-response mechanism does not inherently provide mutual authentication, meaning the client cannot verify the server's identity. This allows attackers to perform man-in-the-middle (MitM) attacks by relaying authentication requests between the client and server.62  
* **Lack of Multi-Factor Authentication (MFA) Support:** NTLM does not support MFA, meaning a single compromised password hash is sufficient for authentication, without requiring a second factor.58  
* **Outdated Cryptography:** NTLMv1 uses DES, and NTLMv2 uses HMAC-MD5, both considered cryptographically weak or outdated by modern standards. NTLM also converts lowercase password letters to uppercase before hashing, limiting complexity.56

Microsoft has an ongoing deprecation roadmap for NTLM, strongly encouraging a transition to Kerberos. NTLMv1 is being removed, starting with Windows 11 version 24H2 and Windows Server 2025\. LANMAN and NTLMv2 are no longer under active feature development and are deprecated. Microsoft recommends replacing calls to NTLM with "Negotiate," which attempts Kerberos first and falls back to NTLM only if necessary.24

For on-premises session management, NTLM network authentication allows a configurable grace period (default five minutes) where an old password can still be used for network access after a password change. This is intended to allow background processes (like service accounts) to continue running while password changes propagate across systems. This behavior applies only to NTLM network access for domain users and does not affect interactive logon or accounts on standalone servers.66

The following table provides a comparison between Kerberos and NTLM, highlighting their key features, operational mechanisms, and security characteristics.

| Feature | Kerberos | NTLM |
| :---- | :---- | :---- |
| **Protocol Type** | Ticket-based authentication protocol 54 | Challenge-response authentication protocol 55 |
| **Primary Use Case** | Domain authentication in Active Directory environments 56 | Local authentication, legacy systems, workgroup environments, fallback for Kerberos 56 |
| **Single Sign-On (SSO)** | Fully supported 53 | Not supported inherently; provides a form of SSO for specific scenarios 56 |
| **Encryption** | Symmetric key cryptography, uses AES (Advanced Encryption Standard) 54 | Password hashing (MD4/MD5 for NTLMv1/v2), no salting 56 |
| **Mutual Authentication** | Yes, both client and server verify each other 53 | No, only client authentication; server identity not verified 55 |
| **Password Transmission** | Passwords never transmitted over the network; uses tickets 54 | Password hash is used, but not transmitted in cleartext; vulnerable to Pass-the-Hash 62 |
| **Multi-Factor Authentication (MFA)** | Supports MFA 46 | Does not support MFA 58 |
| **Delegation/Impersonation** | Supports both delegation and impersonation 53 | Only supports impersonation 55 |
| **Resource Requirements** | More resource-intensive initially, but efficient for subsequent authentications 56 | Less resource-intensive initially, faster for small networks 56 |
| **Vulnerabilities** | Golden Ticket, Silver Ticket, DCShadow attacks 57 | Pass-the-Hash, Brute Force, NTLM Relay attacks 56 |
| **Deprecation Status** | Preferred protocol 56 | NTLMv1 removed in Windows Server 2025; LANMAN and NTLMv2 deprecated 67 |

### **F. Server Message Block (SMB)**

Server Message Block (SMB) is a network file sharing protocol that enables applications on a computer to read and write to files, and request services from server programs across a computer network. SMB serves as the basis for Microsoft's Distributed File System (DFS) implementation.73

SMB operates on a client-server model, where clients request access to resources and servers provide those resources. The protocol primarily relies on TCP and IP for transport, with the SMB server component typically using TCP port 445\. Historically, SMB also operated over NetBIOS over TCP/IP (NetBT) using ports 137, 138, and 139, but these protocols have since been deprecated by Microsoft in favor of direct TCP/IP communication.73

For authentication, SMB integrates with Active Directory. In Windows domain networks, SMB uses the Kerberos protocol to authenticate users. For simpler, peer-to-peer networks, or as a fallback when Kerberos is unavailable, SMB utilizes the NTLM protocol.56 SMB ensures that only authorized users can access shared resources by employing these authentication and authorization mechanisms, including usernames, passwords, and advanced options like Kerberos and Active Directory.75

SMB has evolved through multiple versions, or "dialects," with significant enhancements in performance, security, and functionality.

* **SMB1 (CIFS):** The oldest and least secure version, now largely deprecated.75  
* **SMB2 and SMB3:** Introduced significant improvements, including enhanced security features. SMB 3.0 brought capabilities like file storage for virtualization (Hyper-V over SMB) and Microsoft SQL Server over SMB, allowing virtual machine files and database files to be stored on SMB file shares.74  
* **SMB 3.1.1:** Introduced with Windows Server 2016 and Windows 10, this version offers advanced features like AES-GCM encryption (faster than previous encryption or signing), enhanced directory caching, and pre-authentication integrity to protect against man-in-the-middle attacks during connection establishment and authentication.74 SMB over QUIC, available in Windows Server 2022 Datacenter: Azure Edition, updates SMB 3.1.1 to use the QUIC protocol instead of TCP, enabling secure and reliable access to file servers over the internet without a VPN.78

Security best practices for SMB are crucial due to its fundamental role in file sharing. US-CERT recommends disabling SMBv1 and blocking all versions of SMB at the network boundary (TCP port 445, UDP ports 137-138, TCP port 139\) for boundary devices, while cautioning about potential disruptions.79 Other best practices include:

* **Use Latest SMB Versions:** Replace SMB1 with SMB 3.0 or higher to leverage enhanced security features like end-to-end data encryption, secure dialect negotiation, and pre-authentication integrity.76  
* **Apply Regular Updates:** Keep operating systems and SMB software updated with security patches to fix vulnerabilities.76  
* **Enable SMB Signing:** Digitally signing SMB messages helps prevent certain man-in-the-middle attacks. Domain controllers running Windows Server 2003 and later are configured by default to not allow unsigned incoming connections.73  
* **Network Segmentation:** Divide the network into sub-networks to limit the impact of breaches and lateral movement of threat actors.76  
* **Firewall Controls:** Use firewalls with advanced controls to regulate outbound SMB destinations and prevent connections to potentially malicious servers.76

### **G. Network Attached Storage (NAS) Integration**

Network Attached Storage (NAS) devices can be integrated with Active Directory to leverage AD for centralized user authentication and authorization. By joining a NAS service to an existing Active Directory domain, the NAS automatically imports user accounts from the AD server, allowing AD users to access NAS shares using their existing login credentials.80 This integration streamlines user and rights management, providing centralized control over access to shared storage resources.

Technical requirements for successfully integrating a NAS with an Active Directory domain include:

* **DNS Resolution:** The NAS service must be able to resolve the Active Directory domain controller's name (Realm) via DNS. This often requires correct DNS server settings in the NAS's IP configuration.80  
* **Valid IP Configuration:** The NAS service needs a valid IP address, gateway, and DNS server settings, with a static or reserved DHCP IP address being recommended.80  
* **Correct Workgroup/Realm:** The NAS must be configured with the correct short-form domain (Workgroup) and long-form domain (Realm) to successfully join the AD domain.80  
* **AD Administrator Permissions:** The Active Directory user account used to join the NAS to the domain must have sufficient administrative privileges to create computer objects within the AD domain, ideally in a specified Organizational Unit (OU) if one is used.80

NAS integration with Active Directory typically utilizes several authentication and file-sharing protocols:

* **CIFS/SMB:** For Windows file sharing, NAS devices commonly support CIFS (Common Internet File System), which is an older name for SMB. SMB relies on Kerberos for authentication in AD domains and NTLM for legacy or fallback scenarios.73  
* **NFS (Network File System):** For UNIX/Linux environments, NAS devices support NFS. NFS authentication can be strengthened through Kerberos, which requires a working Kerberos setup with a Key Distribution Center (KDC) and proper service records (SRV) in DNS.82  
* **Kerberos:** As the primary authentication protocol in AD, Kerberos validates user identities for both SMB and NFS access to NAS shares. It uses secret keys derived from user passwords to generate tickets, ensuring secure communication.82  
* **LDAP:** While Kerberos handles authentication, LDAP is used by NAS devices to query Active Directory for user and group information, enabling authorization and access control based on AD group memberships.1

The ability of NAS devices, which often support multiple file protocols like CIFS/SMB and NFS, to integrate with existing identity systems is a significant advantage.82 By joining an Active Directory domain, NAS devices can centralize user authentication and authorization. This means that users do not require separate credentials for accessing network shares, as their existing AD credentials are used.80 This capability extends Active Directory's robust identity management features to heterogeneous storage environments, simplifying administration and ensuring consistent access policies across diverse platforms (Windows, UNIX/Linux). This integration is crucial for maintaining a unified security posture and a seamless user experience within complex IT landscapes.

### **H. Proxy Servers and Active Directory Integration**

Proxy servers can integrate with Active Directory to authenticate users, controlling their access to network resources, particularly internet access. This integration often aims for "silent authentication," where the user's browser automatically sends Windows session credentials to the proxy, eliminating the need for manual login prompts.85

Common authentication methods used for proxy integration with Active Directory include:

* **NTLM Authentication:** Often used for Windows networks, NTLM provides challenge-response authentication. It is session-based, reducing credential transmission, and integrates directly with Windows domain authentication. While suitable for internal corporate networks, its security limitations (e.g., vulnerability to relay attacks) make it less desirable than Kerberos.85  
* **Negotiate/SPNEGO Authentication:** This mechanism allows clients and servers to negotiate the best authentication protocol to use, typically choosing between Kerberos and NTLM. It provides Single Sign-On (SSO) capabilities and is generally more secure and complex than earlier methods, making it well-suited for enterprise environments.86 If Kerberos fails, the browser will attempt to use NTLM.85  
* **LDAP only:** This method uses the LDAP protocol (typically port 389 or 686\) to verify user credentials. Unlike NTLM or Kerberos, it is not "silent" and usually requires users to enter their credentials in a login box, as it does not rely on the workstation being domain-joined.85

Beyond general proxy integration, Active Directory Federation Services (AD FS) utilizes a specialized component called a **federation server proxy**. The primary role of this proxy, often located in the perimeter network, is to collect authentication credentials from client computers logging on over the internet and securely pass those credentials to the internal federation server. This enables SSO access for external users to various applications, including approved third-party systems.34 The proxy also facilitates the distribution of security tokens to internet clients. It is important to note that a federation server proxy does not accept credentials through Windows Integrated Authentication directly.89

Security best practices for proxy server integration with Active Directory authentication are crucial to protect sensitive credentials and control network access:

* **Always Use HTTPS:** Encrypt all proxy communication to protect credentials in transit.86  
* **Implement Credential Rotation:** Enforce regular password changes or token refreshes for proxy accounts.86  
* **Apply Principle of Least Privilege:** Grant only the necessary access levels to proxy service accounts and users.52  
* **Enable Logging and Monitoring:** Track authentication events for security analysis and to detect suspicious activity.52  
* **Consider MFA:** Add additional verification layers for sensitive environments, especially for external access.86  
* **Configure Firewalls:** If internet access is required for a domain controller, use a proxy server to control access, allowing only necessary traffic and blocking all other traffic. Implement DNS filtering to prevent communication with known malicious domains.52  
* **Single Sign-On Configuration:** If using Active Directory authentication with a proxy, ensure the firewall is configured to use Single Sign-On to improve reporting based on authenticated usernames.90

### **I. Session Management in Active Directory**

Session management in Active Directory environments primarily revolves around how user authentication protocols, particularly Kerberos and NTLM, establish, maintain, and terminate user access to network resources.

For on-premises session management, Active Directory provides mechanisms and tools to control user logins and access. This includes the ability to create policies for Multi-Factor Authentication (MFA), limit the number of concurrent login attempts, restrict which computers can be used for logins (via IP addresses, computers, groups, or OUs), and remotely intervene to block or terminate active sessions from a management console. This ensures secure access control and allows for real-time monitoring and analysis of user activity.91 Active Directory integrates with session management solutions, requiring computers to be domain members and user accounts to be Active Directory accounts.91

**Kerberos Ticket Lifecycles:** Kerberos authentication is central to session management in modern AD. A Kerberos ticket has two distinct lifetimes:

* **Ticket Lifetime:** Defines the period during which the ticket can be used. After this period, the ticket is no longer valid.59  
* **Renewable Lifetime:** If this lifetime is longer than the ticket lifetime, the ticket holder can, at any point before either lifetime expires, present the ticket to the Key Distribution Center (KDC) to request a new ticket. This new ticket will typically have a fresh ticket lifetime dating from the current time, constrained by the renewable lifetime. This renewal process does not require re-entering credentials and can be performed quietly by a program on the user's behalf.57

  The KDC issues these tickets, and they are stored in the client's Kerberos tray. Tickets issued by the KDC have a limited validity period, and clients need to renew them periodically to continue accessing services without re-authentication. The KDC can decline renewal requests if an account is compromised, enhancing security.57

**NTLM Session Establishment and Termination:** NTLM, as a challenge-response protocol, establishes sessions through a three-message handshake involving password hashing.58 For NTLM network authentication, there is a specific behavior regarding password changes: after a domain user successfully changes a password, the old password can still be used for network access for a user-definable time period (defaulting to five minutes). This feature allows background processes, such as service accounts logged on to multiple computers, to continue accessing the network while the password change propagates. This extension of the password lifetime applies only to NTLM network access and does not affect interactive logon behavior. The lifetime period can be configured by editing a registry key on a domain controller.66

Session management in Active Directory, particularly through the use of Kerberos tickets, is designed to balance continuous user access with robust security controls.53 The concept of renewable tickets allows users to maintain authenticated sessions for extended periods without the inconvenience of repeatedly re-entering their credentials, thereby improving productivity. However, these tickets are intentionally designed with limited validity periods, which provides a critical security mechanism: the KDC retains the ability to revoke access if an account is detected as compromised.59 Similarly, NTLM's grace period for old passwords, while offering operational continuity during password changes 71, must be carefully managed to prevent potential security vulnerabilities. This inherent balance between operational efficiency and stringent security measures highlights Active Directory's fundamental design objective: to provide a highly available and secure environment without unduly disrupting legitimate user activity.

## **IV. Active Directory Roles and Administration**

Effective administration of Active Directory relies on a clear understanding of specialized roles and the proper management of security groups.

### **A. Flexible Single Master Operations (FSMO) Roles**

Active Directory operates primarily on a multi-master replication model, meaning changes can originate on any domain controller and then replicate to others. However, certain operations require a single, authoritative master to prevent conflicts and ensure consistency across the directory. These unique, single-master operations are handled by specific domain controllers holding Flexible Single Master Operations (FSMO) roles, also known as operations master roles.16 These roles are critical for the proper functioning and health of the Active Directory forest and domains.

There are five FSMO roles, divided into two categories: forest-wide roles (one per forest) and domain-wide roles (one per domain).

* **Schema Master (Forest-wide):** This role is responsible for governing all changes to the Active Directory schema. The schema defines the structure and rules for all objects and attributes that can exist in the directory. There is only one Schema Master in an AD DS forest, ensuring a single, authoritative source for schema modifications.14  
* **Domain Naming Master (Forest-wide):** This role tracks object names throughout a forest to ensure their uniqueness. It is responsible for managing the addition and removal of domains and application partitions in the forest, and it tracks cross-references to objects in other directories.16  
* **PDC Emulator (Domain-wide):** The Primary Domain Controller (PDC) Emulator is a critical domain-level role. It receives preferential replication of password changes from other domain controllers in its domain and processes account lockouts. It acts as the authoritative time source for its domain, and the PDC Emulator in the forest root domain is the authoritative time source for the entire forest. It is also a preferred point of administration for services like Group Policy and Distributed File System (DFS).16  
* **RID Master (Domain-wide):** The Relative ID (RID) Master is responsible for allocating pools of RIDs to all domain controllers within its domain. This ensures that when new security principals (such as users, groups, and computers) are created, they receive a unique Security Identifier (SID) within the domain.16  
* **Infrastructure Master (Domain-wide):** This role manages object references from its domain to objects in other domains. It is responsible for updating group-to-user references when members of groups are renamed or moved across domains.16

Optimal placement of FSMO roles is crucial for minimizing administrative overhead, ensuring proper performance of AD DS, and simplifying recovery in case of a domain controller failure.16 Best practices include configuring standby operations masters for both forest-level and domain-level roles. Domain-level roles, especially the PDC Emulator, should be placed on high-performance, reliable domain controllers due to their intensive daily interaction with other network systems.16 The Infrastructure Master role requires careful placement; it should not be on a Global Catalog server unless all domain controllers in the domain also host the global catalog (and the Recycle Bin feature is enabled), to avoid inconsistent object information.16

The following table summarizes the Active Directory FSMO roles, their scope, purpose, and key placement considerations.

| FSMO Role | Scope | Purpose and Key Functions | Placement Considerations |
| :---- | :---- | :---- | :---- |
| **Schema Master** | Forest-wide (one per forest) 14 | Governs all changes to the Active Directory schema, defining object types and attributes. Ensures forest-wide consistency of directory structure. 14 | Typically placed on the first domain controller in the forest root domain. Requires careful planning due to forest-wide impact of changes. 16 |
| **Domain Naming Master** | Forest-wide (one per forest) 16 | Tracks object names across the forest to ensure uniqueness. Manages the addition and removal of domains and application partitions. 16 | Usually resides on the first domain controller in the forest root domain. 92 |
| **PDC Emulator** | Domain-specific (one per domain) 16 | Receives preferential replication of password changes, processes account lockouts, manages Group Policy updates, and acts as the authoritative time source for its domain. 16 | Should be on a high-performance, reliable domain controller due to high interaction and overhead. Crucial for daily directory operations. 16 |
| **RID Master** | Domain-specific (one per domain) 16 | Allocates pools of Relative IDs (RIDs) to all domain controllers within its domain, ensuring unique Security Identifiers (SIDs) for new security principals. 16 | Typically on the first domain controller in the domain. 92 |
| **Infrastructure Master** | Domain-specific (one per domain) 16 | Manages object references between domains. Updates group-to-user references when members are renamed or moved across domains. 16 | Should *not* be on a Global Catalog server unless *all* domain controllers are also Global Catalog servers (with Recycle Bin enabled). Improper placement can lead to inconsistent data. 16 |

### **B. Built-in Security Groups and Administrative Roles**

Active Directory security groups are fundamental to managing permissions and access control within Windows-based IT environments. Their primary purpose is to simplify administration by organizing users, devices, and resources into manageable units, enabling efficient assignment of access rights to files, applications, and systems.9 By assigning permissions to a group rather than individual users, organizations can save time, reduce errors, and maintain consistent security practices.10

As discussed previously, Active Directory groups are characterized by their scope:

* **Universal:** Used to assign permissions to resources across multiple domains in a given forest.9  
* **Global:** Can be granted permissions to resources in any trusting domain, but can only include members from their own domain. Often used as role-based groups.9  
* **Domain Local:** Manage access permissions to resources within a single domain.9

Active Directory automatically creates several built-in security groups with preconfigured rights and permissions to perform specific administrative tasks. Understanding these groups and their roles is critical for secure delegation of authority:

* **Administrators:** This group has complete and unrestricted access to the computer. If the computer is a domain controller, members have unrestricted access to the entire domain. Default members include the local Administrator account, Domain Admins, and Enterprise Admins. This group cannot be renamed, deleted, or removed, and it controls access to all domain controllers in its domain.9  
* **Domain Admins:** Authorized to administer the domain. By default, members of this global group are automatically added to the local Administrators group on all domain-joined computers, including domain controllers. They are the default owner of any object created in AD for the domain by a group member.9  
* **Enterprise Admins:** This universal (or global in mixed mode) group exists only in the root domain of an AD forest. Members are authorized to make forest-wide changes in Active Directory, such as adding child domains. This group is automatically added to the Administrators group in every domain in the forest, granting them the highest level of privilege across the entire forest.9  
* **Schema Admins:** This universal (or global in mixed mode) group also exists only in the root domain of an AD forest. Members have full administrative access to modify the Active Directory schema. This is a highly sensitive role, as schema modifications affect the entire directory.9  
* **Account Operators:** This Builtin Local group grants limited account creation privileges. Members can create and modify most user accounts, Local groups, and Global groups, and can log in locally to domain controllers. However, they cannot modify user rights or manage Administrator accounts or other administrative groups.9  
* **Backup Operators:** Members of this Builtin Local group can back up and restore all files on a computer, regardless of permissions. They can also log on to and shut down the computer. They are considered service administrators due to their ability to replace files, including OS files, on domain controllers.9  
* **Server Operators:** This Builtin Local group exists only on domain controllers. Members can administer domain controllers by performing tasks such as signing in interactively, creating and deleting network shared resources, stopping and starting services, backing up and restoring files, formatting hard drives, and shutting down the device.9  
* **Print Operators:** Members of this Builtin Local group can manage, create, share, and delete printers connected to domain controllers. They can also manage AD printer objects, sign in locally to, and shut down domain controllers.9  
* **DnsAdmins:** This Domain Local group provides members with access to network DNS information. It exists only if the DNS server role is installed on a domain controller.9  
* **DnsUpdateProxy:** This Global group allows DNS clients to perform dynamic updates on behalf of other clients, such as DHCP servers. It exists only if the DNS server role is installed on a domain controller.9  
* **Protected Users:** This Global group, introduced in Windows Server 2012 R2, provides extra protection against credential compromise during authentication processes. Members of this group cannot authenticate using NTLM, Digest Authentication, or CredSSP. Kerberos protocol does not use weaker DES or RC4 encryption types for their authentication, and their accounts cannot be delegated.9  
* **Read-only Domain Controllers (RODCs):** This Global group is composed of RODCs in the domain. RODCs contain a read-only copy of the AD DS database, enabling deployment of domain controllers in scenarios where physical security cannot be guaranteed, with unidirectional replication and credential caching features.9

Best practices for managing Active Directory groups are essential for maintaining a secure and efficient environment:

* **Principle of Least Privilege:** Grant users, computers, and services only the minimum necessary privileges to perform their tasks. This reduces the attack surface and minimizes potential damage from a compromised account.60  
* **Careful Group Nesting:** While nesting groups (e.g., adding a global group to a domain local group) can simplify access management, it should be limited to a few levels to avoid excessive and hard-to-track permissions.11  
* **Unique and Descriptive Naming:** Establish group naming standards to ensure consistency and uniqueness, making it easier to understand group purpose and membership.11  
* **Regular Auditing:** Continuously monitor and audit user accounts and security groups for unauthorized permission changes, unusual administrative account usage, and dormant accounts. Implement alerts for suspicious activities.60  
* **Establish Group Owners:** Ensure every group has at least one owner to prevent "orphaned groups" and maintain accountability for membership and permissions.11  
* **Secure Privileged Accounts:** Tightly restrict membership in highly privileged groups (e.g., Domain Admins, Enterprise Admins). Implement a privileged access management (PAM) solution and train administrators to use these accounts only when absolutely necessary.52  
* **Disable SMBv1 and Restrict NTLM:** These older protocols have known vulnerabilities; disabling them and restricting NTLM usage is a critical security measure.60

The following table provides a summary of key Active Directory built-in security groups, detailing their primary roles and key considerations for administration.

| Group Name | Scope | Primary Role/Permissions | Key Considerations |
| :---- | :---- | :---- | :---- |
| **Administrators** | Builtin Local | Complete and unrestricted access to the computer/domain. Full control over the system. 9 | Default members include Domain Admins, Enterprise Admins. Cannot be renamed/deleted. Controls all domain controllers. 9 |
| **Account Operators** | Builtin Local | Create and modify most user accounts, Local groups, and Global groups. Can log on locally to DCs. 9 | Limited privileges; cannot manage Administrator accounts or other administrative groups. Best practice is to leave empty for delegated administration. 9 |
| **Backup Operators** | Builtin Local | Back up and restore all files on a computer, regardless of permissions. Can log on and shut down the computer. 9 | Considered service administrators due to ability to replace files. 9 |
| **Domain Admins** | Global | Authorized to administer the domain. Default members of Administrators group on all domain-joined computers. 9 | Default owner of objects created in AD for the domain. Full access to domain controllers. 9 |
| **Enterprise Admins** | Universal (Native Mode) / Global (Mixed Mode) | Exists only in forest root domain. Authorized to make forest-wide changes in AD. 9 | Automatically added to Administrators group in every domain in the forest. Highest privileges, requires tight control. 9 |
| **Schema Admins** | Universal (Native Mode) / Global (Mixed Mode) | Exists only in forest root domain. Members can modify the Active Directory schema. 9 | Full administrative access to the schema. Critical service administrator account due to forest-wide impact of schema changes. 9 |
| **Server Operators** | Builtin Local | Administer domain controllers (e.g., create/delete network shares, start/stop services, format drives). 9 | Cannot be renamed/deleted. No default members. 9 |
| **Print Operators** | Builtin Local | Manage, create, share, and delete printers connected to domain controllers. Can log on locally and shut down DCs. 9 | No default members. Use with caution due to ability to load/unload device drivers. 9 |
| **DnsAdmins** | Domain Local | Members have access to network DNS information. 9 | Exists only if DNS server role is installed on a DC. 9 |
| **Protected Users** | Global | Provides extra protection against credential compromise during authentication. 9 | Members cannot use NTLM, Digest, CredSSP; Kerberos does not use weaker encryption; no delegation. 9 |
| **Read-only Domain Controllers** | Global | Composed of RODCs in the domain. Enables DC deployment where physical security is not guaranteed. 9 | Contains read-only AD DS database, unidirectional replication. 9 |

## **V. Conclusion**

Active Directory, through its meticulously designed logical and physical structures, diverse suite of services, and deep integration with core networking protocols, forms the indispensable backbone of identity and access management in Windows-based enterprise environments. Its architecture is engineered to provide centralized management, robust security, inherent scalability, and critical fault tolerance, enabling organizations to efficiently control access to resources across complex and geographically dispersed networks.

For enterprise IT professionals, a thorough understanding of Active Directory's intricate components is paramount. This includes comprehending the hierarchical organization of domains, trees, and forests, which facilitates administrative delegation and efficient data partitioning. The strategic use of Organizational Units (OUs) is vital for granular control and precise application of Group Policies, while the distinction and proper management of security groups are fundamental to implementing efficient and secure access control based on the principle of least privilege.

The reliance of Active Directory on foundational protocols like DNS for name resolution and service location, and Kerberos for secure, ticket-based authentication, underscores the interconnectedness of these systems. The ongoing deprecation of legacy protocols such as NTLM highlights a continuous evolution towards more secure and efficient authentication mechanisms. This shift necessitates a proactive approach to modernizing infrastructure and adopting current best practices.

Maintaining the security and integrity of an Active Directory environment requires continuous vigilance. Key takeaways include the critical importance of proper design and placement of FSMO roles, rigorous adherence to security best practices for group management (e.g., limiting privileged users, regular auditing), and implementing multi-layered defenses for essential services like DNS, particularly against threats like data exfiltration.

Looking ahead, the landscape of identity management continues to evolve, with a growing emphasis on hybrid identity solutions that integrate on-premises Active Directory with cloud services like Azure AD (now Microsoft Entra ID). This ongoing transition, coupled with the persistent need to address emerging threats and deprecate outdated technologies, underscores the imperative for IT professionals to continuously adapt, modernize, and secure their Active Directory infrastructure to meet the demands of future enterprise environments.

#### **Alıntılanan çalışmalar**

1. What is Active Directory? Key Components, Benefits and Use Cases \- Motadata, erişim tarihi Temmuz 22, 2025, [https://www.motadata.com/it-glossary/active-directory/](https://www.motadata.com/it-glossary/active-directory/)  
2. What is Active Directory Domain Services? \- Lepide Software, erişim tarihi Temmuz 22, 2025, [https://www.lepide.com/blog/what-is-active-directory-domain-services/](https://www.lepide.com/blog/what-is-active-directory-domain-services/)  
3. Active Directory Structure \- IS Decisions, erişim tarihi Temmuz 22, 2025, [https://www.isdecisions.com/en/glossary/active-directory-structure](https://www.isdecisions.com/en/glossary/active-directory-structure)  
4. Active Directory Logical Components | by Rios Falcon Pablo | Medium, erişim tarihi Temmuz 22, 2025, [https://medium.com/@boolunpeu/active-directory-logical-components-3eb7297a0c3b](https://medium.com/@boolunpeu/active-directory-logical-components-3eb7297a0c3b)  
5. Active Directory Essentials: Core Basics Simplified | by Jinendar Kothari | Medium, erişim tarihi Temmuz 22, 2025, [https://n1chr0x.medium.com/active-directory-essentials-core-basics-simplified-83b2a81c7f15](https://n1chr0x.medium.com/active-directory-essentials-core-basics-simplified-83b2a81c7f15)  
6. Understanding the Active Directory Logical Model | Microsoft Learn, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/understanding-the-active-directory-logical-model](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/understanding-the-active-directory-logical-model)  
7. Let us know the Structure and its Components of the Active Directory., erişim tarihi Temmuz 22, 2025, [https://teamwin.in/let-us-know-the-structure-and-its-components-of-the-active-directory/](https://teamwin.in/let-us-know-the-structure-and-its-components-of-the-active-directory/)  
8. Active Directory \- Wikipedia, erişim tarihi Temmuz 22, 2025, [https://en.wikipedia.org/wiki/Active\_Directory](https://en.wikipedia.org/wiki/Active_Directory)  
9. Active Directory security groups | Microsoft Learn, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups)  
10. Active Directory Security Groups \- Permissions, Best Practices & Tools \- Comparitech, erişim tarihi Temmuz 22, 2025, [https://www.comparitech.com/net-admin/active-directory-security-groups/](https://www.comparitech.com/net-admin/active-directory-security-groups/)  
11. Active Directory Groups: How To Manage Them Effectively \- Netwrix, erişim tarihi Temmuz 22, 2025, [https://www.netwrix.com/active\_directory\_group\_management.html](https://www.netwrix.com/active_directory_group_management.html)  
12. Microsoft Infrastructure FAQ \- AD Terminology \- UW-IT, erişim tarihi Temmuz 22, 2025, [https://uwconnect.uw.edu/it?id=kb\_article\_view\&sysparm\_article=KB0034185](https://uwconnect.uw.edu/it?id=kb_article_view&sysparm_article=KB0034185)  
13. Active Directory Domain Services (AD DS): Overview and Functions \- Varonis, erişim tarihi Temmuz 22, 2025, [https://www.varonis.com/blog/active-directory-domain-services](https://www.varonis.com/blog/active-directory-domain-services)  
14. Active Directory Partition | Server Geeks \- WordPress.com, erişim tarihi Temmuz 22, 2025, [https://servergeeks.wordpress.com/2013/04/13/active-directory-partition/](https://servergeeks.wordpress.com/2013/04/13/active-directory-partition/)  
15. What are Directory Partitions? \- Discussion Community \- IT Acumens, erişim tarihi Temmuz 22, 2025, [https://discuss.itacumens.com/index.php?topic=32333.0](https://discuss.itacumens.com/index.php?topic=32333.0)  
16. Flexible Single Master Operations roles in Windows Server ..., erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-fsmo-roles](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-fsmo-roles)  
17. DNS and Active Directory Partitions \- ITfreetraining, erişim tarihi Temmuz 22, 2025, [https://itfreetraining.com/lesson/adpartitions/](https://itfreetraining.com/lesson/adpartitions/)  
18. Naming Context \- Wikipedia, erişim tarihi Temmuz 22, 2025, [https://en.wikipedia.org/wiki/Naming\_Context](https://en.wikipedia.org/wiki/Naming_Context)  
19. Using Application Partitions for DNS \- Active Directory, Second Edition \[Book\], erişim tarihi Temmuz 22, 2025, [https://www.oreilly.com/library/view/active-directory-second/0596004664/ch06s06.html](https://www.oreilly.com/library/view/active-directory-second/0596004664/ch06s06.html)  
20. Application Directory Partition Replication \- Win32 apps | Microsoft ..., erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows/win32/ad/application-directory-partition-replication](https://learn.microsoft.com/en-us/windows/win32/ad/application-directory-partition-replication)  
21. whats difference between domain partition and application directory partition, erişim tarihi Temmuz 22, 2025, [https://community.infosecinstitute.com/discussion/109531/whats-difference-between-domain-partition-and-application-directory-partition](https://community.infosecinstitute.com/discussion/109531/whats-difference-between-domain-partition-and-application-directory-partition)  
22. Advanced AD DS Management Using Active Directory Administrative Center (Level 200), erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/adac/advanced-ad-ds-management-using-active-directory-administrative-center--level-200-](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/adac/advanced-ad-ds-management-using-active-directory-administrative-center--level-200-)  
23. Designing the Site Topology | Microsoft Learn, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/designing-the-site-topology](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/designing-the-site-topology)  
24. Active Directory Sites and Services \- An Overview, erişim tarihi Temmuz 22, 2025, [https://www.windows-active-directory.com/active-directory-sites.html](https://www.windows-active-directory.com/active-directory-sites.html)  
25. DNS and Active Directory \- Windows Active Directory, erişim tarihi Temmuz 22, 2025, [https://www.windows-active-directory.com/dns-and-active-directory.html](https://www.windows-active-directory.com/dns-and-active-directory.html)  
26. Introduction to Windows DNS – The Importance of DNS for Active Directory Services, erişim tarihi Temmuz 22, 2025, [https://www.firewall.cx/operating-systems/microsoft/windows-servers/windows-2012-dns-active-directory-importance.html](https://www.firewall.cx/operating-systems/microsoft/windows-servers/windows-2012-dns-active-directory-importance.html)  
27. Locating Active Directory domain controllers in Windows and Windows Server | Microsoft Learn, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/dc-locator](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/dc-locator)  
28. Active Directory Replication Concepts | Microsoft Learn, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/replication/active-directory-replication-concepts](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/replication/active-directory-replication-concepts)  
29. How the Active Directory Replication Model Works \- HomeWorks, erişim tarihi Temmuz 22, 2025, [https://homeworks.it/Pdf/Active%20Directory%20Replication%20Model.pdf](https://homeworks.it/Pdf/Active%20Directory%20Replication%20Model.pdf)  
30. Active Directory Certificate Services (AD CS) Overview \- Secret Double Octopus, erişim tarihi Temmuz 22, 2025, [https://doubleoctopus.com/security-wiki/identity-and-access-management/active-directory-certificate-services/](https://doubleoctopus.com/security-wiki/identity-and-access-management/active-directory-certificate-services/)  
31. Active Directory Certificate Services \- 1Kosmos, erişim tarihi Temmuz 22, 2025, [https://www.1kosmos.com/security-glossary/active-directory-certificate-services/](https://www.1kosmos.com/security-glossary/active-directory-certificate-services/)  
32. AD CS Certificate Templates: Security Best Practices \- SecureW2, erişim tarihi Temmuz 22, 2025, [https://www.securew2.com/blog/ad-cs-certificate-templates-security-best-practices](https://www.securew2.com/blog/ad-cs-certificate-templates-security-best-practices)  
33. Active Directory Certificate Services: AD CS Explanation & Configuration \- NinjaOne, erişim tarihi Temmuz 22, 2025, [https://www.ninjaone.com/blog/active-directory-certificate-services-definition-configuration/](https://www.ninjaone.com/blog/active-directory-certificate-services-definition-configuration/)  
34. What Is Active Directory Federation Services (ADFS)? \- CrowdStrike, erişim tarihi Temmuz 22, 2025, [https://www.crowdstrike.com/en-us/cybersecurity-101/identity-protection/active-directory-federation-service-adfs/](https://www.crowdstrike.com/en-us/cybersecurity-101/identity-protection/active-directory-federation-service-adfs/)  
35. What is ADFS? | Okta, erişim tarihi Temmuz 22, 2025, [https://www.okta.com/blog/2018/06/what-is-adfs/](https://www.okta.com/blog/2018/06/what-is-adfs/)  
36. Best Practices for Securing Windows Server ADFS Deployments \- WafaTech Blogs, erişim tarihi Temmuz 22, 2025, [https://wafatech.sa/blog/windows-server/windows-security/best-practices-for-securing-windows-server-adfs-deployments/](https://wafatech.sa/blog/windows-server/windows-security/best-practices-for-securing-windows-server-adfs-deployments/)  
37. Active Directory Rights Management Services Overview | Microsoft ..., erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/hh831364(v=ws.11)](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/hh831364\(v=ws.11\))  
38. Do you use AD RMS on-premises? You need to read this\! \- ENow Software, erişim tarihi Temmuz 22, 2025, [https://www.enowsoftware.com/solutions-engine/azure-active-directory-center/do-you-use-ad-rms-on-premises](https://www.enowsoftware.com/solutions-engine/azure-active-directory-center/do-you-use-ad-rms-on-premises)  
39. Mastering Active Directory Rights Management Services \- MojoAuth, erişim tarihi Temmuz 22, 2025, [https://mojoauth.com/ciam-101/active-directory-rights-management-services](https://mojoauth.com/ciam-101/active-directory-rights-management-services)  
40. What is Active Directory Lightweight Directory Services? Competitors, Complementary Techs & Usage | Sumble, erişim tarihi Temmuz 22, 2025, [https://sumble.com/tech/active-directory-lightweight-directory-services](https://sumble.com/tech/active-directory-lightweight-directory-services)  
41. Understanding AD-LDS \- BeyondScale, erişim tarihi Temmuz 22, 2025, [https://beyondscale.tech/understanding-ad-lds](https://beyondscale.tech/understanding-ad-lds)  
42. LDAP vs Active Directory \- Netwrix Blog, erişim tarihi Temmuz 22, 2025, [https://blog.netwrix.com/2024/02/19/ldap-vs-active-directory/](https://blog.netwrix.com/2024/02/19/ldap-vs-active-directory/)  
43. 10 best practices for securing Active Directory \- Tech Collective, erişim tarihi Temmuz 22, 2025, [https://techcollectivesea.com/2024/12/04/best-practices-for-securing-active-directory/](https://techcollectivesea.com/2024/12/04/best-practices-for-securing-active-directory/)  
44. Active Directory hardening checklist & (actionable) best practices \- HackTheBox, erişim tarihi Temmuz 22, 2025, [https://www.hackthebox.com/blog/active-directory-hardening-checklist-and-best-practices](https://www.hackthebox.com/blog/active-directory-hardening-checklist-and-best-practices)  
45. What is single sign-on? \- Microsoft Entra ID, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/what-is-single-sign-on](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/what-is-single-sign-on)  
46. What is AD SSO? A Comprehensive Guide to Active Directory Single ..., erişim tarihi Temmuz 22, 2025, [https://www.miniorange.com/blog/azure-ad-sso/](https://www.miniorange.com/blog/azure-ad-sso/)  
47. Authentication vs. authorization \- Microsoft identity platform, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/entra/identity-platform/authentication-vs-authorization](https://learn.microsoft.com/en-us/entra/identity-platform/authentication-vs-authorization)  
48. Configure a DNS Proxy Object \- Palo Alto Networks, erişim tarihi Temmuz 22, 2025, [https://docs.paloaltonetworks.com/pan-os/10-2/pan-os-networking-admin/dns/configure-a-dns-proxy-object](https://docs.paloaltonetworks.com/pan-os/10-2/pan-os-networking-admin/dns/configure-a-dns-proxy-object)  
49. What Is DNS Data Exfiltration? \- Akamai, erişim tarihi Temmuz 22, 2025, [https://www.akamai.com/glossary/what-is-dns-data-exfiltration](https://www.akamai.com/glossary/what-is-dns-data-exfiltration)  
50. DNS Exfiltration Attack: What It Is and How to Prevent It \- Indusface, erişim tarihi Temmuz 22, 2025, [https://www.indusface.com/learning/dns-exfiltration-attack/](https://www.indusface.com/learning/dns-exfiltration-attack/)  
51. What is DNS Protection | Common Attack Types \- Imperva, erişim tarihi Temmuz 22, 2025, [https://www.imperva.com/learn/application-security/dns-protection/](https://www.imperva.com/learn/application-security/dns-protection/)  
52. Active Directory Security Best Practices | Netwrix, erişim tarihi Temmuz 22, 2025, [https://www.netwrix.com/active-directory-best-practices.html](https://www.netwrix.com/active-directory-best-practices.html)  
53. Kerberos authentication overview in Windows Server \- Learn Microsoft, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/security/kerberos/kerberos-authentication-overview](https://learn.microsoft.com/en-us/windows-server/security/kerberos/kerberos-authentication-overview)  
54. Kerberos: Secure Authentication In Windows Active Directory \- ITU Online IT Training, erişim tarihi Temmuz 22, 2025, [https://www.ituonline.com/blogs/kerberos/](https://www.ituonline.com/blogs/kerberos/)  
55. Kerberos vs NTLM | ManageEngine ADAudit Plus, erişim tarihi Temmuz 22, 2025, [https://www.manageengine.com/products/active-directory-audit/learn/kerberos-vs-ntlm.html](https://www.manageengine.com/products/active-directory-audit/learn/kerberos-vs-ntlm.html)  
56. Understanding NTLM and Kerberos: Key Differences and Use Cases, erişim tarihi Temmuz 22, 2025, [https://blog.netwrix.com/ntlm-vs-kerberos-authentication-differences](https://blog.netwrix.com/ntlm-vs-kerberos-authentication-differences)  
57. Ticket and Authentication in Kerberos Active Directory, erişim tarihi Temmuz 22, 2025, [https://calcomsoftware.com/kerberos-tickets-and-authentication-in-active-directory/](https://calcomsoftware.com/kerberos-tickets-and-authentication-in-active-directory/)  
58. NTLM Explained: Definition, Protocols & More | CrowdStrike, erişim tarihi Temmuz 22, 2025, [https://www.crowdstrike.com/en-us/cybersecurity-101/identity-protection/windows-ntlm/](https://www.crowdstrike.com/en-us/cybersecurity-101/identity-protection/windows-ntlm/)  
59. Lifetime of Kerberos tickets \- Stack Overflow, erişim tarihi Temmuz 22, 2025, [https://stackoverflow.com/questions/14682153/lifetime-of-kerberos-tickets](https://stackoverflow.com/questions/14682153/lifetime-of-kerberos-tickets)  
60. Active Directory Security Best Practices \- Semperis, erişim tarihi Temmuz 22, 2025, [https://www.semperis.com/blog/active-directory-security/active-directory-security-best-practices-checklist/](https://www.semperis.com/blog/active-directory-security/active-directory-security-best-practices-checklist/)  
61. LDAP vs. Active Directory: A Comprehensive Guide \- Apono, erişim tarihi Temmuz 22, 2025, [https://www.apono.io/blog/ldap-vs-active-directory-a-comprehensive-guide/](https://www.apono.io/blog/ldap-vs-active-directory-a-comprehensive-guide/)  
62. NTLM Authentication: Definition, Protocol & Vulnerabilities Redlings, erişim tarihi Temmuz 22, 2025, [https://www.redlings.com/en/guide/ntlm-windows-new-technology-lan-manager](https://www.redlings.com/en/guide/ntlm-windows-new-technology-lan-manager)  
63. NTLM Vulnerabilities Review \- CalCom Software, erişim tarihi Temmuz 22, 2025, [https://calcomsoftware.com/ntlm-security-weaknesses/](https://calcomsoftware.com/ntlm-security-weaknesses/)  
64. What is NTLM & How Does NTLM Authentication Work \- Secret Double Octopus, erişim tarihi Temmuz 22, 2025, [https://doubleoctopus.com/security-wiki/protocol/nt-lan-manager/](https://doubleoctopus.com/security-wiki/protocol/nt-lan-manager/)  
65. What is a Network Trust Level Manager (NTLM)? \- Xcitium, erişim tarihi Temmuz 22, 2025, [https://www.xcitium.com/knowledge-base/ntlm/](https://www.xcitium.com/knowledge-base/ntlm/)  
66. Active Directory Hardening Series \- Part 1 – Disabling NTLMv1 | Microsoft Community Hub, erişim tarihi Temmuz 22, 2025, [https://techcommunity.microsoft.com/blog/coreinfrastructureandsecurityblog/active-directory-hardening-series---part-1-%E2%80%93-disabling-ntlmv1/3934787](https://techcommunity.microsoft.com/blog/coreinfrastructureandsecurityblog/active-directory-hardening-series---part-1-%E2%80%93-disabling-ntlmv1/3934787)  
67. Features Removed or No Longer Developed in Windows Server \- Learn Microsoft, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/get-started/removed-deprecated-features-windows-server](https://learn.microsoft.com/en-us/windows-server/get-started/removed-deprecated-features-windows-server)  
68. Deprecated features in the Windows client \- Learn Microsoft, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows/whats-new/deprecated-features](https://learn.microsoft.com/en-us/windows/whats-new/deprecated-features)  
69. NTLM overview in Windows Server | Microsoft Learn, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/security/kerberos/ntlm-overview](https://learn.microsoft.com/en-us/windows-server/security/kerberos/ntlm-overview)  
70. How SSO to on-premises resources works on Microsoft Entra joined devices | Azure Docs, erişim tarihi Temmuz 22, 2025, [https://docs.azure.cn/en-us/entra/identity/devices/device-sso-to-on-premises-resources](https://docs.azure.cn/en-us/entra/identity/devices/device-sso-to-on-premises-resources)  
71. NTLM network authentication changes \- Windows Server \- Learn Microsoft, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/new-setting-modifies-ntlm-network-authentication](https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/new-setting-modifies-ntlm-network-authentication)  
72. How to do performance tuning for NTLM authentication by using the MaxConcurrentApi setting \- Learn Microsoft, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/performance-tuning-ntlm-authentication-maxconcurrentapi](https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/performance-tuning-ntlm-authentication-maxconcurrentapi)  
73. Server Message Block \- Wikipedia, erişim tarihi Temmuz 22, 2025, [https://en.wikipedia.org/wiki/Server\_Message\_Block](https://en.wikipedia.org/wiki/Server_Message_Block)  
74. Overview of file sharing using the SMB 3 protocol in Windows Server | Microsoft Learn, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/storage/file-server/file-server-smb-overview](https://learn.microsoft.com/en-us/windows-server/storage/file-server/file-server-smb-overview)  
75. What Is SMB? Understanding Network Protocols By WireX Systems, erişim tarihi Temmuz 22, 2025, [https://wirexsystems.com/resource/protocols/smb](https://wirexsystems.com/resource/protocols/smb)  
76. SMB Protocol Explained: Understanding its Security Risks and Best Practices \- Tripwire, erişim tarihi Temmuz 22, 2025, [https://www.tripwire.com/state-of-security/smb-protocol-explained-understanding-its-security-risks-and-best-practices](https://www.tripwire.com/state-of-security/smb-protocol-explained-understanding-its-security-risks-and-best-practices)  
77. 3.3.2 Using the NTLM Protocol \[MS-NLMP\] \- Learn Microsoft, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/openspecs/windows\_protocols/ms-authsod/9a20f8ac-612a-4e0a-baab-30e922e7e1f5](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-authsod/9a20f8ac-612a-4e0a-baab-30e922e7e1f5)  
78. What's New in Windows Server 2022 | Microsoft Learn, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/get-started/whats-new-in-windows-server-2022](https://learn.microsoft.com/en-us/windows-server/get-started/whats-new-in-windows-server-2022)  
79. SMB Security Best Practices \- CISA, erişim tarihi Temmuz 22, 2025, [https://www.cisa.gov/news-events/alerts/2017/01/16/smb-security-best-practices](https://www.cisa.gov/news-events/alerts/2017/01/16/smb-security-best-practices)  
80. Join NAS to AD \- VergeOS Docs, erişim tarihi Temmuz 22, 2025, [https://docs.verge.io/product-guide/nas/nas-join-ad-domain/](https://docs.verge.io/product-guide/nas/nas-join-ad-domain/)  
81. Active Directory (AD) Authentication, erişim tarihi Temmuz 22, 2025, [https://docs.qnap.com/operating-system/qts/4.5.x/en-us/GUID-49D593C4-C212-4D90-945F-CB1103206958.html](https://docs.qnap.com/operating-system/qts/4.5.x/en-us/GUID-49D593C4-C212-4D90-945F-CB1103206958.html)  
82. Understand Kerberos in Azure NetApp Files | Microsoft Learn, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/azure/azure-netapp-files/kerberos](https://learn.microsoft.com/en-us/azure/azure-netapp-files/kerberos)  
83. Apply AD Authentication To NAS \- Quantum, erişim tarihi Temmuz 22, 2025, [https://qsupport.quantum.com/kb/flare/content/appliances/acc/docsite/NAS\_CLI/NAS\_CLI\_ADAuthentication.htm](https://qsupport.quantum.com/kb/flare/content/appliances/acc/docsite/NAS_CLI/NAS_CLI_ADAuthentication.htm)  
84. Requirements for configuring Kerberos with ONTAP NFS, erişim tarihi Temmuz 22, 2025, [https://docs.netapp.com/us-en/ontap/nfs-admin/requirements-configuring-kerberos-concept.html](https://docs.netapp.com/us-en/ontap/nfs-admin/requirements-configuring-kerberos-concept.html)  
85. Active Directory authentication and proxy \- Artica Wiki, erişim tarihi Temmuz 22, 2025, [https://wiki.articatech.com/proxy-service/authentication](https://wiki.articatech.com/proxy-service/authentication)  
86. Proxy Authentication Methods: A Comprehensive Guide for 2025 ..., erişim tarihi Temmuz 22, 2025, [https://litport.net/blog/proxy-authentication-methods-a-comprehensive-guide-57126](https://litport.net/blog/proxy-authentication-methods-a-comprehensive-guide-57126)  
87. Integrated Windows Authentication \- Wikipedia, erişim tarihi Temmuz 22, 2025, [https://en.wikipedia.org/wiki/Integrated\_Windows\_Authentication](https://en.wikipedia.org/wiki/Integrated_Windows_Authentication)  
88. Authentication Methods \- ProxySQL, erişim tarihi Temmuz 22, 2025, [https://proxysql.com/documentation/authentication-methods/](https://proxysql.com/documentation/authentication-methods/)  
89. Review the Role of the Federation Server Proxy in the Account Partner | Microsoft Learn, erişim tarihi Temmuz 22, 2025, [https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/design/review-the-role-of-the-federation-server-proxy-in-the-account-partner](https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/design/review-the-role-of-the-federation-server-proxy-in-the-account-partner)  
90. HTTP-Proxy Best Practices \- WatchGuard, erişim tarihi Temmuz 22, 2025, [http://www.watchguard.com/help/docs/help-center/en-US/content/en-US/Fireware/proxies/http/http\_proxy\_bestpractices\_c.html](http://www.watchguard.com/help/docs/help-center/en-US/content/en-US/Fireware/proxies/http/http_proxy_bestpractices_c.html)  
91. SessionLimit, erişim tarihi Temmuz 22, 2025, [https://sessionlimit.com/](https://sessionlimit.com/)  
92. Roles of the Active Directory Domain Controllers \- Dummies.com, erişim tarihi Temmuz 22, 2025, [https://www.dummies.com/article/technology/information-technology/networking/active-directory-networking/roles-of-the-active-directory-domain-controllers-187712/](https://www.dummies.com/article/technology/information-technology/networking/active-directory-networking/roles-of-the-active-directory-domain-controllers-187712/)  
93. Active Directory Security Groups Uses & Best Practices \- Netwrix Blog, erişim tarihi Temmuz 22, 2025, [https://blog.netwrix.com/2023/05/04/active-directory-security-groups/](https://blog.netwrix.com/2023/05/04/active-directory-security-groups/)
