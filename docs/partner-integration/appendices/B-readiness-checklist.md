# Appendix B · Readiness checklist

A one‑page self‑assessment. The more you can tick, the faster and more robust the module build. If
you can't tick something, that's not a blocker — it's a useful thing to flag to OEAI. Chapter links
point to the detail.

## Data content ([ch.3](../guide/03-what-data-to-provide.md))

- [ ] Data is available at **atomic, record‑level** grain (not only aggregates/summaries)
- [ ] In‑scope **entities/datasets** are clearly identified
- [ ] **Reference/lookup** (code list) data is available for coded fields
- [ ] Raw values provided (codes **and** their meanings); nulls preserved
- [ ] Fields documented (name, type, meaning, example, nullable, allowed values)

## Identity ([ch.4](../guide/04-identity-and-keys.md))

- [ ] **School identifier** on every row — **URN** preferred (+ establishment/your id)
- [ ] **Pupil identifier** on pupil‑level rows — **UPN** + your pupil id + school context
- [ ] **Staff identifier** where applicable (your staff id; payroll/NI/TRN if held)
- [ ] Every fact row carries a **stable record id**
- [ ] Identifiers are **stable** (never change) and **never reused**
- [ ] You know your **UPN / URN coverage** and can share it

## Access method ([ch.2](../guide/02-choosing-a-method.md) + playbooks)

- [ ] A suitable mechanism is identified (REST / OData / warehouse / SQL / SFTP)
- [ ] A **sandbox / test environment** with representative data exists
- [ ] **Sample payloads / files / DDL** can be shared

## Incremental, history & deletes ([ch.6](../guide/06-incremental-and-historical-loads.md))

- [ ] A reliable **change indicator** exists (`updated_at` that bumps on every change, or version/CDC)
- [ ] We can request **"changed since *T*"** (incremental)
- [ ] We can retrieve a **full export** including **multiple academic years** of history
- [ ] **Deletes** are exposed (soft‑delete flag, deletions feed, or full‑snapshot reconciliation)
- [ ] Large data can be pulled in **date‑bounded, resumable chunks**

## Authentication & security ([ch.5](../guide/05-authentication-and-authorisation.md), [ch.8](../guide/08-security-and-governance.md))

- [ ] **Read‑only** access is available
- [ ] Access can be **scoped** per‑school or per‑trust
- [ ] Credentials shared over a **secure channel** (not email); **rotation** supported
- [ ] The **school can revoke** access at any time
- [ ] **IP allow‑listing** needs identified (if any)
- [ ] Data **hosting region** and any **sub‑processors** known; certifications available

## API design & quality ([ch.7](../guide/07-api-design-and-quality.md))

- [ ] **Pagination** is predictable (cursor preferred) with stable ordering
- [ ] **Rate limits** published; `429` + `Retry-After` on throttle
- [ ] Correct **HTTP status codes** and machine‑readable errors; reads idempotent
- [ ] **Schema documented** (OpenAPI / `$metadata` / DDL)
- [ ] Schema changes are **additive‑first**, **versioned**, with a changelog
- [ ] **UTF‑8**, **ISO‑8601** dates, consistent types, meaningful nulls
- [ ] The **multi‑school pattern** is known (single call vs per‑school)

---

**Scoring (informal):** mostly ticked → a module build is straightforward. Several gaps in
*identity* or *atomic grain* → address those first; they're the ones that block. Gaps in
*incremental/quality* → workable, we design around them.
