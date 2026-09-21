# Appendix D · Worked example

A concrete, end‑to‑end illustration of "good", using a **fictional** reading‑intervention app,
**BrightRead**. BrightRead is a non‑MIS SaaS product used by pupils for guided reading sessions; a
trust wants its reading data in OEAI alongside their MIS data. This shows how the principles in the
guide come together.

## 1 · The decision

BrightRead is cloud SaaS with a JSON API and a `updated_at` on every record → the
[decision flow](../guide/02-choosing-a-method.md#the-decision-flow) lands on **REST API**
(incremental API ingestion). They also keep full history in a Snowflake warehouse, so they offer a
**warehouse share for the one‑off historical backfill** and the **REST API for daily deltas** —
the recommended "history + delta" combination.

## 2 · What data (atomic, in scope)

BrightRead is the source of truth for **reading sessions** and **reading assessments** — not for
pupil demographics (the MIS owns those). In scope:

- `reading-sessions` — one row **per pupil, per session** (atomic).
- `reading-assessments` — one row **per pupil, per assessment result** (atomic).
- `reference/book-levels` — the code list decoding their reading levels.

They do **not** send "average reading age per class" — that's an aggregate OEAI derives itself.

## 3 · Identity on every row

Each record carries:

- School: **URN** (`school_urn`) + BrightRead's own school id (`school_source_id`).
- Pupil: **UPN** (`upn`) + BrightRead's pupil id (`pupil_source_id`) — UPN coverage is **98.1%**,
  which they tell OEAI up front so the 1.9% can be matched by fallback.
- Record: a stable `reading_session_id` on every session row.

This is what lets OEAI join BrightRead's reading facts to the trust's existing `dim_Student` and
`dim_Organisation`. (See [Identity & keys](../guide/04-identity-and-keys.md).)

## 4 · The delta & history contract

- **Incremental:** `GET /v1/reading-sessions?school=139352&updated_after=2026-06-23T00:00:00Z`
  (`updated_at` bumps on **any** change, including back‑dated corrections).
- **Full backfill:** a Snowflake share of `OEAI_SHARE.READING_SESSIONS` covering all 4 academic
  years they retain.
- **Deletes:** an `is_deleted` flag (bumping `updated_at`); plus a
  `GET /v1/reading-sessions/deletions?since=…` feed.

## 5 · A sample record

```json
{
  "reading_session_id": "RS-55021847",
  "school_urn": "139352",
  "school_source_id": "BR-SCH-014",
  "upn": "X823456789012",
  "pupil_source_id": "BR-PUP-99213",
  "session_started_at": "2026-06-23T13:40:05Z",
  "session_ended_at": "2026-06-23T13:58:32Z",
  "book_id": "BK-31288",
  "book_level_code": "L17",
  "words_read": 612,
  "accuracy_pct": 94.3,
  "comprehension_score": 8,
  "updated_at": "2026-06-23T14:01:10Z",
  "is_deleted": false
}
```

## 6 · How OEAI processes it

| Layer | What happens to the BrightRead record |
|---|---|
| **Bronze** | Stored exactly as received (the JSON above), immutable, per school. |
| **Silver** | Mapped to canonical: `book_level_code` decoded via the reference list; types conformed; deduplicated on `reading_session_id`; identity columns standardised; metadata (`_source_system='brightread'`, `_source_id='RS-55021847'`, …) stamped. Lands in a `fact_ReadingSession` table. |
| **Gold** | Joined to `dim_Student` (via UPN) and `dim_Organisation` (via URN) to add `studentkey`/`organisationkey`; **academic year** derived from `session_started_at`; cleaned and written as analytics‑ready Parquet. |

The result: BrightRead reading sessions sit alongside the trust's attendance, behaviour, and
assessment data, joinable by pupil and school, ready for the trust's reporting and AI — because the
records were **atomic** and **carried identity**, and the feed supported **delta + full + deletes**.

## 7 · Auth & security

- OAuth 2.0 client‑credentials, a per‑trust client scoped to `reading:read`, read‑only.
- The Snowflake share is a read‑only role on the `OEAI_SHARE` schema, row‑level‑secured by school.
- The trust can revoke either at any time; credentials were shared via a secrets manager, not email.

---

*BrightRead is illustrative. Your system will differ — but the same five things make it work:
atomic records, identity on every row, delta + full + deletes, read‑only scoped access, and a
documented stable interface.*
