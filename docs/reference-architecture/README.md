# OEAI Reference Architecture

**Baseline 6 September 2026** · Published to the public OEAI repository on 21 September 2026 following Technical Authority review. The controlled source is [docs/reference-architecture in OEAI-Private](https://github.com/Open-Education-AI/OEAI-Private/tree/main/docs/reference-architecture); this copy is re-published at each baseline.

This five-part reference explains how OEAI integrates education data into a trust-controlled platform, how modules and analytical packages fit together, and the technical and governance conditions required for their use. It is written for trust data/IT leads, integration vendors, deployment operators, contributors and the Technical Authority.

The architecture is suitable for implementation planning and technical handover. It distinguishes the inspected implementation, requirements to be met at deployment, and decisions that still need an accountable owner’s approval. It does not certify a deployment, approve a partner, grant a licence or authorise processing of pupil data.

## Read the five parts

| Part | Document | Purpose |
|---|---|---|
| 1 | [System Architecture](01-system-architecture.md) | Components, trust deployment, dependencies, environments, releases and operational acceptance |
| 2 | [Module Architecture](02-module-architecture.md) | Contribution units, profile requirements, naming, review, licensing status and lifecycle |
| 3 | [Data Architecture](03-data-architecture.md) | Layer contracts, keys, physical storage, publication, classification, retention and validation |
| 4 | [Integration Architecture](04-integration-architecture.md) | Source methods, MIS patterns, identity, change handling and vendor engagement |
| 5 | [Security and Accreditation](05-security-and-accreditation.md) | Identity, access, data protection, proposed partner assurance and mandatory safeguarding controls |

[References](REFERENCES.md) identify the inspected repository revision, current technical/legal guidance and the thesis. [Decisions](DECISIONS.md) identify approval-dependent matters and their effect on deployment. These companion documents are part of the reference, not optional reading for an operator.

Markdown is the controlled source. An offline HTML edition and Word reading copies are held with the source in the private repository.

## Implementation baseline and document control

The five-part architecture was merged into [OEAI-Private in PR 4](https://github.com/Open-Education-AI/OEAI-Private/pull/4) on 29 July 2026. This baseline incorporates the repository conventions inspected at commit `78f382d7691b264d67e6e77e81f8d806bcda62e1` and the separately prepared F1 handover dated 6 September 2026. Inclusion of F1 here is not a claim that those assets are already merged or deployed.

The reference architecture is platform-neutral. Microsoft Fabric/Spark is the current concrete profile; other profiles must document and validate their own storage, identity, orchestration and serving contracts. “Must” identifies a requirement for a conforming use; it does not claim every historical module or tenant already implements it. For specific table/feature behaviour, read the asset README, DBML and validation record together.

Markdown is the editable source of truth. Diagrams use Mermaid. Generated reading copies must be rebuilt from this same source and carry the same baseline date. Update related chapters, diagrams, references and deployment impact in the same reviewed change. Do not silently turn a proposed policy into an approved standard.

## Deployment acceptance

Before use, the trust’s accountable owner must accept the scope, permissions, source completeness, dependency schedule, schemas, serving route, retention, recovery, support and validation evidence. Use [F1 Operations](https://github.com/Open-Education-AI/OEAI-Private/blob/main/docs/f1/OPERATIONS.md) and the individual package runbooks for the handover assets. Passing repository or synthetic tests does not complete target-workspace acceptance.

> [!WARNING]
> **Contextual Safeguarding is pilot research software, disabled by default. Under no circumstances may it be used in live operation without explicit ethics approval, expert guidance on configuration, training for every user and strict information governance.** Explicit category coding and separate model approval are mandatory. Read [safeguarding governance](https://github.com/Open-Education-AI/OEAI-Private/blob/main/packages/contextual_safeguarding/GOVERNANCE.md) and [Matthew Woodruff’s thesis](https://github.com/Open-Education-AI/OEAI-Private/blob/main/packages/contextual_safeguarding/REFERENCES.md) for work progressed beyond the pilot.
