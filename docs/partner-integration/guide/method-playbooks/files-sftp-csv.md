# Method playbook · Files, SFTP & CSV

**Choose this only as a temporary first step.** If you have no API yet and need to unblock a
module quickly, a scheduled export of atomic records as files works. But OEAI's strong
recommendation is to **start with a [REST API](rest-api.md)** — standing one up over your existing
data is straightforward (follow [the easy path](rest-api.md#the-easy-path--start-from-our-openapi-contract),
which hands your devs a ready‑made OpenAPI contract). File/SFTP delivery is a stopgap, not a
destination.

> [!IMPORTANT]
> **A file/SFTP feed means the module will need to be redeveloped later.** A file‑based module and
> an API‑based module are built differently — moving from one to the other is a **rebuild, not a
> tweak**. If you can stand up a REST API now, even a minimal one over your existing data, do that
> instead and avoid the rework. We would much rather help your developers ship a small API than
> wire up SFTP.

A module against this source is built as **file ingestion**: we pick up files on a schedule, land them in Bronze, and
standardise in Silver.

## Design checklist

- [ ] **One file per entity** at **atomic grain** (`attendance_sessions.csv`, `behaviour_events.csv`).
- [ ] **Identity columns on every row** — school URN/your id, pupil UPN + your id, the record key.
- [ ] **Header row**, **UTF‑8**, **RFC 4180** CSV (quoted fields) — or **Parquet** for large/typed
      data (preferred at volume).
- [ ] **Consistent schema** every run — same columns, same names, same order.
- [ ] **ISO‑8601 dates**; preserve identifiers **as text** (don't let Excel strip leading zeros).
- [ ] **Full export** of all retained history, plus a **changed‑since** file or full snapshot each
      run.
- [ ] A **deletions file** *or* rely on **full‑snapshot** reconciliation.
- [ ] **Timestamped filenames** + a **manifest/checksum** so we know a drop is complete.
- [ ] Delivered over **SFTP (SSH keys)** or a **secure cloud bucket**.

## Transport & cadence

- **SFTP** with **SSH key‑based** auth (not passwords), a dedicated account, and **per‑trust
  directory isolation**. A secure cloud bucket (Azure Blob/S3/GCS) with scoped credentials works
  equally well. Optional **PGP encryption** of files at rest.
- **Daily drop** is the norm; agree a window. Use **timestamped filenames**
  (`attendance_sessions_2026-06-24.csv`) and write atomically (upload to a temp name, then rename)
  so we never read a half‑written file.
- Include a **manifest** listing files, row counts, and checksums for the drop.

## Full, incremental & deletes

- **Full snapshot each run** is the simplest reliable pattern at low/moderate volume — OEAI
  detects deletes by comparison, and there's no watermark to get wrong.
- **Changed‑since files** (only rows modified since the last drop) suit larger data — include a
  `modified_at` column and, crucially, a **deletions file** (ids removed) since a delta alone can't
  signal deletion.
- **History:** provide a one‑off **multi‑year backfill** (one file per academic year is fine), then
  ongoing drops. See [Incremental & historical loads](../06-incremental-and-historical-loads.md).

## Example

Filename convention and a manifest:

```
/oeai/trust-greenfield/2026-06-24/
  attendance_sessions_2026-06-24.csv
  behaviour_events_2026-06-24.csv
  deletions_2026-06-24.csv
  manifest_2026-06-24.json
```

```csv
attendance_session_id,school_urn,school_source_id,upn,pupil_source_id,session_date,session,mark,mark_meaning,minutes_late,modified_at,is_deleted
AS-8841273,139352,SCH-014,X823456789012,PUP-99213,2026-06-23,AM,L,Late (before registers closed),12,2026-06-23T09:02:11Z,false
```

```json
{ "drop_date": "2026-06-24", "files": [
  { "name": "attendance_sessions_2026-06-24.csv", "rows": 184213, "sha256": "9f2c..." },
  { "name": "deletions_2026-06-24.csv", "rows": 37, "sha256": "ab18..." } ] }
```

> ⚠️ **Beware Excel.** If files are produced via spreadsheets, URNs/UPNs/establishment numbers lose
> leading zeros and dates get reformatted to `dd/mm/yyyy`. Export identifiers **as text** and dates
> as **ISO‑8601**, or generate the files programmatically.

## Common pitfalls

- ❌ Aggregated spreadsheets (a tab of class/term totals) instead of atomic rows.
- ❌ Column order/names changing between drops → breaks parsing; keep the schema stable.
- ❌ No header row, mixed encodings, unquoted fields containing commas/newlines.
- ❌ Leading zeros stripped from URN/UPN; locale date formats.
- ❌ Half‑written files (no atomic rename/manifest) → partial ingests.
- ❌ Hard deletes with no deletions file and no full snapshot → stale rows persist.

## What we'll ask for

Transport (SFTP/bucket) & credentials, file format, the entities/files in scope, identity columns,
full‑vs‑changed‑since approach, the deletes mechanism, cadence & naming, and a couple of sample
files — see the
[Data Provision Questionnaire](../../templates/data-provision-questionnaire.md).
