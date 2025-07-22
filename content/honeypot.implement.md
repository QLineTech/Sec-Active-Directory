# Implementing AD Honeypots: Solutions and Best Practices

## Strategic Deployment
- **Placement**: Focus on internal networks for insider threat detection.
- **Realism**: Use authentic names, permissions, and simulated activity.
- **Isolation**: Segment honeypots to prevent attacker pivoting.

## Tools and Platforms

### Open-Source Solutions
| Tool          | Focus                     | Key Features                     |
|---------------|---------------------------|----------------------------------|
| Certiception  | ADCS Honeypot             | "Vulnerable" templates, alerts   |
| HoneyAD       | AD Object Simulation      | PowerShell setup scripts         |
| Canarytokens  | Honeytokens               | Decoy data for access detection  |

### Commercial Platforms
| Platform       | Specialization            | AD Capabilities                  |
|----------------|---------------------------|----------------------------------|
| Rapid7 InsightIDR | Deception & XDR       | Honeypots, honey users, etc.     |
| Acalvio ShadowPlex| AI-powered AD Protection | Automated decoy placement        |

## Integration with Security Operations
- **SIEM/SOAR**: Centralizes alerts and automates responses.
- **Forensics**: Sysmon enhances endpoint data collection.
- **Automation**: Scales deployment and maintains realism.

