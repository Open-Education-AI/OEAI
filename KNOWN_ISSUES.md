# Known issues

OEAI is custodian of production data-engineering assets running across multi-academy trusts. No non-trivial software is free of defects, and the safe position for a custodian is a transparent, owned register of known issues rather than defects discovered by third parties.

## Where the register lives

The **classified known-issues register** is maintained in the private repository, [OEAI-Private](https://github.com/Open-Education-AI/OEAI-Private), and is visible to OEAI members. It covers every asset, including the current versions of the modules published here, and records for each item whether it is a confirmed defect, an intentional domain rule, a false positive from static analysis, or already tracked in an earlier audit. Confirmed defects carry a severity and an agreed remediation route.

It lives there, rather than here, because the private repository holds the current version of every asset and the register is only meaningful against the code it describes.

## What this means for the assets in this repository

* The builds published here are **behind** the private repository. The MIS connectors (Wonde, Arbor, Bromcom) were last updated here in November 2025 and were rewritten in the private repository in August 2026. Some issues recorded against the public builds are already fixed privately and will close here at the next GA release.
* An independent external code review of both repositories was completed in September 2026. Its findings have been triaged and are being worked through in the private repository under Technical Authority oversight, with the fixes required before further GA releases identified.
* If you are running assets from this repository, read the [self-implementation guide](docs/OEAI_Self_Implementation_Guide.md) and consider membership for access to the current builds and the register.

## Reporting an issue

* **A defect in a public asset:** open a [bug report](https://github.com/Open-Education-AI/OEAI/issues/new?template=bug-report.md) on this repository. Never include real pupil or staff data, credentials, or school names.
* **A security concern:** do not open a public issue. Follow [SECURITY.md](SECURITY.md).
* **Members:** raise it in the private repository against the current version.
