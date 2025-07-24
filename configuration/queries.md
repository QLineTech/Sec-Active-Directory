```bash
MATCH (u:User)
RETURN u.name, u.pwdlastset order by u.pwdlastset

```

 WHERE u.hasspn=true AND u.pwdlastset < (datetime().epochseconds - (1825 * 86400)) AND NOT u.pwdlastset IN [-1.0, 0.0]