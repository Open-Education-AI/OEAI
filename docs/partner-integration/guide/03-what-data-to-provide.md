# 3 · What data to provide — atomic records, entities & scopes

This chapter is about the **content and shape** of the data, independent of the mechanism that
carries it. Get this right and almost any transport works; get it wrong and the best API in the
world won't help.

## Provide atomic data, not aggregations

**The golden rule.** Give OEAI the **lowest‑grain records you hold** — the individual events,
states, and entities — not pre‑computed summaries.

OEAI's whole job is to standardise atomic data and then derive the aggregates, trends, and
predictions itself. We can always sum atomic records up; we can **never** break an aggregate back
down. A "92% attendance for Year 9 this term" figure is a dead end. The 180,000 individual
session records behind it are the raw material for attendance analytics, persistent‑absence
flags, cohort comparisons, and predictive models.

| Don't send (aggregated) | Do send (atomic) |
|---|---|
| Attendance % per class per term | One row **per pupil, per session (AM/PM), per date**, with the mark |
| Count of behaviour incidents per pupil | One row **per behaviour event**, with date, type, points, location |
| Average assessment score per subject | One row **per pupil, per assessment, per result** |
| Headcount of staff absent this month | One row **per staff absence occurrence** (and per day where you have it) |
| "Current attainment band" | The underlying marks/grades with their dates |

> **Test for atomic grain:** can each row be traced to a single real‑world event or a single
> entity‑at‑a‑point‑in‑time, identified by *who*, *what*, and *when*? If yes, it's atomic. If a
> row represents "many things combined", it's an aggregate — send what's underneath it instead.

### What atomic grain looks like by domain

Typical grains we map into the canonical fact tables (yours will differ — send your equivalent):

| Domain | Atomic grain | Becomes |
|---|---|---|
| Attendance | One row per student per session (AM/PM) per date | `fact_AttendanceSession` |
| Behaviour / achievement | One row per behaviour or achievement event | `fact_Behaviour` |
| Assessment | One row per student per assessment per result | `fact_Assessment` |
| Exclusions/suspensions | One row per exclusion/suspension occurrence | `fact_Exclusion` |
| Safeguarding | One row per incident/log entry | domain fact table |
| Staff absence | One row per absence occurrence (and per day if held) | `fact_StaffAbsence` / `fact_StaffAbsenceDay` |

## Entities & domains — what to expose

OEAI organises data around a small number of **canonical entities** and the **facts** that
reference them. When scoping what your system provides, think in these terms:

- **Organisations** — schools/establishments. (→ `dim_Organisation`)
- **Students/pupils** — the people the facts are about. (→ `dim_Student`)
- **Staff** — where relevant (HR, safeguarding, teaching). (→ `dim_Staff`)
- **Domain facts** — the events/results your system actually records (attendance, behaviour,
  assessment, wellbeing, safeguarding, contracts, absence, etc.).
- **Reference/lookup data** — the code lists that decode your facts (see below).

You do **not** need to provide every entity — only the ones your system is the source of truth
for. A reading‑intervention app provides *students it works with* and *reading‑session facts*; it
does **not** provide the authoritative student demographics or staff records (the MIS does that).
OEAI joins your facts to the trust's existing student and organisation dimensions **via shared
identifiers** — which is why [Identity & keys](04-identity-and-keys.md) is the next chapter.

See [Appendix A](../appendices/A-canonical-entities-and-fields.md) for the canonical entity fields
we map into.

## Selection of data scopes

"Scope" means **which slices of data are in the agreement** — and it operates on several axes.
Design your interface so each axis can be **selected/filtered**, ideally server‑side:

| Scope axis | Why it matters | What to support |
|---|---|---|
| **Organisation** | A trust onboards specific schools; access must be limited to them | Filter by school (URN/establishment/your school id); per‑school credentials *or* a school parameter |
| **Entity / dataset** | Only some datasets are in scope (e.g. attendance + behaviour, not medical) | Independently selectable endpoints/tables/datasets per entity |
| **Field / column** | Data minimisation — share only fields needed for the agreed purpose | Be able to include/exclude sensitive fields; document every field so we can choose |
| **Time window** | Backfill vs daily delta; agreed retention | Filter by date range and by "changed since" (see [ch.6](06-incremental-and-historical-loads.md)) |
| **Population** | Sometimes only certain year groups/cohorts are in scope | Filter by cohort where applicable |

The guiding principle is **data minimisation**: expose the *capability* to share broadly, but make
it easy to share *only what's agreed*. The school decides scope; your interface should make their
choice enforceable.

## Field‑level guidance

When designing the records themselves:

- **Send raw values, not interpretations.** Provide the actual mark/code/score and let OEAI apply
  meaning. If you also have a derived/interpreted value, send both — clearly named.
- **Send codes *and* their labels.** If a record has `attendance_mark = "L"`, also make
  `"Late (before registers closed)"` resolvable — either inline or via a reference list (below).
- **Don't pre‑filter or pre‑clean destructively.** Null is information. Send what you hold,
  including blanks and "unknowns"; we handle quality in Silver. Don't drop rows you think are
  uninteresting.
- **Use explicit, stable field names** and document each one (name, type, meaning, example,
  nullable?). See [API design & quality](07-api-design-and-quality.md).
- **Dates and times in ISO 8601, UTC where possible** (`2026-06-24` / `2026-06-24T08:35:00Z`).
  State the timezone and whether timestamps are event time or record‑update time.
- **Booleans and enumerations explicit** — avoid overloading strings with magic values; document
  the full set of allowed values.
- **Numbers as numbers**, not strings; state units (days, hours, %, currency) and decimal places.

## Reference & lookup data (don't forget the code lists)

Your facts are full of codes — attendance marks, behaviour types, absence reasons, assessment
scales, role identifiers. OEAI needs the **decode tables** to make them meaningful and to map them
to national standards (e.g. DfE census categories). Provide your **reference/lookup data** as
first‑class datasets:

- Each code list as its own retrievable dataset (code, description, and any grouping/category).
- Stable codes — if a code's *meaning* changes, that's a new code, not a redefinition.
- Where your codes already align to a national standard (DfE CBDS, Ed‑Fi, SIF‑UK), tell us which.

## Where statutory / national alignment helps

OEAI maps your data toward UK education standards (DfE CBDS, the School Workforce Census, Ed‑Fi,
SIF‑UK) so it's comparable across sources. You don't have to adopt these — but if your fields
already align to them, **say so in your documentation**; it removes ambiguity and speeds the
Silver mapping. [Appendix A](../appendices/A-canonical-entities-and-fields.md) notes where the
canonical schema references these standards.

---

**Next:** [4 · Identity & keys →](04-identity-and-keys.md)
