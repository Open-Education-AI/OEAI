# Roadmap

The community-facing view of where OEAI modules and packages are heading. It is the summary the community can plan around; detailed status lives in the private repository and the OEAI readiness tracker.

Every asset moves through the seven-stage **Module Build Process**:

| Stage | Name | Where the asset lives |
|---|---|---|
| 1 | New Module Request | Request raised with OEAI |
| 2 | Requirements Gathering | OEAI and the requesting trusts |
| 3 | Technical Design and Build | Contributor's environment, then the private repository |
| 4 | Development Partner Review | Private repository |
| 5 | Pilot Recruitment and Onboarding | Private repository; one to two pilot trusts |
| 6 | Pilot Feedback and Redevelopment | Private repository |
| 7 | **GA Release and Publication** | **This repository**, under Apache-2.0, after Technical Authority sign-off |

## Published here (GA)

| Asset | Type | Note |
|---|---|---|
| Wonde, Arbor, Bromcom | MIS modules | Newer builds exist in the private repository; next GA release replaces these |
| EES | National attendance benchmarking | Being replaced by the broader `opendata` module |
| MS Graph reading progress, Renaissance, Weather, Police | Modules | Early builds; see [asset versions](README.md#assets-and-versions) |
| MIS Insight, Predictive Attendance | Packages | Early builds; successors in the private repository |

## In the private repository (members)

Thirteen modules and six packages are available to OEAI members now. Each README in the private repository carries a **Status** row showing its current stage.

| Asset | Type | Domain | Current stage |
|---|---|---|---|
| Wonde | Module | Foundational MIS | GA (refreshed build awaiting re-publication) |
| Arbor | Module | Foundational MIS | GA (refreshed build awaiting re-publication) |
| Bromcom | Module | Foundational MIS | GA (refreshed build awaiting re-publication) |
| iSAMS | Module | Foundational MIS (independent and international schools) | 4, Development Partner Review |
| Open Data | Module | DfE national open data: CSP, EES, GIAS | 4, Development Partner Review |
| Smartgrade | Module | Standardised assessment analytics | 4, Development Partner Review |
| IMP | Module | Curriculum and financial planning | 4, Development Partner Review |
| Reading Progress | Module | Microsoft Reading Progress via Graph | 4, Development Partner Review |
| Reflect | Module | Microsoft Reflect wellbeing check-ins | 4, Development Partner Review |
| SOCS | Module | Co-curricular: clubs, fixtures, registers | 4, Development Partner Review |
| SAMpeople | Module | Staff and HR | 4, Development Partner Review |
| youHQ | Module | Student wellbeing | 4, Development Partner Review |
| CPOMS Insight | Module | Safeguarding export ingestion (Tier 2 review) | Delivered to the private repository; stage under review |
| MIS Trends | Package | Attendance and behaviour trends at student, school and trust level | 4, Development Partner Review |
| Interim Assessment | Package | Primary/EYFS, KS4 and KS5 assessment reporting | Delivered to the private repository; stage under review |
| Predictive Attendance | Package | School-day attendance prediction (Tier 2) | Delivered to the private repository; stage under review |
| Predictive Absence | Package | Daily and backfill absence prediction (Tier 2) | Delivered to the private repository; stage under review |
| Pupil Premium Opportunity | Package | Registration investigation and funding scenarios (Tier 2) | Delivered to the private repository; stage under review |
| Contextual Safeguarding | Package | Governed pilot research, disabled by default (Tier 2) | Restricted pilot; not for live use without ethics approval |

## Next

| Item | What | Status |
|---|---|---|
| Google-native reference implementation | A `gcp-native` implementation profile of the reference architecture, with first assets on BigQuery | In design with a Google-stack trust |
| Partner enablement packs 2 and 3 | "How to build an OEAI module" and a synthetic test stub for partners | Planned; pack 1 is [published](docs/partner-integration/README.md) |
| Schema evolution process | Additive-first changes, deprecation with notice, versioned releases with long-term-support lines | Request for Comment in preparation for the Technical Authority |
| Partner accreditation | Widening who OEAI can commission to build modules | Criteria being defined by the Technical Authority |
| Documentation site | A browsable, auto-generated documentation site over this repository | Under evaluation |

## Community interest

Sources the community has asked for, not yet in build. Raise a [module request](https://github.com/Open-Education-AI/OEAI/issues/new?template=module-request.md) to add to this list or to register interest in an existing item.

| Source | Domain |
|---|---|
| GL Assessment | Standardised assessment |
| StepLab | Professional development |
| TES Safeguarding | Safeguarding |
| Governor Hub | Governance |
| My New Term | Recruitment |

*Updated 21 September 2026.*
