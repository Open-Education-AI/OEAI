# Contributing

Thank you for your interest in Open Education AI. This repository is the **public, GA-released** face of the framework; most engineering activity happens in the private repository, [OEAI-Private](https://github.com/Open-Education-AI/OEAI-Private), which OEAI members can access.

## Ways to contribute

| You want to… | Do this |
|---|---|
| Report a defect in a published asset | Open a [bug report](https://github.com/Open-Education-AI/OEAI/issues/new?template=bug-report.md) |
| Request a new module (a source system OEAI should integrate) | Open a [module request](https://github.com/Open-Education-AI/OEAI/issues/new?template=module-request.md); it enters stage 1 of the Module Build Process |
| Improve documentation in this repository | Open a pull request against `main` |
| Build or improve a module or package | Join OEAI and contribute through the private repository; see below |
| Make your product's data available to OEAI | Read the [partner integration guidance](docs/partner-integration/README.md) and complete the [questionnaire](docs/partner-integration/templates/data-provision-questionnaire.md) |
| Propose a change to the standard schema | Raise it with the Technical Authority; changes go through a Request for Comment |

## How assets reach this repository

Modules and packages are developed wherever the contributor chooses, contributed to the private repository by pull request against a fixed quality bar, reviewed (two reviews and a data-ethics note for anything predictive, machine-learning or safeguarding-related), piloted with trusts, and then promoted here at **GA** when the Technical Authority is satisfied on quality, security and testing evidence. Promotion is a copy: the private repository mirrors this repository's structure.

Contributions are held to **public-release hygiene** from the first commit, wherever they are made:

* No credentials of any kind. Secrets are referenced by Key Vault name only.
* No customer, trust or school names in code, configuration, comments or notebook cells. Use placeholders.
* No personal data, including notebook outputs, sample data and test fixtures. Synthetic data only.
* No internal identifiers or URLs.
* Notebook outputs stripped (`nbstripout`).

## Pull requests to this repository

1. Branch from `main`: `docs/{slug}` for documentation, `fix/{slug}` for corrections.
2. Use conventional commit prefixes: `docs:`, `fix:`, `chore:`.
3. Complete the pull request template, including the security and privacy checklist. CI runs a secret scan, notebook hygiene checks and a relative-link check.
4. A code owner reviews and squash-merges.

## AI assistance

AI tools may be used to help author and review contributions. The human author owns every line and reviews every AI-assisted change before submission; declare AI assistance in the pull request. AI never decides what is merged.

## Licence

By contributing to this repository you agree that your contribution is licensed under the [Apache License 2.0](LICENSE).
