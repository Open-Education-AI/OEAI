# Method playbook · SQL database (JDBC)

**Choose this when:** you don't have an application API or warehouse share, but you *can* grant
**read‑only access to a database** — ideally a **replica or a set of reporting views**, reached
over **JDBC** (SQL Server, PostgreSQL, MySQL, Oracle, etc.).

A module against this source is built as **snapshot / dual‑path ingestion**: we discover objects via
`INFORMATION_SCHEMA`, read the in‑scope views over JDBC, and materialise them into Bronze. It's a
close cousin of the warehouse method — same strengths (fidelity, full history), with more care
needed around protecting your production database.

## Design checklist

- [ ] Expose **read‑only views** purpose‑built for OEAI — **not** raw base tables.
- [ ] Views at **atomic grain** with **identity columns** on every row (school URN/your id, pupil
      UPN + your id, the record key).
- [ ] Run access against a **read replica / reporting instance**, not the live transactional DB.
- [ ] Add a **`modified_at`/rowversion** column where possible, to enable incremental reads.
- [ ] A **read‑only service account** limited to the OEAI schema/views only.
- [ ] **TLS** enforced; **IP allow‑listing** if used (we'll supply egress IPs).
- [ ] Stable view names/shapes (a versioned contract).

## Authentication & access

- A **dedicated read‑only login** granted `SELECT` on **only** the OEAI views/schema — no base
  tables, no other schemas, no write/DDL.
- Prefer a **replica** so OEAI reads never load your production workload.
- Share the JDBC URL, driver/dialect, and credentials over a **secure channel**.
- See [Authentication & authorisation](../05-authentication-and-authorisation.md).

## Incremental, full & deletes

- **Full snapshot (default):** read the whole view each run; deletes detected by comparison.
- **Incremental:** expose a **`modified_at`** or DB **rowversion**/change‑tracking column so we
  read only changed rows. Pair with a **soft‑delete flag** to make deletions visible.
- **History:** keep all retained academic years in the views and make them **date‑filterable** so
  large backfills run in chunks (per year/month).
- **Large tables:** support date‑bounded queries; we read in windows and tune fetch size.

## Example (SQL Server)

```sql
-- Dedicated read-only schema of OEAI views
CREATE VIEW oeai.AttendanceSessions AS
SELECT
    s.AttendanceSessionId,
    o.SchoolURN,
    o.SchoolSourceId,
    p.UPN,
    p.PupilSourceId,
    s.SessionDate,
    s.Session,            -- 'AM' / 'PM'
    s.MarkCode,
    m.MarkMeaning,
    s.MinutesLate,
    s.IsDeleted,
    s.ModifiedAt          -- enables incremental
FROM core.AttendanceSession s
JOIN core.Pupil  p ON p.PupilId  = s.PupilId
JOIN core.School o ON o.SchoolId = s.SchoolId
LEFT JOIN ref.AttendanceMark m ON m.Code = s.MarkCode;

-- Read-only principal, limited to the oeai schema
CREATE USER oeai_ro WITHOUT LOGIN;
GRANT SELECT ON SCHEMA::oeai TO oeai_ro;
```

## Common pitfalls

- ❌ Granting access to **base tables** → over‑exposure and brittleness; use curated views.
- ❌ Reading the **production** DB directly → performance risk; use a replica.
- ❌ No `modified_at`/rowversion on large tables → full snapshots get expensive.
- ❌ Timestamps without a clear timezone → send/define timestamps clearly (OEAI normalises to
  timezone‑aware types; ISO‑8601/UTC clarity avoids ambiguity).
- ❌ Views that change shape without notice → treat them as a versioned contract and tell us before
  changes.

## What we'll ask for

DB engine & version, JDBC URL/host, the read‑only account, the views in scope, identity &
`modified_at` columns, replica availability, IP allow‑listing needs, history depth, and test
access — see the
[Data Provision Questionnaire](../../templates/data-provision-questionnaire.md).
