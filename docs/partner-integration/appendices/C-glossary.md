# Appendix C · Glossary

Terms used in this guide, for readers new to UK education data or to OEAI's vocabulary.

## OEAI & platform terms

| Term | Meaning |
|---|---|
| **OEAI** | Open Education AI — the open framework and standard for education data, governed by its Technical Authority. |
| **OEAI DataLake Builder** | The trust‑hosted deployment model — runs in the trust's own cloud tenant; Gold tables are a published interface the trust builds on. |
| **Managed service** | The alternative deployment model — OEAI operated on the trust's behalf by an approved delivery partner; schemas are internal implementation detail. |
| **Data Source Module** ("module") | A self‑contained pipeline that ingests **one** source system and standardises it. Your system gets one module. |
| **Package** | A higher‑level capability (e.g. Predictive Attendance) built **on top of** one or more modules. |
| **Bronze / Silver / Gold** | The medallion architecture layers: raw‑as‑received → standardised/canonical → enriched/analytics‑ready. |
| **Medallion architecture** | The Bronze→Silver→Gold layering pattern. |
| **Canonical schema** | OEAI's standard set of `dim_*`/`fact_*` tables your data is mapped into. |
| **Dimension / Fact** (`dim_*` / `fact_*`) | Dimensions = entities (schools, pupils, staff); facts = events/results that reference them. |
| **Surrogate key** (`…key`) | An OEAI‑generated join key (`studentkey`, `organisationkey`). |
| **Technical Authority (TA)** | The OEAI function that owns the canonical schema and approves new tables/fields. |
| **Development partner** | The first trust to deploy and review a new module. |

## Data‑engineering terms

| Term | Meaning |
|---|---|
| **Atomic data** | Lowest‑grain records — individual events/states — as opposed to aggregates/summaries. |
| **Grain** | What one row represents (e.g. "one pupil, one session, one date"). |
| **Incremental / delta load** | Ingesting only records changed since the last run. |
| **Full load** | Ingesting the complete dataset each run. |
| **Watermark** | The "changed‑since" marker OEAI stores per school/entity to drive incremental loads. |
| **CDC (Change Data Capture)** | A feed of inserts/updates/deletes since a cursor. |
| **Soft delete / tombstone** | Marking a record deleted (vs removing it), so downstream systems can sync the deletion. |
| **Backfill** | A one‑off load of historical data. |
| **Rebase / replay / reprocess** | Re‑deriving Silver/Gold from retained Bronze, e.g. after a logic change. |
| **Delta Lake / Parquet** | The storage formats OEAI uses (Delta for Silver, Parquet for Gold). |
| **Idempotent** | Re‑running the same request yields the same result (safe to retry). |
| **OData** | A standardised REST query protocol (`$filter`, `$select`, `$metadata`). |
| **Delta Sharing** | An open protocol for sharing Databricks/Delta data read‑only with external recipients. |

## UK education identifiers & standards

| Term | Meaning |
|---|---|
| **URN** | Unique Reference Number — DfE's primary 6‑digit school identifier. |
| **DfE Establishment Number** | 4‑digit establishment number (unique within an LA). |
| **LA Code** | 3‑digit Local Authority code. |
| **UKPRN** | UK Provider Reference Number — 8‑digit provider id (esp. post‑16/FE). |
| **UPN** | Unique Pupil Number — 13‑character DfE pupil id that follows a pupil across schools. |
| **TRN** | Teacher Reference Number — national identifier for qualified teachers. |
| **MIS** | Management Information System — a school's core record system (e.g. SIMS, Arbor, Bromcom, iSAMS). |
| **MAT / trust** | Multi‑Academy Trust — a group of schools; OEAI's customer unit. |
| **DfE** | Department for Education. |
| **CBDS** | Common Basic Data Set — DfE's standard data definitions (incl. census). |
| **School Workforce Census (SWC)** | DfE's statutory staff data collection. |
| **Ed‑Fi** | An international education data standard/data model. |
| **SIF‑UK** | Systems Interoperability Framework (UK) — an education data exchange standard. |
| **SEND** | Special Educational Needs and Disabilities. |
| **Academic year** | England: 1 September – 31 August (the default boundary OEAI derives). |
