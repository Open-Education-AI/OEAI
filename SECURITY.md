# Security policy

## Reporting a vulnerability

Please report security concerns **privately**. Do not open a public issue containing exploit details.

* Use [GitHub private vulnerability reporting](https://github.com/Open-Education-AI/OEAI/security/advisories/new) on this repository, or
* Email [info@openeducationai.org](mailto:info@openeducationai.org) with "Security" in the subject line.

You will receive an acknowledgement, and the report will be triaged by the code owners with the Technical Authority's security members.

## What must never be committed

* Credentials of any kind: API keys, tokens, connection strings, passwords, certificates, `.env` files. Secrets belong in a key vault and are referenced by name only.
* Customer, trust or school names in code, configuration, comments or notebook cells.
* Personal data about pupils, staff or parents, including in notebook outputs, sample data or test fixtures.
* Internal infrastructure details: subscription IDs, tenant IDs, workspace GUIDs, internal addresses.

CI runs a secret scan and notebook-output checks on every pull request. A green build does not replace the manual checklist in the pull request template.

## If something sensitive is committed

1. Rotate or revoke the credential immediately. For personal data, notify OEAI the same day; this may be a reportable breach.
2. Do not just delete the file in a later commit; the data remains in history. The commit must be purged from history and collaborators re-cloned.
3. Report it to the code owners the same day.
