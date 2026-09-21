# Changelog — Partner Integration Guidance

All notable changes to this guidance. The Technical Authority owns this document and changes it on
the evidence; material changes are recorded here.

**Versioning.** A change that alters what a partner must do to be *ready* is a major change; a
clarification, worked example, or added playbook is a minor change.

## [1.0] — 2026-09-21

Initial issue — **Pack 1 of the partner enablement path: Readiness**. Reviewed by the Technical
Authority in July 2026 and published to the public OEAI repository on 21 September 2026 as the
standard for EdTech integration with OEAI.

### Added

- **Core guidance** (8 chapters): overview and what "good" looks like; choosing a data‑provision
  method; what data to provide (atomic records, entities, scopes); identity & keys (URN, UPN, source
  ids); authentication & authorisation; incremental & historical loads, including deletes; API design
  & quality; security & governance.
- **Five method playbooks**: REST API (the recommended default), OData, data warehouse & secure share
  (Snowflake / BigQuery / Delta Sharing), SQL database (JDBC), and files/SFTP/CSV — the last of these
  explicitly framed as a temporary bootstrap that forces a later module redevelopment.
- **Reference REST API contract** (OpenAPI 3.1) that partners can generate server stubs from, so a
  good integration is the path of least resistance rather than an exam.
- **Data Provision Questionnaire** (the partner completes) and the **partner‑specific guidance
  template** (the Technical Authority completes) — the mechanism by which per‑partner guidance is
  issued from this generic standard.
- **Appendices**: canonical entities & fields, readiness checklist, glossary, and a worked example
  using a fictional partner system.
