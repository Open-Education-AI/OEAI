# 5 · Authentication & authorisation

This chapter covers **how OEAI proves who it is** (authentication) and **what it is allowed to
see** (authorisation/scoping). The watchwords are **read‑only, least‑privilege, scoped, and
revocable**. The school owns the data and the access decision; your job is to make their decision
enforceable and safe.

## Authentication methods we support

OEAI can integrate with any of these. Listed roughly in order of preference for a new design:

| Method | Notes | Good for |
|---|---|---|
| **OAuth 2.0 (client credentials)** | Machine‑to‑machine; short‑lived bearer tokens from a token endpoint; supports scopes. Our preferred modern default. | REST / OData |
| **API key (+ secret)** | Simple and effective if keys are **per‑school/per‑tenant**, scoped, and rotatable. Send via header, not query string. | REST / OData |
| **Username + password (Basic)** | Workable over TLS; prefer a dedicated service account, not a person's login. | OData / legacy APIs |
| **Mutual TLS / signed requests** | Strong where supported. | High‑assurance APIs |
| **Warehouse share grant** | A read‑only role/share in Snowflake/BigQuery/Databricks scoped to specific objects. | Warehouse / secure share |
| **Database service account** | Read‑only DB user limited to specific schemas/views; ideally on a replica. | SQL / JDBC |
| **SSH key pair** | For SFTP; key‑based auth, not passwords. | Files / SFTP |

Whatever the method, OEAI authenticates as a **dedicated, named service identity** — never a
shared human account — so access is attributable and independently revocable.

## Authorisation: scope to exactly what's agreed

Authentication gets us in; **authorisation decides what we can see**. Design so access can be
constrained on every axis from [ch.3](03-what-data-to-provide.md#selection-of-data-scopes):

- **Read‑only, always.** OEAI never needs to write, update, or delete in your system. Grant read
  scopes only. If your model only offers read+write roles, that's a gap to flag.
- **Least privilege.** Access only the **datasets/endpoints** in the agreement — not "everything
  the token can reach". Prefer fine‑grained scopes (e.g. `attendance:read`, `behaviour:read`) over
  one all‑access scope.
- **Per‑school or per‑trust scoping.** A credential should see only the schools in its agreement.
  Two common shapes, both fine:
  - **Per‑school credentials** — one key/secret per school (clean isolation; matches our
    per‑school secrets storage well).
  - **Trust‑level credential + school filter** — one credential that is *server‑side* limited to
    the agreed schools, with a school parameter to select among them.
- **Field‑level restriction where needed** — the ability to withhold sensitive fields not in scope.

## How OEAI stores and handles your credentials

So you can be confident handing over access:

- **Secrets live in a managed secret store** (Azure Key Vault), **never in code, notebooks, or
  config files.** Modules resolve secrets at runtime by name.
- **Per‑school isolation.** Where access is per‑school, each school's secret is stored separately
  (a secret per school), so one school's credentials are never entangled with another's.
- **Secure transfer at handover.** Share credentials over a **secure channel — never plain
  email.** A secrets manager link, a password manager share, or an encrypted exchange are all
  fine; we'll agree the channel with you.
- **Rotation supported.** We can pick up rotated keys/secrets without a code change. Tell us your
  rotation cadence and method; we'll align.
- **Least data retained.** We pull what's in scope on the agreed schedule and nothing more.

## Revocation — the school stays in control

A core reassurance OEAI gives every school, which your design should make true:

> **Access is read‑only, limited to the agreed data, and can be revoked by the school at any time
> within your system.**

Make sure there's a clear, school‑controllable way to **turn access off** — disable the key,
remove the service account, revoke the OAuth client, or withdraw the share — without involving a
lengthy support process. Document who can do it and how.

## Network controls (IP allow‑listing)

If your API or database restricts access by source IP:

- Tell us during requirements; we'll provide OEAI's **egress IP range(s)** for allow‑listing.
- Note that under the **DataLake Builder** model, ingestion may run from the **trust's own**
  cloud tenant, so the egress IPs can differ per deployment — we'll confirm per build.
- Don't rely on IP allow‑listing *instead of* authentication — use it as defence in depth.

## What OEAI does **not** need (please don't grant it)

- ❌ Write/update/delete permissions.
- ❌ Admin or account‑management scopes.
- ❌ Access to schools or datasets outside the agreement.
- ❌ A shared credential also used by humans or other integrations.
- ❌ Long‑lived credentials with no rotation or revocation path.

Granting only what's needed makes the integration easier to approve, audit, and trust — for you
and for the school.

## Quick recommendations by method

- **REST/OData:** OAuth 2.0 client‑credentials with per‑tenant clients and dataset scopes; or
  per‑school API keys in a header. TLS 1.2+ enforced.
- **Warehouse:** a dedicated read‑only role granted on exactly the objects in scope; row‑level
  security by school where supported.
- **SQL:** a read‑only service account limited to specific views/schemas, ideally on a replica;
  no access to base tables you don't intend to share.
- **SFTP:** SSH key‑based auth, a dedicated chroot’d account, per‑trust directory isolation.

---

**Next:** [6 · Incremental & historical loads →](06-incremental-and-historical-loads.md)
