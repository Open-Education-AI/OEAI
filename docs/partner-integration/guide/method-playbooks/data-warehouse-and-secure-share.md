# Method playbook · Data warehouse & secure share

**Choose this when:** you hold data in a cloud data warehouse — **Snowflake, BigQuery, Databricks,
Azure Synapse, Redshift, or a managed Postgres** — and can grant a **governed, read‑only share**.
This is the **"scale" method**: the highest‑fidelity, highest‑volume, lowest‑friction way to give
OEAI data, and the best route for **complete multi‑year history**. Where a source already holds its
data in a warehouse, this is the route the Technical Authority prefers.

A module against this source is built as **snapshot‑based warehouse ingestion**: we read full, stable tables/views
directly, which makes ingestion deterministic, history complete, and identity resolution clean —
with no pagination or rate‑limit machinery to fight.

## Why it's the strongest option

- **Fidelity & scale** — read millions of atomic rows efficiently; no per‑request overhead.
- **Complete history** — warehouses usually hold full history, ideal for multi‑year backfill.
- **Stable, self‑describing schema** — `INFORMATION_SCHEMA`/catalog gives us types directly.
- **Governed** — platform‑native read‑only roles, row‑level security, and audit.

The trade‑off: warehouses often lack a native "what changed" feed, so the default is a **full
snapshot** each run. That's fine at moderate scale; for large data, add a **modified/loaded
timestamp column** (below) so we can run incrementally.

## What to share

- **Read‑only views at atomic grain**, one per entity/fact, exposing exactly the in‑scope
  columns — *not* your raw internal tables (which churn and over‑expose).
- **Identity columns on every row** — school (URN/your id), pupil (UPN + your id), and the
  record's key. (See [Identity & keys](../04-identity-and-keys.md).)
- **Reference/lookup tables** for your codes.
- Ideally a **`modified_at` / `_loaded_at` column** (or change‑tracking/streams) to enable
  incremental reads instead of full snapshots.

## Sharing mechanisms by platform

| Platform | Recommended mechanism |
|---|---|
| **Snowflake** | **Secure Data Sharing** to an OEAI consumer/reader account, *or* a read‑only role granted `SELECT` on specific views. Row‑level security / secure views to scope by school. |
| **BigQuery** | **Authorized views** or an **Analytics Hub** data exchange; or dataset‑level read IAM on a curated dataset. |
| **Databricks** | **Delta Sharing** (open protocol) — add OEAI as a recipient on specific shares. Maps naturally onto OEAI's Delta‑based platform. |
| **Synapse / Redshift / Postgres** | Read‑only role/user granted `SELECT` on specific views/schemas, accessed over JDBC (see [SQL playbook](sql-database.md)). |

## Authentication & governance

- A **dedicated read‑only role/grant** scoped to **exactly the shared objects** — nothing else.
- **Scope by school** with row‑level security or per‑school views where a single share serves a
  trust.
- Provide connection details (account/warehouse/region, or share name) over a **secure channel**.
- See [Authentication & authorisation](../05-authentication-and-authorisation.md) and
  [Security & governance](../08-security-and-governance.md).

## Incremental, full & deletes

- **Full snapshot (default):** we read the complete view each run; deletes are detected naturally
  by comparison (a row that's gone is gone). Simple and correct.
- **Incremental (recommended at scale):** expose a **`modified_at`** column (or change
  tracking/Snowflake Streams/Delta change feed) so we read only changed rows; pair with soft‑delete
  flags so deletions are visible without a full compare.
- **History:** ensure shared views include **all retained academic years**, and are
  **date‑filterable** so we can backfill in chunks.

## Example (Snowflake)

A scoped, atomic, identity‑bearing view plus a read‑only grant:

```sql
-- Atomic grain, identity on every row, only in-scope columns
CREATE OR REPLACE SECURE VIEW OEAI_SHARE.ATTENDANCE_SESSIONS AS
SELECT
    s.attendance_session_id,
    o.school_urn,
    o.school_source_id,
    p.upn,
    p.pupil_source_id,
    s.session_date,
    s.session_ampm,
    s.mark_code,
    m.mark_meaning,
    s.minutes_late,
    s.is_deleted,
    s.modified_at            -- enables incremental reads
FROM core.attendance_session s
JOIN core.pupil  p ON p.pupil_id  = s.pupil_id
JOIN core.school o ON o.school_id = s.school_id
LEFT JOIN ref.attendance_mark m ON m.code = s.mark_code;

-- Read-only access for OEAI, limited to the share schema
GRANT USAGE   ON DATABASE OEAI_DB              TO ROLE OEAI_READONLY;
GRANT USAGE   ON SCHEMA   OEAI_DB.OEAI_SHARE   TO ROLE OEAI_READONLY;
GRANT SELECT  ON ALL VIEWS IN SCHEMA OEAI_DB.OEAI_SHARE TO ROLE OEAI_READONLY;
```

## Common pitfalls

- ❌ Sharing raw internal tables that change shape without notice → treat shared views as a
  versioned contract.
- ❌ No `modified_at` on very large tables → forced full snapshots get slow; add the column.
- ❌ Identity columns missing from the views → unjoinable rows.
- ❌ Over‑sharing PII/special‑category columns not in scope → expose only what's agreed.
- ❌ Views that silently pre‑aggregate → keep them at atomic grain.

## What we'll ask for

Platform & region, the share/role mechanism, the views in scope, identity & `modified_at`
columns, how school scoping is enforced, history depth, and test access — see the
[Data Provision Questionnaire](../../templates/data-provision-questionnaire.md).
