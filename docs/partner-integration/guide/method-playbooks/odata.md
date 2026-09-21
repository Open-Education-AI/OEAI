# Method playbook · OData

**Choose this when:** you already expose **OData** (common for MIS and reporting layers), or you
want standard, well‑understood query and paging semantics without designing them yourself. OData
gives OEAI a self‑describing schema (`$metadata`) and built‑in filtering — both very helpful.

A module against this source is built as **incremental API ingestion (OData flavour)**: read `$metadata` for the
schema, page via server‑driven `@odata.nextLink`, and filter on a modified timestamp for deltas.

## Design checklist

- [ ] Expose **entity sets at atomic grain** (one per entity/fact), not summarised views.
- [ ] Publish a complete **`$metadata`** document (entity types, properties, keys, types).
- [ ] Identity on every entity — school (URN/your id), pupil (UPN + your id), and the entity **key**.
- [ ] **Server‑side `$filter`** on a **`Modified`/`LastUpdated`** datetime for incremental loads.
- [ ] **Date‑range `$filter`** for historical chunks (e.g. by academic year).
- [ ] **Server‑driven paging** via `@odata.nextLink` (preferred over client `$skip`).
- [ ] **Deletes** exposed (a soft‑delete property, or an OData delta link / tombstone set).
- [ ] **`$select`** supported so we can request only in‑scope fields.
- [ ] Auth over **TLS 1.2+**; sandbox available.

## Authentication

Commonly **Basic auth** (a dedicated read‑only service account) over TLS, or **OAuth 2.0**. We
maintain an authenticated session and respect any connection guards. Use a service account, not a
person's credentials. See [Authentication & authorisation](../05-authentication-and-authorisation.md).

## Incremental, full & deletes

| Need | Concretely |
|---|---|
| Daily delta | `GET /odata/AttendanceSessions?$filter=Modified ge 2026-06-23T00:00:00Z&$orderby=Id` |
| Historical chunk | `GET /odata/AttendanceSessions?$filter=SessionDate ge 2024-09-01 and SessionDate lt 2025-09-01` |
| Field scoping | `...&$select=Id,SchoolURN,UPN,SessionDate,Session,Mark,Modified` |
| Deletes | a `IsDeleted` property (bumping `Modified`), or OData **delta links** (`$deltatoken`) |

> **Server‑side filtering is essential.** If `$filter` on `Modified` isn't actually evaluated
> server‑side (and instead returns everything), incremental loads degrade to full pulls every run.
> Confirm the filter is honoured.

## Paging & throughput

- Prefer **server‑driven paging**: return `@odata.nextLink` and let us follow it. This is more
  robust than client‑driven `$skip`, which can skip/duplicate rows as data changes.
- If you only support `$top`/`$skip`, ensure a **stable `$orderby`** (e.g. by key) so paging is
  repeatable.
- Note any **response caching** window (some OData/MIS layers cache extracts for a period) so we
  schedule around it.
- Be cautious with **`$expand`** — deep expansions can be very expensive. We usually prefer to
  pull related entity sets separately and join in Silver.

## Example

```http
GET /odata/AttendanceSessions?$filter=Modified ge 2026-06-23T00:00:00Z&$select=Id,SchoolURN,UPN,PupilId,SessionDate,Session,Mark,Modified,IsDeleted&$orderby=Id
Authorization: Basic c3ZjX29lYWk6...
Accept: application/json
```

```json
{
  "@odata.context": "https://mis.example.com/odata/$metadata#AttendanceSessions",
  "value": [
    { "Id": "AS-8841273", "SchoolURN": "139352", "UPN": "X823456789012",
      "PupilId": "PUP-99213", "SessionDate": "2026-06-23", "Session": "AM",
      "Mark": "L", "Modified": "2026-06-23T09:02:11Z", "IsDeleted": false }
  ],
  "@odata.nextLink": "https://mis.example.com/odata/AttendanceSessions?$skiptoken=Id-AS-8841273"
}
```

## Common pitfalls

- ❌ Missing or incomplete `$metadata` → we can't infer schema reliably.
- ❌ `$filter` ignored server‑side → every run is a full pull.
- ❌ Client `$skip` paging over changing data without stable ordering → skipped/duplicated rows.
- ❌ No delete signal → stale rows.
- ❌ Heavy `$expand` as the only way to get child records → slow, fragile.

## What we'll ask for

The OData service root URL, `$metadata`, auth details & test credentials, the entity sets in
scope, the modified‑timestamp property, the deletes mechanism, any caching window, and sandbox
access — see the
[Data Provision Questionnaire](../../templates/data-provision-questionnaire.md).
