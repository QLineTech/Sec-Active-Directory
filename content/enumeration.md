# OSINT Techniques for Active Directory

## Overview of OSINT in Active Directory

OSINT (Open Source Intelligence) techniques are crucial for gathering information about an organization's Active Directory (AD) environment without directly interacting with the target systems. These techniques can be broadly categorized into **active** and **passive** methods.

---

## Active vs Passive OSINT Techniques

| **Type**      | **Description**                                                                 | **Examples**                              | **Risk Level**       |
|---------------|---------------------------------------------------------------------------------|-------------------------------------------|----------------------|
| **Passive**   | Involves collecting data without directly interacting with the target systems.  | Social media analysis, public records     | Low (less detectable)|
| **Active**    | Involves direct interaction with the target systems or networks.               | Port scanning, querying AD directly       | High (easily detectable) |

---

## Common OSINT Techniques for Active Directory

### Passive Techniques
- **Social Media Mining**: Extracting employee information, roles, and potential AD usernames from platforms like LinkedIn or Twitter.
- **Public Records**: Using WHOIS data, company websites, or job postings to identify AD structure or key personnel.
- **Leaked Credentials**: Searching for exposed credentials in data breaches or paste sites that might relate to the AD environment.

### Active Techniques
- **DNS Enumeration**: Querying DNS records to identify domain controllers or related AD infrastructure.
- **Network Scanning**: Using tools like Nmap to detect open ports and services that might indicate AD presence.
- **AD Querying**: Attempting to gather information by directly querying the AD through tools like BloodHound (if access is gained).

---

## Workflow of OSINT for Active Directory

```mermaid
graph TD
    A[Start OSINT] --> B[Passive Data Collection]
    B --> C[Analyze Public Information]
    C --> D[Identify Key Personnel & Domains]
    D --> E[Active Enumeration (if necessary)]
    E --> F[Map AD Infrastructure]
    F --> G[Report Findings]
```

---

## Key Considerations
- **Stealth**: Prioritize passive techniques to minimize detection risks.
- **Legal/Ethical Boundaries**: Ensure compliance with laws and ethical guidelines when conducting OSINT.
- **Tooling**: Use specialized tools like Maltego, SpiderFoot, or theHarvester for efficient data collection.

By blending passive and active techniques, security professionals can build a comprehensive picture of an Active Directory environment while balancing risk and reward.

// footprinting

// enumeration

// techniques index
// ...