# Architecture decisions and deployment dependencies

**Baseline 6 September 2026**

This register distinguishes documented technical conventions from matters requiring formal policy adoption or local deployment approval. It does not assign approval to an individual who has not given it. The responsible roles below identify who must resolve each matter and record the result.

| Matter | Current position | Responsible role | Required decision and effect |
|---|---|---|---|
| Private asset use and contributor rights | Repository README reserves rights; ADR-0006 remains Proposed | OEAI rights owner with legal advice as needed | Confirm community usage terms and contribution rights before any use or release depending on them |
| Organisation-wide classification and retention policy | Four handling levels are a reference baseline; retention is controller-specific | Controller/DPO and Technical Authority for an OEAI standard | Map classifications, approve periods and cover models, logs, exports and recovery copies before real-data processing |
| Accredited Partner scheme | Assurance controls are proposed; no accreditation award is asserted | Technical Authority and programme owner | Approve criteria, evidence, assessors, renewal, remediation and suspension before presenting a partner as accredited under this scheme |
| Module validation shape | Fabric profile calls for five notebooks; current modules often use four and shared utilities | Profile owner and code owners | Document meaningful validation and any approved exception; resolve profile/estate divergence without empty compliance files |
| Non-production and serving design | Baseline principles are documented; tenant-specific design is required | Trust platform owner and deployment architect | Approve environment isolation, runtime identity, Parquet/Delta serving route, permission tests and capacity before deployment |
| Canonical schema and key evolution | Concrete per-table schemas vary; existing key semantics must be preserved | Technical Authority/schema owners | Approve changes in types, key semantics or canonical meaning with a migration and reconciliation plan |
| Contextual Safeguarding use | Disabled by default; no operational or ethics approval supplied | Ethics body, safeguarding lead, configuration experts and IG owner | Explicit category coding, current ethics approval, expert sign-off, training for every user and strict IG are mandatory; approve the exact model before scoring |
| Google-native implementation | Reserved profile, not a verified implementation | Profile owner and Technical Authority | Define and validate a concrete profile before claiming support |

Technical document review can proceed while decisions remain open. Each unresolved item blocks the activity that depends on it; it does not authorise an assumption, exemption or silent default. Record the decision reference, owner, date, scope, expiry/review date and affected version in the controlled governance system. Public repository documentation should link only to an approved non-sensitive record or reference identifier.

A repository merge demonstrates a code/document review event. It does not, by itself, ratify organisation-wide policy or approve a trust’s deployment. The [security chapter](05-security-and-accreditation.md) and [package governance](https://github.com/Open-Education-AI/OEAI-Private/blob/main/packages/contextual_safeguarding/GOVERNANCE.md) specify the controls that must still be met.
