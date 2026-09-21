<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/assets/brand/oeai-logo-white.png">
    <img src="docs/assets/brand/oeai-logo-blue.png" alt="Open Education AI" width="320">
  </picture>
</p>

# Open Education AI (OEAI)

**Open Education AI is a sector-led, non-profit initiative that gives schools and school groups an open, standards-based way to bring their data together, in a platform they own, and turn it into insight that improves outcomes for young people.**

OEAI is incubated by [Purposeful Ventures](https://www.purposefulventures.org/) and operates under its charitable status. It is governed by a **Technical Authority** of senior data leaders from trusts, EdTech and security, and a **Sector Advisory Board**. Its roots are in Microsoft's [Open Education Analytics](https://openeducationanalytics.org/) programme, re-founded for the English school system: statutory data standards, UK MIS and EdTech products, and multi-academy trusts.

Website: [openeducationai.org](https://www.openeducationai.org/) · Contact: [info@openeducationai.org](mailto:info@openeducationai.org) · Roadmap: [ROADMAP.md](ROADMAP.md) · Known issues: [KNOWN_ISSUES.md](KNOWN_ISSUES.md)

---

## What the framework is

OEAI is a **composable data framework for education**. A trust chooses building blocks across four layers and deploys them onto its own cloud data platform:

| Layer | What it is | Examples |
|---|---|---|
| **Education Use Cases** | The outcome the work serves, and the "why" | Keeping children safe in education; tackling persistent absence; improving reading |
| **Packages** | Analytical capabilities composed from module data: reports, predictions, AI | Trust-wide MIS insight; predictive attendance; in-year assessment analysis |
| **Modules** | One integration per source system, landing data in the **OEAI standard schema** | MIS (Arbor, Bromcom, Wonde), safeguarding, HR, assessment, national open data |
| **Infrastructure** | The trust's own lakehouse platform, deployed to OEAI standards | Microsoft Fabric today; a Google-native profile is in design |

Two properties make it work. **Modules are vertical**: each owns the full raw → standardised → enriched flow for exactly one source. **Packages are horizontal**: they read the standard schema, not source systems, so a package built once works for any trust whose modules meet the schema contract. Data lands and stays in an environment the trust controls; it is never pooled centrally.

The full definition is the **[OEAI Reference Architecture](docs/reference-architecture/README.md)**: system, module, data, integration, and security and accreditation.

## Two repositories: public and private

| | **OEAI** (this repository) | **[OEAI-Private](https://github.com/Open-Education-AI/OEAI-Private)** |
|---|---|---|
| Who can see it | Everyone | OEAI members and the OEAI engineering community |
| What it holds | Assets that have reached **General Availability (GA)**, plus the framework's public documentation and standards | **Pre-GA, pilot and OEAI-owned assets**: the current versions of every module and package, the classified known-issues register, and the day-to-day engineering work |
| Licence | [Apache-2.0](LICENSE) | Confidential to OEAI and its members until an asset reaches GA |
| Activity | Updated when an asset is promoted to GA | **This is where the community is active** |

Every asset follows the seven-stage **Module Build Process**: new module request → requirements → build → development-partner review → pilot recruitment → pilot feedback → **GA release**, at which point it is published here under Apache-2.0. The Technical Authority judges when an asset is ready to move from private to public, on quality, security and testing evidence.

> **The versions in this repository are behind the private repository.** The MIS connectors here were last updated in November 2025. The private repository refreshed Arbor, Bromcom and Wonde in August 2026 and holds thirteen modules and six packages in total. See [asset versions](#assets-and-versions) below, and the [roadmap](ROADMAP.md) for what is coming to GA. To use the current versions, [join OEAI](https://www.openeducationai.org/).

## Assets and versions

Versions are read from the notebooks in this repository (`version = "YYYYMMDD.n"`) and from the changelogs in the private repository. "Superseded" means a newer build exists privately and will replace this one at its next GA release.

| Asset | Type | Version here | In the private repository | Status |
|---|---|---|---|---|
| [Wonde](modules/wonde/) | Module (MIS) | 2024 build, unversioned | 1.0.0 (23 Jul 2026), refreshed Aug 2026 | GA, superseded |
| [Arbor](modules/arbor/) | Module (MIS) | 20251105.1 | 1.0.0 (23 Jul 2026), refreshed Aug 2026 | GA, superseded |
| [Bromcom](modules/bromcom/) | Module (MIS) | 20251105.1 | 1.0.0 (23 Jul 2026), refreshed Aug 2026 | GA, superseded |
| [EES](modules/ees/) | Module (DfE national attendance) | 20251105.1 | Folded into the `opendata` module (CSP, EES, GIAS), 1.0.0 | GA, superseded |
| [MS Graph (reading progress)](modules/msgraph/) | Module | unversioned | Rebuilt as the `reading_progress` module, 1.0.0 (20 Jul 2026) | Superseded |
| [Renaissance](modules/renaissance/) | Module | unversioned | No newer version | Work in progress, not maintained |
| [Weather](modules/weather/) | Module | unversioned | No newer version | Work in progress, not maintained |
| [Police](modules/police/) | Module (UK Police open data) | unversioned | No newer version | Work in progress, not maintained |
| [MIS Insight](packages/MIS_Insight/) | Package | unversioned | Successor work is the `mis_trends` package, 1.0.0 (20 Jul 2026) | Superseded |
| [Predictive Attendance](packages/Predictive_Attendance/) | Package | unversioned | `predictive_attendance` package (Tier 2, under review) | Superseded |
| [oeai_py](oeai_py.ipynb), [oeai_logger](oeai_logger.ipynb) | Shared foundations | unversioned | Maintained in the private repository | Superseded |

The shared foundations are `%run` by every module. Each module folder has its own README describing its notebooks, secrets and limitations.

## Documentation and standards

* **[OEAI Reference Architecture](docs/reference-architecture/README.md)**: the platform-neutral definition of the framework in five parts, with its decision register and evidence.
* **[Providing data to OEAI: integration guidance for EdTech partners](docs/partner-integration/README.md)**: the standard OEAI asks vendors and MIS providers to build to, with a reference OpenAPI contract, method playbooks and a readiness questionnaire. Issued by the Technical Authority.
* **[Self-implementation guide](docs/OEAI_Self_Implementation_Guide.md)**: how a trust applies module and package updates from this repository into its own environment, with the accompanying disclaimer.
* **Standard schema**: [Silver](docs/schema_silver.dbml) and [Gold](docs/schema_gold.dbml) in DBML. Paste into [dbdiagram.io](https://dbdiagram.io) to browse. Per-asset schemas for the private assets are documented alongside them in the private repository.
* **[Education Use Case template](education-use-cases/)**: the document that defines the "why" before anything is built.
* **[Cloud infrastructure](cloud-infrastructure/)**: setup scripts for the Microsoft Fabric reference implementation.

## Governance

**Technical Authority.** Safeguards the integrity and quality of OEAI's technical architecture, sets the quality bar for new modules, owns the standard schema and the partner integration standard, and decides when an asset is ready for GA. Members are appointed for an initial twelve-month term, register their interests, and step aside from any item in which they have a conflict. Proposals reach it as Request for Comment papers, with a commenting period for the community before a decision at the next meeting.

| Member | Organisation | Role |
|---|---|---|
| Matt Woodruff | Edequity AI | Chair |
| Austen Pauleston | Cambrian IT | Vice Chair |
| Dewan Chowdhury | Co-op Academies | Member |
| Jose Diaz | Aircury | Member |
| Tasmin Langley | United Learning | Member |
| Ben Dobbs | Archway Trust | Member |
| Kevin Garrod | Zensec | Member |
| Mark Newman | RMAT | Member |
| Vik Paw | International Schools Partnership | Member |
| Mark Vanderburgh | Inspiration Trust | Member |
| Rob Wall | Danes Ed Trust | Member |

The Technical Authority is supported by an OEAI secretariat.

**Sector Advisory Board.** Advises on priorities and on advocacy with government. Chaired by Sir Mark Grundy.

**Steering Committee.** Oversees strategic and financial direction during incubation by Purposeful Ventures.

Standards change on the evidence. Proposals go to the Technical Authority as Request for Comment papers, with a commenting period for the community before a decision at the next meeting.

## Get involved

* **Join.** OEAI membership gives a trust access to the private repository, the community, roadmap voting and the current versions of every asset: [openeducationai.org](https://www.openeducationai.org/).
* **Build.** Trusts deploy the framework through an accredited delivery partner or themselves using the [self-implementation guide](docs/OEAI_Self_Implementation_Guide.md).
* **Contribute.** Modules and packages are contributed through the private repository and the Module Build Process; see [CONTRIBUTING.md](CONTRIBUTING.md). EdTech vendors start with the [partner integration guidance](docs/partner-integration/README.md).
* **Ask or report.** Open a [GitHub issue](https://github.com/Open-Education-AI/OEAI/issues) on this repository, or email [info@openeducationai.org](mailto:info@openeducationai.org). Security concerns go to the private route in [SECURITY.md](SECURITY.md).

## Repository structure

```
modules/                 GA-released data source modules (one folder per source system)
packages/                GA-released packages (multi-source analytical capabilities)
education-use-cases/     Education Use Case template
cloud-infrastructure/    Infrastructure setup scripts (Microsoft Fabric)
docs/                    Reference architecture, partner integration guidance, schema, guides
report/                  Power BI report definition for the MIS Insight MVP
reference/               Reference data used by the modules
oeai_py.ipynb            Shared OEAI Python foundation (%run by every module)
oeai_logger.ipynb        Shared logging foundation
```

## Licence

Everything in this repository is released under the [Apache License 2.0](LICENSE). Assets in the private repository are confidential to OEAI and its members until they reach GA and are published here.

Open Education AI accepts no liability for issues arising from self-implementation of these assets; see the [self-implementation guide](docs/OEAI_Self_Implementation_Guide.md) for the full disclaimer and for the assured route through a delivery partner.
