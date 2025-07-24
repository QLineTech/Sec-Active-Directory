```bash
MATCH (u:User)
RETURN u.name, u.pwdlastset order by u.pwdlastset

```