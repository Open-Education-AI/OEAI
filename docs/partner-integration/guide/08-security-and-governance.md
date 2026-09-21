# 8 · Security & governance

Education data is sensitive — it includes children's personal data and often **special‑category**
data (safeguarding, health, SEND). This chapter sets out the security and data‑protection
expectations for sharing it with OEAI. None of it is onerous; most of it is good practice you
likely already follow. It complements (doesn't replace) the formal data‑sharing agreement for a
given integration.

> **Principle.** Share the **minimum** data needed, over **secure** channels, under a **clear
> agreement**, with **read‑only revocable** access and an **audit trail** — and keep the school in
> control throughout.

## Who's who (data‑protection roles)

- The **school / trust is the data controller** — it owns the data and the decision to share it.
- **OEAI — and any delivery partner operating it — acts as a processor** for the trust, handling
  data on its instructions.
- **You (the vendor)** are typically a controller or processor for the data in your system; the
  share to OEAI happens **on the trust's authority**.

The practical upshot: the **school authorises** the integration, the data‑sharing terms are
agreed, and your interface enforces the agreed scope. You should expect a **data‑sharing /
processing agreement** to be in place before live pupil data flows.

## Lawful basis & data minimisation

- Share data for the **agreed, specified purpose** only — the analytics/AI use cases in the
  agreement — not "everything, just in case".
- Apply **data minimisation**: expose the capability to share broadly, but make it easy to share
  **only the schools, datasets, and fields in scope** (see
  [What data to provide → scopes](03-what-data-to-provide.md#selection-of-data-scopes)).
- Be especially careful with **special‑category data** (safeguarding, medical, SEND,
  ethnicity/religion). Only include it where it's genuinely in scope and lawful, and make it
  separately scopable so it can be excluded when it isn't.

## Access security (recap)

The access model from [Authentication & authorisation](05-authentication-and-authorisation.md), in
governance terms:

- **Read‑only** — OEAI never writes to your system.
- **Least privilege & scoped** — per‑school/per‑trust, only the agreed datasets/fields.
- **Revocable by the school at any time**, within your system.
- **Dedicated service identity** — attributable, never a shared human login.
- **Secrets stored in a managed vault**, never in code or email; **shared over a secure channel**.

## Transport & storage security

- **Encryption in transit** — **TLS 1.2 or higher** for all API/DB/transfer connections;
  **SSH/SFTP** (not FTP) for files.
- **Encryption at rest** — OEAI stores ingested data in encrypted cloud storage. Under
  **DataLake Builder** that is the **trust's own** cloud tenant; under a managed service it is the
  delivery partner's managed platform.
- **No credentials in email or tickets** — use a secrets manager or encrypted exchange.

## Data residency & sub‑processors

- Tell us **where your data is hosted/processed** (region). OEAI generally keeps UK education data
  in **UK/EEA** regions; flag if yours sits elsewhere so we can address it in the agreement.
- Disclose any **sub‑processors** in your path that would touch the shared data.
- Under **DataLake Builder**, ingestion and storage happen inside the **trust's own** cloud
  tenant — useful for residency, and worth noting in your assessment.

## Audit, logging & incident handling

- **You** should be able to log and report **what was accessed, by whom, and when** — schools
  increasingly ask for this, and it underpins trust.
- **OEAI** logs its ingestion runs (per school, per entity, per run) for audit and reconciliation.
- Agree an **incident / breach notification** path both ways: if either side detects a security or
  data issue affecting the shared data, who is told, how fast.

## Retention & deletion

- We retain ingested data per the trust's agreement and retention policy; raw Bronze is kept for
  audit and reprocessing within that policy.
- If a school offboards or revokes access, we stop ingesting and handle existing data per the
  agreement. Your side should make **revocation** clean (see above).

## Certifications & assurance (helpful to share)

If you hold relevant certifications — **ISO 27001**, **Cyber Essentials / Plus**, SOC 2, a
completed **DfE Data Protection** / supplier assessment, or a DPIA for your product — mention them
in your documentation. They speed the school's and OEAI's due diligence considerably.

## The reassurance schools expect

When OEAI (or you) explain this integration to a school, this is the message — design so it's
true:

> *Access is **read‑only**. Data is transferred **securely** using your system's approved
> authentication. **Only the data needed** for the agreed reporting is accessed. Access can be
> **revoked by the school at any time**. The school remains in control of its data.*

---

That completes the core guidance. Continue to the **method playbooks** for concrete, mechanism‑specific design notes:

- [REST API →](method-playbooks/rest-api.md)
- [OData →](method-playbooks/odata.md)
- [Data warehouse & secure share →](method-playbooks/data-warehouse-and-secure-share.md)
- [SQL database (JDBC) →](method-playbooks/sql-database.md)
- [Files, SFTP & CSV →](method-playbooks/files-sftp-csv.md)
