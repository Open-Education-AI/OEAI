# Method playbook · REST API

**Choose this when:** your product is a SaaS application with an HTTP/JSON API, data changes
through the day, and you can expose a change indicator. This is the most common shape for
EdTech apps.

A module against this source is built as **incremental API ingestion**: we pull per entity, page through results,
store the raw JSON in Bronze, then deduplicate and standardise in Silver. We typically hold a
**per‑school credential** and iterate schools (in parallel where your limits allow).

> **This is OEAI's recommended approach — and standing one up is more straightforward than it used
> to be.** For most teams it's a handful of **read‑only** endpoints over data you already hold:
> days of work, not weeks. To make it easier still, we give you a ready‑to‑use OpenAPI contract you
> can generate server stubs from.

## The easy path — start from our OpenAPI contract

You don't have to design the API from scratch. OEAI publishes a reference contract that already
encodes everything in this guide — atomic resources, identity fields, incremental + full + deletes,
cursor pagination, and read‑only auth:

**→ [`templates/oeai-rest-api.openapi.yaml`](../../templates/oeai-rest-api.openapi.yaml)** (OpenAPI 3.1)

1. **Explore it** — open the file in [editor.swagger.io](https://editor.swagger.io) to see the
   endpoints, parameters, and record shapes.
2. **Generate server stubs** in your stack with [OpenAPI Generator](https://openapi-generator.tech/):
   ```bash
   openapi-generator-cli generate -i oeai-rest-api.openapi.yaml \
     -g python-fastapi      # or: nodejs-express-server · aspnetcore · spring · go-server
   ```
3. **Implement each endpoint as a thin read** over your existing database — a `SELECT` that maps
   your rows to the response schema. Keep the response *shape*; adapt field names to your data and
   tell us the mapping.
4. **Add auth, paging, and the `updated_after` filter** — the generated stubs scaffold the rest.
5. **Validate** your responses against the spec, then hand us a sandbox URL.

Host it however suits you — a small service, or **serverless** (Azure Functions / AWS Lambda /
Cloud Run) for near‑zero idle cost. It only needs to be reachable by OEAI and read‑only.

## Design checklist

- [ ] **One endpoint per entity**, returning **atomic records** (`/attendance-sessions`,
      `/behaviour-events`, `/assessment-results`), not summaries.
- [ ] Every record carries **identity** — school (URN/your id), pupil (UPN + your pupil id), and a
      **stable record id**. (See [Identity & keys](../04-identity-and-keys.md).)
- [ ] **Incremental:** an `updated_after` (or `modified_since`) query param, and an `updated_at`
      that bumps on **every** change.
- [ ] **Full:** the same endpoints work with no/`from=...` bound to retrieve full history.
- [ ] **Deletes:** a `is_deleted` flag (with `updated_at` bumped) **or** a `/deletions?since=` feed.
- [ ] **Cursor pagination** with an explicit next‑page token.
- [ ] **Rate limits published**; `429` + `Retry-After` on throttle.
- [ ] **OAuth 2.0 client‑credentials** or **per‑school API key** in a header.
- [ ] **Sandbox** + sample payloads.

## Authentication

Preferred: **OAuth 2.0 client credentials** (per‑tenant client, dataset scopes) issuing short‑lived
bearer tokens. Equally fine: a **per‑school API key (+ secret)** sent in a header (`Authorization`
or a custom header) — never in the query string. Enforce **TLS 1.2+**. See
[Authentication & authorisation](../05-authentication-and-authorisation.md).

## Incremental, full & deletes

| Need | Concretely |
|---|---|
| Daily delta | `GET /attendance-sessions?school=139xxx&updated_after=2026-06-23T00:00:00Z` |
| Full / backfill | `GET /attendance-sessions?school=139xxx&from=2019-09-01` (paged, chunked by date) |
| Deletes | `is_deleted: true` on the record (with bumped `updated_at`) **or** `GET /attendance-sessions/deletions?since=...` |

`updated_at` **must** reflect last modification (not just creation), or daily deltas miss
corrections — the single most common cause of drift. See
[Incremental & historical loads](../06-incremental-and-historical-loads.md).

## Pagination & throughput

- **Cursor/keyset** preferred; return `meta.pagination.next` (a token or full URL) and a stable
  sort (`updated_at, id`). We follow `next` until it's null.
- Allow a reasonable **page size** (100–1000+).
- Publish **rate limits** and **safe concurrency** — a trust may have many schools; if limits are
  tight, offer a **bulk/all‑schools** endpoint so we don't make thousands of small calls.

## Example

Request:

```http
GET /v1/attendance-sessions?school=139352&updated_after=2026-06-23T00:00:00Z&page_size=500
Authorization: Bearer eyJhbGciOi...
Accept: application/json
```

Response (atomic rows, identity on each, cursor for next page):

```json
{
  "data": [
    {
      "attendance_session_id": "AS-8841273",
      "school_urn": "139352",
      "school_source_id": "SCH-014",
      "upn": "X823456789012",
      "pupil_source_id": "PUP-99213",
      "session_date": "2026-06-23",
      "session": "AM",
      "mark": "L",
      "mark_meaning": "Late (before registers closed)",
      "minutes_late": 12,
      "updated_at": "2026-06-23T09:02:11Z",
      "is_deleted": false
    }
  ],
  "meta": { "pagination": { "next": "https://api.example.com/v1/attendance-sessions?cursor=eyJrIjoxMjN9" } }
}
```

## Common pitfalls

- ❌ `updated_at` that only reflects creation → corrections never re‑sync.
- ❌ Offset/`page` pagination over changing data → skipped/duplicated rows.
- ❌ Aggregated endpoints (`/attendance-summary`) with no underlying records.
- ❌ Hard deletes with no flag or deletions feed → stale rows accumulate.
- ❌ Identity missing from rows (relying on "you asked for school X so all rows are X") → breaks
  when data is combined.

## What we'll ask for

Base URL, auth flow & how to get test credentials, OpenAPI/Swagger doc, the entity endpoints in
scope, the incremental param, the deletes mechanism, rate limits, the multi‑school pattern, and
sandbox access. All captured in the
[Data Provision Questionnaire](../../templates/data-provision-questionnaire.md).
