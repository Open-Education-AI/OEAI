# Vendor‑specific guide template

> **For OEAI to complete.** This is the template OEAI uses to **spin out a customised guide for a
> specific partner**, by combining this generic guide with the partner's
> [Questionnaire](data-provision-questionnaire.md) answers and their API/interface docs. Replace
> every `[PLACEHOLDER]`, delete options that don't apply, and keep it short — link back to the
> generic guide chapters for detail rather than repeating them.
>
> It follows the same seven‑section spine as OEAI's standard "Building an OEAI Module" customer
> document, with an added **technical interface** section tailored to the partner's chosen method.
> When sent, paste the body into an email under a personalised greeting and remove this note and
> the "OEAI internal notes" section at the end.

---

# Providing [SYSTEM NAME] Data to OEAI — Integration Guide for [VENDOR NAME]

Prepared for **[CUSTOMER / TRUST NAME]** and **[VENDOR NAME]** · [DATE] · OEAI Technical Authority

## 1 · What is OEAI?

Open Education AI (OEAI) gives schools and trusts a single, standardised
view of their own data for analytics and AI — without lock‑in. [1–2 lines tailored to this
customer's context/use case.]

## 2 · What is an OEAI Module?

A Data Source Module is a self‑contained pipeline that ingests data from one source system —
here, **[SYSTEM NAME]** — and standardises it into OEAI's common model (Bronze → Silver → Gold).
See the [Overview](../guide/01-overview.md).

## 3 · Why OEAI is sponsoring a [SYSTEM NAME] Module

[2–3 sentences: what data [SYSTEM NAME] holds, what it enables for [CUSTOMER NAME], which
domains/packages it feeds — e.g. attendance analytics, safeguarding insight, HR/absence reporting.]

## 4 · What we need from [VENDOR NAME]

Based on your system, the integration will use **[CHOSEN METHOD: REST API / OData / warehouse share
/ SQL / SFTP]**. Concretely, we need:

**Data**
- [ ] Atomic, record‑level data for: [LIST IN‑SCOPE ENTITIES/DATASETS].
- [ ] Reference/lookup data for: [LIST CODE LISTS].

**Identity** (see [Identity & keys](../guide/04-identity-and-keys.md))
- [ ] School identifier on every row: **[URN / establishment number / your school id]**.
- [ ] Pupil identifier: **UPN** + **[your pupil id]** (where applicable). *[Note UPN coverage if known.]*
- [ ] Staff identifier: **[your staff id / payroll / NI / TRN]** (where applicable).
- [ ] A stable record id per fact: **[e.g. attendance_session_id]**.

**Access** (see [Auth](../guide/05-authentication-and-authorisation.md))
- [ ] Read‑only, scoped credentials via **[OAuth 2.0 / API key / DB account / share grant / SSH key]**,
      shared over a secure channel.
- [ ] Scoping: **[per‑school credentials / trust‑level + school filter]**.
- [ ] [IP allow‑listing of OEAI egress IPs, if needed.]

**Change & history** (see [Incremental & historical loads](../guide/06-incremental-and-historical-loads.md))
- [ ] Incremental via **[updated_after param / $filter on Modified / modified_at column / changed‑since files]**.
- [ ] Full backfill of **[N academic years]** of history.
- [ ] Deletes via **[soft‑delete flag / deletions feed / full‑snapshot reconciliation]**.

**Quality** (see [API design & quality](../guide/07-api-design-and-quality.md))
- [ ] [Schema docs: OpenAPI / $metadata / DDL.]
- [ ] [Pagination, rate limits, sandbox access.]

## 5 · What [CUSTOMER / TRUST NAME] needs to arrange

- [ ] Authorise the integration with [VENDOR NAME] and confirm the data‑sharing agreement.
- [ ] Obtain/confirm the credentials and access level from [VENDOR NAME].
- [ ] Name an internal technical contact and a QA sign‑off contact.
- [ ] Act as development partner for the first deployment and feedback.

## 6 · What happens next

1. We read your [docs/`$metadata`/DDL], authenticate against the [sandbox/endpoint], and pull
   sample data to confirm the approach.
2. The commissioned build partner implements Bronze → Silver → Gold; the Technical Authority
   reviews the mapping into the canonical schema.
3. Development‑partner review, then a short pilot, then GA release.

## 7 · Questions?

Your OEAI contact: **[NAME, EMAIL]** · general: [info@openeducationai.org](mailto:info@openeducationai.org).

---

## Technical interface specification — [SYSTEM NAME] (appendix)

*Filled from the partner's docs + questionnaire. Keep concrete: name the actual endpoints/objects.*

| Item | Detail |
|---|---|
| Method | [REST / OData / warehouse / SQL / SFTP] |
| Base URL / share / host | [...] |
| Auth | [flow + how test creds are obtained] |
| Entities in scope | [endpoint/object → OEAI canonical table] |
| Identity columns | [field → URN / UPN / id] |
| Incremental param | [...] |
| Deletes | [...] |
| History depth | [...] |
| Pagination | [...] |
| Rate limits | [...] |
| Multi‑school pattern | [single call / per‑school] |
| Sandbox | [...] |
| Reference implementation *(optional)* | [link to a runnable example in your stack, generated from the OEAI OpenAPI contract and mapped to [SYSTEM NAME]'s fields — available on request] |

### Security & reassurance (keep in the customer copy)

> Access to [SYSTEM NAME] is **read‑only**. Data is transferred **securely** using [VENDOR NAME]'s
> approved authentication. Only the data needed for the agreed reporting is accessed. **Access can
> be revoked by [CUSTOMER NAME] at any time** within [SYSTEM NAME].

---

### OEAI internal notes (remove before sending)

- Ingestion pattern: [incremental API / snapshot warehouse / dual‑path / file].
- Suggested scaffold: [`scaffold_bronze_api` / `_db` / `_file`].
- Canonical mapping notes / net‑new fields needing TA review: [...].
- **Reference implementation (optional, decide per vendor):** if it would accelerate [VENDOR NAME]'s
  dev team, generate a runnable example in their stack from `templates/oeai-rest-api.openapi.yaml`,
  wired to the field mappings above. Not needed for every guide — offer where it earns its keep.
- Open questions / risks: [...].
