# Data Provision Questionnaire

> **For the partner to complete.** This captures what OEAI needs to design and build a Data Source
> Module against your system. It mirrors the structure of the guide — fill in what you can; "don't
> know yet" is a fine answer. We use your answers to produce a short, **customised** integration
> guide for your system and to plan the build.
>
> Return to your OEAI technical contact, or to **[info@openeducationai.org](mailto:info@openeducationai.org)**.
> Please share credentials/connection details **separately, over a secure channel** — not in this
> document.

---

## 1 · About your system

| Field | Your answer |
|---|---|
| System / product name | |
| Vendor / company | |
| What the system is for (1–2 sentences) | |
| Is it cloud SaaS, on‑premise, or both? | |
| Technical contact (name, email) | |
| Commercial/sign‑off contact (name, email) | |
| Approx. scale (schools / pupils / rows) | |

## 2 · Data & domains

| Field | Your answer |
|---|---|
| Which data domains does your system hold? (attendance, behaviour, assessment, safeguarding, wellbeing, HR, finance, …) | |
| Which datasets/entities are **in scope** for this integration? | |
| Can you provide **atomic, record‑level** data (not just aggregates/summaries)? | ☐ Yes ☐ Partly ☐ No |
| For each in‑scope dataset, what is the **grain** (one row per …)? | |
| Do you hold **reference/lookup data** (code lists) for your coded fields? | ☐ Yes ☐ No |
| Do any fields already align to a standard (DfE CBDS, Ed‑Fi, SIF‑UK)? Which? | |

## 3 · Access method

Which mechanism(s) can you offer? (Tick all that apply — see
[Choosing a method](../guide/02-choosing-a-method.md).)

> **OEAI prefers REST.** It's straightforward to stand up — we provide a ready‑to‑use
> [OpenAPI contract](oeai-rest-api.openapi.yaml) and a step‑by‑step path for your developers.
> **Files/SFTP is accepted only as a temporary bootstrap:** it means the module must be
> redeveloped when you move to an API, so choose it only if you genuinely can't expose an API yet.

- ☐ **REST API** — base URL: ____________________  · docs/OpenAPI: ____________________
- ☐ **OData** — service root: ____________________  · `$metadata` available? ☐ Yes ☐ No
- ☐ **Data warehouse / secure share** — platform: ☐ Snowflake ☐ BigQuery ☐ Databricks ☐ Synapse ☐ Redshift ☐ Other: ______
- ☐ **SQL database (JDBC)** — engine/version: ____________________  · read replica available? ☐ Yes ☐ No
- ☐ **Files / SFTP / CSV** — transport: ☐ SFTP ☐ Cloud bucket  · format: ☐ CSV ☐ Parquet ☐ Other: ______
- ☐ Other / not sure — describe: ____________________

| Field | Your answer |
|---|---|
| If multiple methods, which is preferred and why? | |
| Is there a **sandbox / test environment** with representative data? | ☐ Yes ☐ No |
| Can you provide **sample payloads / files / DDL**? | ☐ Yes ☐ No |

## 4 · Identity (critical)

See [Identity & keys](../guide/04-identity-and-keys.md). Tick what your records carry and note
coverage.

**School / organisation**

- ☐ URN (6‑digit)  ☐ DfE Establishment Number (4‑digit)  ☐ LA Code  ☐ UKPRN  ☐ Your own school id
- Estimated coverage of URN: __________ %

**Pupil / student** (where applicable)

- ☐ UPN (13‑char)  ☐ Your/MIS pupil id  ☐ School context on each row  ☐ Former UPN  ☐ DOB + name (fallback)
- Estimated coverage of UPN: __________ %

**Staff** (where applicable)

- ☐ Your staff id  ☐ Payroll number  ☐ NI number  ☐ TRN  ☐ Legacy/previous‑system id
- ☐ Every fact record carries its own **stable record id** (e.g. `attendance_session_id`)

| Field | Your answer |
|---|---|
| Are identifiers **stable** (never change for an entity) and **non‑reused**? | ☐ Yes ☐ No |
| Anything we should know about how identity works in your system? | |

## 5 · Incremental, history & deletes

See [Incremental & historical loads](../guide/06-incremental-and-historical-loads.md).

| Field | Your answer |
|---|---|
| Do records carry a **`modified`/`updated_at`** timestamp that bumps on **every** change? | ☐ Yes ☐ Creation only ☐ No |
| Or a **version / rowversion / change feed (CDC)**? | ☐ Yes ☐ No |
| Can we filter **"changed since *T*"** server‑side? | ☐ Yes ☐ No |
| How is a **delete** represented? | ☐ Soft‑delete flag ☐ Deletions feed ☐ Hard delete (none) |
| Can we retrieve a **full export** (complete dataset)? | ☐ Yes ☐ No |
| **How much history** is available (academic years)? | |
| Does the system **purge** old data at year rollover? | ☐ Yes ☐ No |
| Can we filter by **date range** for chunked backfills? | ☐ Yes ☐ No |

## 6 · Authentication, scoping & security

See [Auth](../guide/05-authentication-and-authorisation.md) &
[Security](../guide/08-security-and-governance.md).

| Field | Your answer |
|---|---|
| Authentication method | ☐ OAuth 2.0 ☐ API key ☐ Basic ☐ mTLS ☐ Warehouse grant ☐ DB account ☐ SSH key |
| Is **read‑only** access available? | ☐ Yes ☐ No |
| Scoping model | ☐ Per‑school credentials ☐ Trust‑level + school filter ☐ Other: ______ |
| Can the **school revoke** access themselves? How? | |
| **IP allow‑listing** required? (we'll supply egress IPs) | ☐ Yes ☐ No |
| Credential **rotation** cadence/method | |
| Data **hosting region(s)** | |
| Any **sub‑processors** touching the data | |
| Relevant **certifications** (ISO 27001, Cyber Essentials, SOC 2, DPIA) | |

## 7 · API design & quality

See [API design & quality](../guide/07-api-design-and-quality.md). (Skip rows that don't apply to
your method.)

| Field | Your answer |
|---|---|
| Pagination style | ☐ Cursor/keyset ☐ Offset/`$skip` ☐ N/A |
| Published **rate limits**? `429` + `Retry-After`? | |
| Safe **concurrency** (parallel requests) | |
| **Multi‑school pattern** | ☐ One call returns all schools ☐ Per‑school calls ☐ Other: ______ |
| Schema documentation available? | ☐ OpenAPI ☐ OData `$metadata` ☐ DDL/`INFORMATION_SCHEMA` ☐ Field list ☐ None |
| **Versioning & change policy** (how breaking changes are handled) | |
| Any **caching** window on extracts? | |

## 8 · Anything else

| Field | Your answer |
|---|---|
| Known **data‑quality** issues we should expect | |
| Contractual / licensing constraints on the data | |
| Constraints, deadlines, or anything else we should know | |

---

*Thank you. With this completed, plus sandbox access and a few samples, OEAI can read your
interface, authenticate, pull sample data, and confirm the build approach quickly.*
