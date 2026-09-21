# Providing Data to OEAI — Integration Guidance for EdTech Partners

> **Issued by the Technical Authority · Open Education AI**
> **Partner Enablement · Pack 1 of 3 — Readiness**
> Version 1.0 · Status: **published for partner use and feedback; formal adoption by the Technical Authority is recorded in the [changelog](CHANGELOG.md)**

> **Audience:** engineering and product teams at EdTech vendors, MIS providers, and any system that
> holds education data and wants it to flow into an **OEAI Data Source Module**.
>
> **Purpose:** to set out, in detail, how to design the *right* data‑provision mechanism for your
> stack — a REST API, OData feed, data‑warehouse share, SQL database, or a file export — so that
> Open Education AI can build a high‑quality, low‑maintenance module against it.

---

## From the Chair of the Technical Authority

We have spent a long time telling the sector that education data should be open, portable and easy
to get out of the systems that hold it. That argument only carries weight if we are precise about
what "easy to get out" actually means — and if we say it the same way to every partner, every time.

This document is that precision. It is the standard OEAI asks EdTech partners to build to. It is
deliberately opinionated: it names the mechanism we prefer, the grain we need, the identifiers that
make data joinable, and the change semantics that keep it trustworthy. Where we have a preference we
say so, and we say why.

It is also deliberately generous. We have done the design work up front — including a reference API
contract your developers can generate server stubs from — because the point is not to set an exam.
The point is to make a good integration the path of least resistance, so that a school's data works
for the school.

If you are a partner reading this: nothing here is a surprise, and none of it is proprietary. It is
ordinary good data engineering, written down, with the education‑specific parts — URN, UPN, academic
years, safeguarding — made explicit. If something in it is wrong, impractical, or missing for your
system, tell us. The Technical Authority owns this document and will change it on the evidence.

**Matthew Woodruff**
*Chair, Technical Authority — Open Education AI*

---

## Why this exists

OEAI integrates source systems through **Data Source Modules** — self‑contained pipelines that
ingest data from a single source system and standardise it into a common analytics model (the
*Bronze → Silver → Gold* medallion architecture). A module is only as good as the data interface it
is built on. The single biggest factor in how fast, cheap and reliable a module is — and how much
value schools and trusts get from it — is **how the source exposes its data**.

Modules have now been built against many shapes of interface (REST, OData, warehouse shares, SQL,
file exports). This guidance distils what that experience has taught us, so that a partner designing
or extending a data interface can make it suitable for an OEAI module from day one.

> [!NOTE]
> This guidance covers data flowing **into** OEAI so a module can be built on your system. It is a
> separate concern from how data is later made available **out of** a trust's datalake to third
> parties.

---

## Where this fits — the partner enablement path

This document is **the first step, and only the first step**. It answers exactly one question:

> **Is your data ready for an OEAI Module to be built against it?**

It is about *your* readiness — the shape, identity, change semantics and security of the interface
you expose. It deliberately does **not** tell you how to build a module, and it does not yet give
you anywhere to test one. Those are the packs that follow.

| # | Pack | The question it answers | Status |
|---|---|---|---|
| **1** | **Partner Readiness** *(this document)* | How do I expose my data — atomic, identified, incremental, secure — so that an OEAI Module **can** be built against it? | **Published** — open for partner feedback |
| **2** | **How to Build an OEAI Module** | How is the module itself built — Bronze → Silver → Gold, mapping into the canonical schema, coding and quality standards, validation? | **Planned** — not yet issued |
| **3** | **Partner Test Stub** | How do I test my module safely — against a **synthetic OEAI Framework school group** (a virtual environment, or a set of files) with realistic but entirely fictional schools, pupils and staff, and no real pupil data? | **Planned** — not yet issued |

### Who builds modules

The Technical Authority **sets and governs the standard — it does not build modules.** OEAI
**sponsors** modules to be built; they are delivered by partners OEAI commissions, and virtually all
modules to date have been built that way.

That is set to widen. Through an upcoming **Partner Accreditation programme**, OEAI intends to
increase the number of partners it can commission to build modules on its behalf — and, alongside
that, to accept **community‑contributed** modules and, in time, modules **built by EdTech partners
themselves**.

This is precisely why Packs 2 and 3 matter. Accredited partners, community contributors and
self‑building EdTech partners all need to work to the same standard, and to be able to prove they
have — which is what a build guide and a test stub are for.

Two things worth being explicit about:

- **Pack 1 is the one that pays.** A well‑formed interface is what makes a module quick to build and
  cheap to keep running — *whoever* builds it.
- **Nothing in Packs 2–3 changes Pack 1.** The readiness requirements here are the foundation for
  every build route. Getting them right is never wasted work.

---

## The five‑minute version

If you read nothing else, design to these principles:

1. **Atomic, not aggregated.** Give us the lowest‑grain records you hold (one row per pupil per
   attendance session, per assessment result, per behaviour event) — not pre‑summed totals. We do
   the aggregation. See [What data to provide](guide/03-what-data-to-provide.md).
2. **Stable identity on every row.** Every record must carry the keys needed to resolve *which
   school* and *which person* it belongs to — school **URN** (and/or DfE establishment number),
   pupil **UPN** plus your own source/MIS pupil id, staff id. See [Identity & keys](guide/04-identity-and-keys.md).
3. **Read‑only, least‑privilege, securely shared credentials.** Scope access to exactly the data in
   the agreement, support per‑school or per‑trust scoping, and let the school revoke it. See
   [Authentication & authorisation](guide/05-authentication-and-authorisation.md).
4. **Support both incremental *and* full loads.** Let us pull "everything changed since timestamp
   *T*" for daily syncs, *and* re‑pull a complete history (multiple academic years) on demand.
   Expose deletes. See [Incremental & historical loads](guide/06-incremental-and-historical-loads.md).
5. **Be explicit and stable.** Document your schema, paginate predictably, signal rate limits,
   version breaking changes, and give us a sandbox. See [API design & quality](guide/07-api-design-and-quality.md).

If your system already does most of this, a module build is straightforward. If it doesn't yet,
**the place to start is a REST API.** Standing one up over your existing data is more straightforward
than it used to be — and we make it easy: your developers get a ready‑to‑use
[OpenAPI contract](templates/oeai-rest-api.openapi.yaml) and a
[step‑by‑step path](guide/method-playbooks/rest-api.md). A CSV/SFTP export is *possible* as a
temporary bootstrap, but it means the module will have to be **redeveloped** once you move to an
API — so prefer the API from the start.

---

## How to use this guidance

| If you are… | Start here |
|---|---|
| Deciding **which mechanism** to expose | [02 · Choosing a data‑provision method](guide/02-choosing-a-method.md) |
| Designing **a REST API** *(recommended)* | [REST playbook](guide/method-playbooks/rest-api.md) + ready‑to‑use [OpenAPI contract](templates/oeai-rest-api.openapi.yaml) |
| Exposing **OData** | [Method playbook: OData](guide/method-playbooks/odata.md) |
| Sharing from a **warehouse** (Snowflake/BigQuery/Databricks) | [Method playbook: Data warehouse & secure share](guide/method-playbooks/data-warehouse-and-secure-share.md) |
| Granting **SQL / JDBC** access | [Method playbook: SQL database](guide/method-playbooks/sql-database.md) |
| Bootstrapping with **CSV / SFTP** *(temporary — see caveat)* | [Method playbook: Files, SFTP & CSV](guide/method-playbooks/files-sftp-csv.md) |
| Completing the **questionnaire** we sent you | [Data Provision Questionnaire](templates/data-provision-questionnaire.md) |

---

## Contents

### Core guidance
1. [Overview — OEAI, modules, and what "good" looks like](guide/01-overview.md)
2. [Choosing a data‑provision method (the design process)](guide/02-choosing-a-method.md)
3. [What data to provide — atomic records, entities & scopes](guide/03-what-data-to-provide.md)
4. [Identity & keys — schools, pupils, staff](guide/04-identity-and-keys.md)
5. [Authentication & authorisation](guide/05-authentication-and-authorisation.md)
6. [Incremental & historical loads (the delta approach)](guide/06-incremental-and-historical-loads.md)
7. [API design & quality — pagination, rate limits, errors, versioning](guide/07-api-design-and-quality.md)
8. [Security & governance](guide/08-security-and-governance.md)

### Method playbooks
- [REST API](guide/method-playbooks/rest-api.md)
- [OData](guide/method-playbooks/odata.md)
- [Data warehouse & secure share (Snowflake, BigQuery, Delta Sharing)](guide/method-playbooks/data-warehouse-and-secure-share.md)
- [SQL database (JDBC)](guide/method-playbooks/sql-database.md)
- [Files, SFTP & CSV](guide/method-playbooks/files-sftp-csv.md)

### Templates & reference
- [**Reference REST API contract — OpenAPI 3.1**](templates/oeai-rest-api.openapi.yaml) — the easy on‑ramp for your developers
- [Data Provision Questionnaire (you complete)](templates/data-provision-questionnaire.md)
- [Partner‑specific guidance template (the Technical Authority completes)](templates/vendor-specific-guide-template.md)
- [Appendix A — Canonical entities & fields](appendices/A-canonical-entities-and-fields.md)
- [Appendix B — Readiness checklist](appendices/B-readiness-checklist.md)
- [Appendix C — Glossary](appendices/C-glossary.md)
- [Appendix D — Worked example](appendices/D-worked-example.md)

---

## Status, authority & governance

- This guidance is **owned and issued by the OEAI Technical Authority**. The Technical Authority
  defines the canonical schema that partner data is standardised into; partners map their data into
  it, and the Technical Authority approves any addition to it.
- **Status:** version 1.0, published in the public OEAI repository on 21 September 2026 as the
  standard EdTech partners are asked to build to. Feedback and challenges are welcome as GitHub
  issues on this repository.
- **Changes** are made on the evidence, through Technical Authority review. If your system cannot
  meet part of this guidance, that is a conversation, not a failure — raise it with us and we will
  either design around it or change the guidance.
- **Per‑partner guidance.** From this generic standard we issue a short, system‑specific version for
  each partner: you complete the [questionnaire](templates/data-provision-questionnaire.md), and we
  produce guidance naming your endpoints, fields and auth flow, together with a tailored API contract
  and a runnable reference implementation.
- **Scope.** This is **Pack 1 — Readiness** in a three‑part partner enablement path (readiness →
  building → testing). Packs 2 and 3 are planned and not yet issued; see
  [Where this fits](#where-this-fits--the-partner-enablement-path). Their scope is not settled, and
  the Technical Authority welcomes input on what partners most need in them.

## Format

This guidance is plain GitHub‑flavoured Markdown and renders directly in the repository — that is
its primary and canonical form. The one non‑Markdown artefact is the
[reference API contract](templates/oeai-rest-api.openapi.yaml), which is OpenAPI 3.1 YAML because it
is meant to be machine‑read: partners generate server stubs from it.

---

*Issued by the Technical Authority, Open Education AI. Questions and challenges:
[info@openeducationai.org](mailto:info@openeducationai.org).*
