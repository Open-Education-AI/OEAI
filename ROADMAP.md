# Roadmap

The community-facing view of the OEAI modules and packages: what is available, what is in build, and what the community has asked for. It mirrors the OEAI roadmap board maintained by the OEAI team and is updated whenever an asset changes stage.

**How an asset moves.** Every asset follows the seven-stage Module Build Process: new module request → requirements → build → development-partner review → pilot recruitment → pilot feedback → **GA release**, at which point it is published in this repository under Apache-2.0. Until then it lives in the [private repository](https://github.com/Open-Education-AI/OEAI-Private), available to OEAI members.

**Who builds it.** *OEAI-commissioned* assets are built by partners OEAI commissions. *Community-led* assets are built with a lead development trust that owns the use case. *Partner-led* assets are built by the EdTech vendor to the [partner integration standard](docs/partner-integration/README.md).

Want something added, or want to be a lead or test trust for an item below? Raise a [module request](https://github.com/Open-Education-AI/OEAI/issues/new?template=module-request.md) or email [info@openeducationai.org](mailto:info@openeducationai.org).

## Published in this repository

The GA-released assets. Newer builds of several exist in the private repository and replace these at their next GA release; see [asset versions](README.md#assets-and-versions).

| Asset | Type | Category | What it does |
|---|---|---|---|
| Core OEAI classes | Core architecture | OEAI-commissioned | The shared `oeai_py` and `oeai_logger` foundations every module and package imports: configuration, Key Vault secrets, Bronze/Silver/Gold read and write helpers, standard logging |
| Datalake deployment pattern | Core architecture | OEAI-commissioned | Provisions the trust-owned data lake with the layered Bronze/Silver/Gold flow, canonical schema and classifications; Infrastructure-as-Code for Microsoft Fabric today |
| Module and package development standards | Core architecture | OEAI-commissioned | Module and package anatomy, coding standards, Silver and Gold DBML schemas, contribution and review model, intake-to-GA lifecycle |
| MVP Power BI report | Core architecture | OEAI-commissioned | Reference consumption layer over the Gold schema: semantic model and sample report for trust-wide analysis |
| Wonde | Module | OEAI-commissioned | Foundational MIS connector via the Wonde aggregator API across Bromcom, SIMS, Arbor, iSAMS and others; the most common ingestion path |
| Arbor | Module | OEAI-commissioned | Foundational MIS connector from the Arbor data warehouse |
| Bromcom | Module | OEAI-commissioned | Foundational MIS connector from the Bromcom hosted SQL replica or OData endpoint |
| DfE Explore Education Statistics (EES) | Module | OEAI-commissioned | National statistical publications for benchmarking trust performance against national and local-authority figures |
| M365 Graph (reading progress) | Module | OEAI-commissioned | Microsoft Reading Progress fluency metrics via the Microsoft Graph education API |
| Weather API | Module | OEAI-commissioned | Historical and forecast weather by school postcode as a contextual feature for attendance and behaviour modelling |
| Police API | Module | OEAI-commissioned | Crime and anti-social-behaviour incidents from data.police.uk by home postcode and catchment, as a contextual safeguarding feature |
| MIS Insight | Insight package | OEAI-commissioned | Trust-wide attendance, exclusions and conduct analysis behind the MVP report |
| Predictive Attendance | Insight package | Community-led (Dixons) | Predicts each pupil's session-level attendance for the coming term to prioritise intervention |

## Available to members in the private repository

Delivered assets at "Deployed – Private" on the roadmap board. GA publication follows Technical Authority sign-off.

| Asset | Type | Category | Lead trust | What it does |
|---|---|---|---|---|
| Open Data | Module | OEAI-commissioned | | National DfE open data (CSP, EES, GIAS) landed as reference tables for benchmarking and context |
| CPOMS Insight | Module | OEAI-commissioned | | Safeguarding incidents, categories, actions and linked pupils from CPOMS analytics into the Gold safeguarding schema (v2, target Sep 2026) |
| iSAMS | Module | | | Foundational MIS source for independent and international schools |
| Smartgrade | Module | | | Marking, grade-boundary calibration and standardised assessment outcomes |
| IMP ICFP | Module | | | Curriculum-model and financial-planning data so curriculum design can be joined with MIS and finance |
| Microsoft Reflect | Module | | | Emotional check-in responses from Teams via the Microsoft Graph API |
| SOCS | Module | | | Clubs, fixtures and registers to measure co-curricular participation |
| SAMpeople | Module | | | Contracts, pay, allowances and absence, plus safer-recruitment context |
| YouHQ | Module | | | Pupil wellbeing survey responses and check-ins |
| MIS Trends | Insight package | OEAI-commissioned | | Attendance and behaviour trend tables at student, school and trust level, multi-year with weekly grain |
| Pupil Premium Opportunity | Insight package | OEAI-commissioned | | Identifies pupils eligible for, or at risk of missing, Pupil Premium impact; tracks the eligible cohort against peers |
| Predictive Absence | Insight package | Community-led | Inspiration | Pupil-level risk of persistent and severe absence as a ranked watch-list for pastoral teams |
| Primary Interim Assessment | Insight package | Community-led | Shireland | Termly KS1 and KS2 interim outcomes against expected standards and FFT targets, by cohort, PP and SEND |
| Secondary Interim Assessment | Insight package | Community-led | Shireland | KS3 and KS4 interim assessment against target grades, with residuals against FFT estimates |
| Reading Progress | Insight package | Community-led | Discovery | Classroom reading fluency joined with standardised reading tests |
| Predictive Contextual Safeguarding | Insight package | Community-led | Greenwood | Restricted pilot research combining safeguarding incidents, wellbeing signals and external context. Disabled by default; not for live use without ethics approval, expert configuration, user training and strict information governance |

## In development

### Build phase

| Asset | Type | Category | Lead trust | Target | What it does |
|---|---|---|---|---|---|
| Enrichment package | Insight package | OEAI-commissioned | United Learning, Inspiration, Dixons | Oct 2026 | Patterns of access to an enrichment entitlement across all pupils, against DfE enrichment expectations and, in a later version, a trust's own character charter. Uses Arbor and Bromcom trips and visits data |
| Maths Performance Dashboard | Insight package | Community-led | United Learning / Maths Excellence Fund | Sep 2026 | Patterns of secondary maths performance over time; phase 2 predicts pupils at risk of underperforming at GCSE. Uses Arbor and Smartgrade; Edurio and Sparx to follow |
| StepLab | Module | Community-led | Ted Wragg Trust | | Instructional coaching, observation and CPD activity to measure staff development |
| The Engagement Platform (TEP) | Module | | | | Staff, pupil and parent survey responses for wellbeing, culture and engagement analysis |

### Requirements phase

| Asset | Type | Category | Lead trust | Target | What it does |
|---|---|---|---|---|---|
| FFT | Module | OEAI-commissioned | Lead trust needed | Sep 2026 | FFT Aspire estimates, benchmarks and attendance-tracker data for comparison with national and similar-school groupings |
| GL Assessment | Module | Community-led | United Learning | | Standardised assessment results (CAT4, PT Series, NGRT, NGST) |
| Edurio | Module | Community-led | Ted Wragg | | Staff, pupil and parent survey data for culture and engagement analysis |
| Sparx Learning | Module | Community-led | Ted Wragg Trust | | Pupil practice data across maths, reading and science; feeds the Maths Performance Dashboard |
| Civica HR | Module | Partner-led | Seeking test trusts | | Staff contracts, absence, turnover and payroll dimensions |
| Tes MyConcern | Module | | | | Safeguarding incidents, categories, chronologies and actions |

## Community interest

Sources the community has asked for and that are not yet in requirements. Register interest, or offer to lead, through a [module request](https://github.com/Open-Education-AI/OEAI/issues/new?template=module-request.md).

| Source | Domain | What it would provide |
|---|---|---|
| Access Finance | Finance | General ledger, AP/AR and budget data for trust-wide financial reporting |
| IRIS Financials | Finance | GL, AP/AR, budget and management accounts (formerly PS Financials) |
| Iplicit | Finance | General ledger, AP/AR and management accounts from cloud finance |
| Tes Class Charts | Behaviour and classroom management | Behaviour points, seating plans, detentions and homework |
| Tide Education | Intervention | Teacher-created interventions, targets and progress notes joined with attendance, behaviour and assessment |
| Maths.co.uk | Curriculum and pupil practice | Primary activity, assignment completion and mastery data (White Rose Maths) |
| The Key – GovernorHub | Governance and compliance | Governor declarations of interest, training and attendance records |
| DfE Good Estate Management for Schools (GEMS) | Estates and compliance | Estates, condition and funding context |
| iAM Compliant | Compliance | Compliance checks, incidents, and health-and-safety and estates records |
| Autodesk Revit | Estates | Building Information Modelling data so estates KPIs sit alongside operational data |

## Platform and standards

| Item | What | Status |
|---|---|---|
| Google-native reference implementation | A `gcp-native` implementation profile of the [reference architecture](docs/reference-architecture/README.md), with first assets on BigQuery | In design with a Google-stack trust |
| Partner enablement packs 2 and 3 | "How to build an OEAI module" and a synthetic test stub for partners | Planned; pack 1 is [published](docs/partner-integration/README.md) |
| Schema evolution process | Additive-first changes, deprecation with notice, versioned releases with long-term-support lines | Request for Comment in preparation for the Technical Authority |
| Partner accreditation | Widening who OEAI can commission to build modules | Criteria being defined by the Technical Authority |
| Documentation site | A browsable, auto-generated documentation site over this repository | Under evaluation |

*Updated 21 September 2026 from the OEAI roadmap board.*
