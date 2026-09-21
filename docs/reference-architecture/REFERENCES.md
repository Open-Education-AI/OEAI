# Evidence and references

**Checked 6 September 2026**

## Repository and implementation evidence

| Source | Evidence used |
|---|---|
| [OEAI-Private inspected revision](https://github.com/Open-Education-AI/OEAI-Private/tree/78f382d7691b264d67e6e77e81f8d806bcda62e1) | Main-branch code and document baseline; latest inspected commit dated 11 August 2026 |
| [Architecture PR 4](https://github.com/Open-Education-AI/OEAI-Private/pull/4) | Five architecture chapters and index merged on 29 July 2026 |
| [Contribution requirements](https://github.com/Open-Education-AI/OEAI-Private/blob/78f382d7691b264d67e6e77e81f8d806bcda62e1/CONTRIBUTING.md) | Lowercase module/package folders, universal standards, profiles and human review tiers |
| [Fabric Spark profile](https://github.com/Open-Education-AI/OEAI-Private/blob/78f382d7691b264d67e6e77e81f8d806bcda62e1/docs/profiles/fabric-spark.md) | Documented five-notebook target and profile requirements; not proof of universal implementation |
| [Shared utility decision](https://github.com/Open-Education-AI/OEAI-Private/blob/78f382d7691b264d67e6e77e81f8d806bcda62e1/docs/decisions/0009-shared-utility-notebooks-location.md) | Accepted root foundations and `utils/` convention |
| [Licensing decision status](https://github.com/Open-Education-AI/OEAI-Private/blob/78f382d7691b264d67e6e77e81f8d806bcda62e1/docs/decisions/0006-licensing.md) | Proposed status of private usage/contributor-rights arrangements |
| [AI policy](https://github.com/Open-Education-AI/OEAI-Private/blob/78f382d7691b264d67e6e77e81f8d806bcda62e1/AI_POLICY.md) | Human approval, accountability and human-authored Tier 2 ethics notes |
| [Arbor Silver implementation](https://github.com/Open-Education-AI/OEAI-Private/blob/78f382d7691b264d67e6e77e81f8d806bcda62e1/modules/arbor/oeai_mod_arbor_silver.ipynb) | Source-derived `unique_key` values and separate UUID dimension/fact keys |
| [Partner Integration Guide](https://github.com/Open-Education-AI/OEAI-Private/tree/78f382d7691b264d67e6e77e81f8d806bcda62e1/docs/partner-integration) | Existing vendor guidance, method playbooks, questionnaire and OpenAPI artefact |
| [F1 validation](https://github.com/Open-Education-AI/OEAI-Private/blob/main/docs/f1/VALIDATION.md) and [operations](https://github.com/Open-Education-AI/OEAI-Private/blob/main/docs/f1/OPERATIONS.md) | Handover implementation contracts and limits of synthetic validation |
| [Safeguarding governance](https://github.com/Open-Education-AI/OEAI-Private/blob/main/packages/contextual_safeguarding/GOVERNANCE.md) | Default-deny execution, coding and approval requirements in the F1 handover |

Private GitHub links require repository access. This evidence records what was inspected; it does not assert the state of uninspected branches, deployed tenants or subsequent commits. No production tenant audit, certification or policy ratification is supplied by this document review.

## Platform and data-protection guidance

- [Microsoft Fabric SQL analytics endpoint](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-sql-analytics-endpoint): Delta-table discovery and the boundaries of endpoint-only security.
- [Microsoft Fabric workspace identity](https://learn.microsoft.com/en-us/fabric/security/workspace-identity): supported workload identity model and lifecycle.
- [ICO personal data breach guidance](https://ico.org.uk/for-organisations/report-a-breach/personal-data-breach/personal-data-breaches-a-guide/): processor/controller notification duties.
- [ICO special-category data guidance](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/lawful-basis/special-category-data/what-is-special-category-data/): distinguishing legal categories from internal sensitivity classifications.
- [ICO controller and processor definitions](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/controllers-and-processors/controllers-and-processors/what-are-controllers-and-processors/): roles depend on actual activity; a controller’s own employees are not a separate processor.
- [ICO storage limitation](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-protection-principles/a-guide-to-the-data-protection-principles/storage-limitation/): purpose-specific retention and the absence of universal statutory retention periods.

The controller and its DPO must determine the obligations and conditions applicable to the proposed processing. Ethics approval is an additional safeguarding-package requirement and does not replace that assessment.

## Research provenance

For research developed beyond the Contextual Safeguarding pilot, see Matthew Woodruff, *Ethical AI-based Contextual Safeguarding: A Machine Learning Approach for Explainable Predictive Risk Assessment Models in Education*, PhD thesis, University of Surrey, repository publication 29 May 2026: [DOI 10.15126/thesis.902067](https://doi.org/10.15126/thesis.902067). The [package reference](https://github.com/Open-Education-AI/OEAI-Private/blob/main/packages/contextual_safeguarding/REFERENCES.md) explains the distinction between this pilot and later thesis contributions. No thesis result or previous research approval establishes approval of a new operational setting.
