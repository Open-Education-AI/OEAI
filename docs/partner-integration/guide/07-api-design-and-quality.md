# 7 · API design & quality — pagination, rate limits, errors, versioning

This chapter is the engineering hygiene that makes an interface reliable to build against and
cheap to keep running. It applies most directly to **REST/OData**, but the spirit — predictable,
documented, stable — applies to every method.

> **Principle.** Be **explicit, predictable, and stable.** Surprises in pagination, rate limits,
> error handling, or schema are what turn a working module into a 2am pipeline failure.

## Pagination

Large datasets must page, and the *way* they page matters:

- **Prefer cursor/keyset pagination** over offset/skip. Cursors are stable when data changes
  mid‑traversal; offsets can skip or duplicate rows as records shift. We support both, but cursor
  is more robust for incremental loads.
- **Return the next‑page token explicitly** (e.g. `meta.pagination.next`, an OData `@odata.nextLink`,
  or a `next` URL). We follow it until it's absent.
- **Use a stable, deterministic sort** (e.g. by id or by `updated_at, id`) so paging is repeatable.
- **Document the page size** and whether we can request it. A sensible default (e.g. 100–1000) is
  fine; allow larger pages for bulk pulls if you can.
- **Total counts are nice‑to‑have**, not required — but don't make us rely on a count that drifts.

## Rate limits & throttling

We will respect your limits — but only if we can see them:

- **Publish your rate limits** (requests/second, requests/day, concurrency) in the docs.
- **Signal throttling with HTTP `429`** and a **`Retry-After`** header. We back off and retry
  automatically when you do this; without it we have to guess.
- **State safe concurrency.** We can pull schools in parallel — tell us how many concurrent
  requests are acceptable so we tune throughput without tripping limits.
- **Consider the multi‑school reality.** A trust may have dozens of schools. If limits are tight,
  a **bulk/all‑schools endpoint** or a **warehouse share** beats thousands of small calls — see
  [Choosing a method](02-choosing-a-method.md).

## Error semantics

Predictable failures let us retry safely instead of corrupting data:

- **Use correct HTTP status codes.** `200` for success, `401/403` for auth, `404` for not found,
  `429` for rate limit, `5xx` for server errors. Don't return `200` with an error body.
- **Return machine‑readable error bodies** — a stable error `code`, a human `message`, and ideally
  a request id we can quote in support.
- **Make reads idempotent.** The same request returns the same data; a retry after a network blip
  is always safe.
- **Fail a page, not the world.** If one record is malformed, don't 500 the whole page — but if you
  must, make the boundary clear so we can narrow and retry.

## Document the schema

We map your fields into OEAI's canonical schema; we can only do that well if every field is
documented:

- **Per field:** name, type, meaning, example value, whether nullable, and the allowed set for
  enumerations/codes.
- **Machine‑readable spec preferred** — an **OpenAPI/Swagger** document (REST), the OData
  `$metadata` document (OData), or an `INFORMATION_SCHEMA`/table DDL (warehouse/SQL). These let us
  infer schema reliably rather than guessing from samples.
- **Provide representative sample payloads** for each entity, including edge cases (nulls, deleted
  records, unusual codes).

## Schema stability & versioning

The single biggest cause of a previously‑healthy module breaking is a **silent schema change**.

- **Treat your schema as a contract.** Under the DataLake Builder model, your data ultimately
  feeds **Gold tables that are public interfaces** for the trust — breaking changes ripple
  downstream into their reports.
- **Make changes additive where possible.** Adding a new, optional field is safe. **Renaming,
  removing, retyping, or changing the meaning of an existing field is breaking.**
- **Version breaking changes** — in the path (`/v2/…`), a header, or a dated version — and run the
  old version alongside for a transition window.
- **Publish a changelog and a deprecation policy.** Tell us *before* you change things. Even a
  short email to your OEAI technical contact ahead of a release prevents an outage.

## Data formats & encoding

- **JSON** for APIs; **CSV** (RFC 4180, quoted, header row) or **Parquet** for files/exports;
  Parquet/Delta for warehouse.
- **UTF‑8** everywhere. Declare encoding for files.
- **Consistent types** — a field is always the same type; don't return `"123"` sometimes and `123`
  other times, or `""` vs `null` interchangeably without meaning.
- **Dates/times ISO 8601**, timezone explicit, UTC where you can. Avoid locale formats like
  `24/06/2026`.
- **Nulls are meaningful** — send them; don't omit keys or substitute sentinel strings like
  `"N/A"` without documenting them.

> **One internal note that affects you indirectly:** OEAI's platform (Microsoft Fabric / Delta
> Lake) doesn't accept "timestamp‑without‑timezone" semantics cleanly. You don't need to do
> anything special beyond sending **clear, timezone‑qualified ISO 8601 timestamps** — that maps
> straight through.

## Consistency & referential integrity

- **No duplicate record ids** within a single response/page.
- **Referential integrity:** if a fact references a pupil id, that pupil should be resolvable
  (present in your student dataset or via the shared identifier). Dangling references become
  unjoinable rows.
- **Stable ordering** across pages of the same query.

## Give us a sandbox

A **non‑production test environment** with **representative (anonymised) data** is one of the
highest‑leverage things you can provide:

- It lets us complete the "kick the tyres" step (authenticate + pull sample) **without touching
  live pupil data**.
- It lets us build and validate the module before a single school is onboarded.
- Representative means *shaped like production* — real codes, nulls, edge cases, multiple schools
  — not three perfect rows.

## A quick quality checklist

- [ ] Cursor pagination with an explicit next‑page token and stable sort
- [ ] Documented rate limits; `429` + `Retry-After` on throttle
- [ ] Correct HTTP status codes and machine‑readable errors; idempotent reads
- [ ] Per‑field documentation + OpenAPI/`$metadata`/DDL
- [ ] Additive‑first schema changes; versioning + changelog + deprecation policy
- [ ] UTF‑8, ISO‑8601 dates, consistent types, meaningful nulls
- [ ] No duplicate ids; referential integrity; stable ordering
- [ ] Sandbox with representative data + sample payloads

---

**Next:** [8 · Security & governance →](08-security-and-governance.md)
