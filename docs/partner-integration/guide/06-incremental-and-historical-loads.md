# 6 · Incremental & historical loads (the delta approach)

OEAI needs to do two different things with your data, and your interface should support **both**:

1. **Incremental (delta) loads** — "give me only what changed since last time" — run frequently
   (typically **daily**) to keep data fresh cheaply.
2. **Full loads** — "give me everything, including history" — run for the initial backfill and
   periodically to reconcile, including **multiple historical academic years**.

> **Principle.** Support **incremental *and* full** retrieval, and **expose deletes.** Incremental
> keeps us current at low cost; full keeps us *correct*; deletes keep us in sync. Missing any one
> of these forces expensive workarounds or silent data drift.

## Why both, not one

No single strategy suits every source. OEAI deliberately supports both because the right choice is
driven by **how your system behaves**, not preference:

| Consideration | Incremental load | Full load |
|---|:--:|:--:|
| API‑based source | ✅ | — |
| Warehouse / DB access | — | ✅ |
| Late corrections common | ⚠️ | ✅ |
| Change indicators available | ✅ | — |
| Compute/cost sensitive | ✅ | — |
| Correctness / completeness priority | ⚠️ | ✅ |

The mature pattern combines them: a **full load** establishes complete, correct history; **daily
deltas** keep it current; an **occasional full reload** reconciles any drift.

## Incremental loads — what we need from you

For us to pull "only what changed", your data must carry a reliable **change indicator** and let
us **filter on it server‑side**.

### A good change indicator

Provide at least one of, in order of preference:

1. **A `modified`/`updated_at` timestamp on every record** that updates on **every** change to
   that record — and ideally changes when a *related* child record changes, if you denormalise.
   Must be **filterable** (`updated_after` / `$filter=Modified ge …`).
2. **A monotonically increasing version / rowversion / change‑sequence** per record we can watermark on.
3. **A change feed / CDC stream** (inserts, updates, deletes since a cursor).

### How OEAI uses it (the watermark pattern)

We keep a **per‑school, per‑entity "last successful" marker** (a watermark). Each run we ask for
everything changed **after** that marker, process it, then advance the marker. So your side needs:

- A parameter to request **"changed since *T*"** (timestamp or version/cursor).
- Results that **reliably include every record changed since *T*** — no silent omissions.
- A way to know we got everything for the window (stable paging — see
  [API design & quality](07-api-design-and-quality.md)).

### Make corrections visible

Education data is frequently **amended and back‑dated** (a register fixed days later, a result
re‑entered). For incremental loads to stay correct:

- **Any change to a record must bump its `updated_at`/version**, so the delta picks it up — even
  if the *event date* is in the past.
- If you let `updated_at` represent only creation, we'll miss edits. It must track **last
  modified**.

> ⚠️ **The classic failure mode:** a record is corrected but its `updated_at` doesn't move, so the
> delta never re‑sends it and the correction is lost until the next full reload. Bumping the
> timestamp on every write prevents this.

## Deletes — please don't let records just vanish

If a record is **hard‑deleted** in your system and your feed simply stops returning it, an
incremental load has **no way to know it's gone** — OEAI keeps the stale row and the data drifts
out of sync. Expose deletions explicitly, via one of:

- **Soft delete:** keep the record but flag it (`is_deleted = true`, `deleted_at = …`), and make
  sure that change bumps `updated_at` so the delta carries it.
- **A deletions feed / tombstones:** an endpoint or dataset listing **ids deleted since *T***.
- **Reconciliation via full load:** if neither is possible, we detect deletions by comparing a
  periodic full snapshot — workable, but coarser and more expensive. Tell us if this is the only
  option.

Either way we need the **record's stable id** (see [Identity & keys](04-identity-and-keys.md#every-fact-needs-its-own-record-id-too)) to act on the deletion.

## Full loads & historical data

### Why full loads matter

Even with great deltas, OEAI needs to pull **everything** sometimes:

- **Initial backfill** when the module is first built.
- **Rebase / reconciliation** to correct any accumulated drift or missed deltas.
- **Reprocessing** when we improve the Silver/Gold logic and replay Bronze history.

So your interface should allow retrieving the **complete dataset**, not only "recent" or
"current" records — via a full‑export route, an unbounded date range, or a warehouse/DB snapshot.

### Historical depth — multiple academic years

Education analytics is inherently longitudinal — trends, cohort progression, year‑on‑year
comparison, predictive models. **Provide as much history as you hold**, and tell us how far back
it goes.

- A useful module typically wants **several academic years** of history (3+ where available).
- If your system only retains "current year" or purges at rollover, **say so explicitly** — it's a
  significant constraint we'll design around (e.g. by snapshotting before each rollover).
- Let us pull history in **date‑bounded chunks** (e.g. per academic year or per month) so large
  backfills are reliable and resumable — see chunking below.

### The academic‑year boundary

OEAI derives an **academic year** for dated facts (England's runs **1 September – 31 August** by
default). You don't need to compute it — just give us **accurate event dates** and we derive the
year. If your data spans non‑standard term/year boundaries, tell us.

## Large volumes & chunking

For big historical pulls or high‑volume schools:

- Support **date‑range filtering** so we can request bounded windows (e.g. one month or one
  academic year at a time).
- Combine with **pagination** (cursor preferred) so each window streams reliably.
- Make windows **idempotent and resumable** — re‑requesting the same window returns the same data,
  so a retry after a failure is safe.

## Putting it together — the load contract

A source that's a joy to build against typically offers:

| Capability | Concretely |
|---|---|
| Incremental pull | `GET /attendance?updated_after=2026-06-23T00:00:00Z` (or OData `$filter`, or a CDC cursor) |
| Full pull | `GET /attendance?from=2019-09-01&to=2026-06-24` (or a warehouse snapshot of the full table) |
| Deletes | `is_deleted` flag **or** `GET /attendance/deletions?since=…` |
| Stable per‑record id | `attendance_session_id` on every row |
| Date‑bounded chunks | `from`/`to` honoured, paged, resumable |

If you can't offer all of it yet, that's fine — we'll design around what you have. The
[Questionnaire](../templates/data-provision-questionnaire.md) captures exactly which of these you
support so we pick the right strategy.

---

**Next:** [7 · API design & quality →](07-api-design-and-quality.md)
