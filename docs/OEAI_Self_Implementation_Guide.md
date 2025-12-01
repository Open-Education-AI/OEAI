# OEAI module and package self-implementation guide

## Purpose and scope

This guide provides process guidance for Multi-Academy Trusts who independently implement OEAI module and package updates from the [OEAI public GitHub repository](https://github.com/Open-Education-AI/OEAI) into their own Microsoft Fabric Data Lake environments.

> **Important disclaimer**: Open Education AI (OEAI) accepts no liability for any issues, data loss, service disruption, or other consequences arising from the self-implementation of modules, packages, or any other assets from this public repository. By implementing these assets independently, you accept full responsibility for understanding, testing, and maintaining them within your own environment. If you require assured implementation with support and liability coverage, please contact Edequity AI about the **OEAI Module Assurance Service**.

---

## Before you begin

### Prerequisites checklist

Before attempting any module or package update, ensure you have:

- [ ] Administrative access to your Microsoft Fabric workspace
- [ ] Access to your Azure Key Vault (or equivalent secrets management)
- [ ] The OEAI Python Reference library installed and configured
- [ ] A development or staging Lakehouse separate from production
- [ ] Sufficient Fabric capacity units available for testing
- [ ] Git installed for version comparison (recommended)
- [ ] Documentation of your current module versions

### Understanding your environment

You must have a clear picture of your current state:

1. **Document your current module versions** — Record which version of each OEAI module you are currently running. This information should be in your Lakehouse metadata or notebook comments.

2. **Map your downstream dependencies** — OEAI has no visibility into what you have built on top of our modules. Before updating, identify all notebooks, dataflows, semantic models, Power BI reports, and custom code that depend on the module you are updating. This is critical for impact assessment.

3. **Record your configuration settings** — Export or document all environment-specific configurations including API endpoints, Key Vault references, school mappings, and any customisations you have made to the standard OEAI code.

---

## Phase 1: Review the release

### Step 1.1: Identify what has changed

When you see updates in the GitHub repository:

1. Navigate to the relevant module folder (e.g., `/modules/wonde/`)
2. Read the `README.md` file carefully — this contains version history and change descriptions
3. Review the `CHANGELOG.md` if present for detailed change notes
4. Use GitHub's compare feature or `git diff` to see exact code changes between versions

### Step 1.2: Classify the changes

Categorise each change as one of the following:

| Change type | Description | Risk level |
|-------------|-------------|------------|
| **Schema addition** | New columns or tables added | Low — backward compatible |
| **Schema modification** | Existing column data types or names changed | High — may break downstream |
| **Schema removal** | Columns or tables removed | Critical — will break downstream |
| **Logic change** | Processing logic updated without schema change | Medium — may affect data values |
| **Configuration change** | New or changed configuration parameters required | Medium — requires config update |
| **Dependency change** | New Python packages or updated versions required | Low to medium |
| **Performance optimisation** | Efficiency improvements only | Low |

### Step 1.3: Identify breaking changes

A breaking change is any modification that will cause your existing downstream processes to fail or produce incorrect results. Common breaking changes include:

- Renamed tables or columns
- Changed data types (e.g., string to integer)
- Removed fields that your reports depend on
- Changed primary or foreign key structures
- Modified date formats or granularity
- Changed nullability constraints

**Action required**: For each breaking change identified, document:
- What the change is
- Which of your downstream assets are affected
- What modifications those assets will require
- Estimated effort to remediate

---

## Phase 2: Prepare your environment

### Step 2.1: Create a safe testing space

Never test updates directly in your production Lakehouse.

1. **Create a development Lakehouse** if you don't have one — this should mirror your production structure but contain either sample data or a subset of production data
2. **Clone your current notebooks** to a test folder within your workspace
3. **Document your rollback point** — note the commit hash or version you are currently running

### Step 2.2: Verify configuration readiness

Check that all required configuration elements are in place:

**Azure Key Vault / Secrets**
- API keys are current and valid
- Service principal credentials have not expired
- All required secrets referenced in the new module version exist

**Environment variables and parameters**
- Review any new parameters introduced in the update
- Ensure your configuration files or notebook parameters include all required values
- Verify default values are appropriate for your Trust

**Network and access**
- Confirm your Fabric workspace can reach any new external endpoints
- Verify firewall rules permit required traffic
- Test API connectivity independently before running the full module

### Step 2.3: Update dependencies

If the module update requires new or updated Python packages:

1. Review the requirements in the module documentation
2. Test package installation in your development environment first
3. Be aware of package version conflicts with your existing custom code
4. Document any packages you install for future reference

---

## Phase 3: Implement in development

### Step 3.1: Deploy the updated code

1. Download the updated module files from GitHub
2. Copy the files to your development Lakehouse, preserving the OEAI folder structure
3. Update any import statements if file paths have changed
4. Review and update your configuration parameters as required

### Step 3.2: Run initial tests

Execute the module in your development environment:

1. **Syntax check** — Ensure the notebook runs without Python errors
2. **Configuration validation** — Verify all parameters are correctly read
3. **API connectivity** — Confirm external data sources are accessible
4. **Partial execution** — If possible, run against a single school or limited date range first

### Step 3.3: Validate output data

After successful execution, verify the results:

**Schema validation**
- Compare the output table schemas against the previous version
- Confirm new columns exist where expected
- Verify data types match the documentation

**Data quality checks**
- Row counts should be sensible (not zero, not unexpectedly inflated)
- Key fields should not contain nulls where they shouldn't
- Date ranges should align with your extraction parameters
- Sample records should contain plausible values

**Regression testing**
- For logic changes, compare output values against the previous version
- Identify any unexplained differences in calculated fields
- Verify aggregations and transformations produce expected results

---

## Phase 4: Test downstream impact

### Step 4.1: Identify all consumers

Create a dependency map of everything that reads from the tables produced by this module:

- Other OEAI packages
- Custom notebooks you have written
- Dataflows and data pipelines
- Semantic models (Power BI datasets)
- Power BI reports and dashboards
- Third-party integrations or exports
- Scheduled jobs or alerting systems

### Step 4.2: Test each consumer

For each downstream consumer identified:

1. **Point it at your development output** — Temporarily reconfigure to read from your test tables
2. **Execute the consumer** — Run notebooks, refresh dataflows, process semantic models
3. **Verify results** — Check for errors, warnings, and unexpected output
4. **Document issues** — Record any failures or anomalies for remediation

### Step 4.3: Remediate breaking changes

For consumers that fail due to breaking changes:

1. Update column references to match new schema
2. Adjust data type handling if conversions have changed
3. Modify joins if key structures have changed
4. Update filters or predicates if field values have changed
5. Re-test after each remediation

**Important**: Do not proceed to production until all downstream consumers pass testing.

---

## Phase 5: Deploy to production

### Step 5.1: Schedule your deployment window

Choose an appropriate time for production deployment:

- Outside of school hours if possible
- Not during critical reporting periods (census, examinations, Ofsted preparation)
- When technical staff are available to monitor and respond
- With sufficient time before the next scheduled data refresh

### Step 5.2: Create backups

Before modifying production:

1. **Export current notebook versions** — Keep copies of all notebooks you will overwrite
2. **Snapshot key tables** — If your Lakehouse supports time travel, note the timestamp; otherwise, copy critical tables
3. **Document current state** — Screenshot or export current report values for comparison

### Step 5.3: Execute the deployment

1. Deploy the updated module code to your production Lakehouse
2. Update configuration parameters as tested
3. Execute the module and monitor for errors
4. Verify output tables are populated correctly

### Step 5.4: Deploy downstream updates

If you made changes to downstream consumers during testing:

1. Deploy updated notebooks, dataflows, and semantic models
2. Execute in dependency order (upstream before downstream)
3. Refresh Power BI reports
4. Verify end-user dashboards display correctly

---

## Phase 6: Post-implementation validation

### Step 6.1: Verify data integrity

After production deployment:

- Confirm row counts are as expected
- Check that incremental loads haven't duplicated or lost data
- Verify key metrics match pre-deployment baselines (within expected variance)
- Test date filters and parameters are working correctly

### Step 6.2: Monitor for issues

During the first week after deployment:

- Monitor scheduled job completion
- Check for any new error messages in notebook outputs
- Gather feedback from report consumers
- Watch for unexpected data values in dashboards

### Step 6.3: Document the deployment

Update your internal records:

- Record the new module version now running in production
- Document any customisations or configuration changes made
- Update your dependency maps if new relationships were created
- Note any lessons learned for future deployments

---

## Rollback procedure

If critical issues are discovered after production deployment:

### Immediate rollback steps

1. **Stop any running jobs** that depend on the updated module
2. **Restore previous notebook versions** from your backup copies
3. **Restore configuration** to previous parameter values
4. **Re-run the previous module version** to regenerate clean output tables
5. **Refresh downstream consumers** using the restored data

### If table data is corrupted

If time travel is available in your Lakehouse:
```sql
RESTORE TABLE schema.table_name TO TIMESTAMP AS OF 'YYYY-MM-DD HH:MM:SS'
```

If time travel is not available:
1. Restore from your table backups
2. Or re-run the previous module version from the beginning of the affected date range

### Post-rollback actions

- Document what went wrong
- Report issues to OEAI via GitHub Issues if the problem appears to be with the module itself
- Do not re-attempt deployment until the root cause is understood and addressed

---

## Getting help

### Self-service resources

- **GitHub Issues**: Report bugs or ask questions at [https://github.com/Open-Education-AI/OEAI/issues](https://github.com/Open-Education-AI/OEAI/issues)
- **README files**: Each module contains documentation specific to that component
- **OEAI Python Reference**: Core library documentation is available in the repository

### OEAI Module Assurance Service

If you require professional support with guaranteed service levels and liability coverage, Edequity AI offers the **OEAI Module Assurance Service** that includes:

- Managed implementation of all module and package updates
- Pre-deployment testing against your environment
- Coordination of breaking changes with your custom developments
- Priority support for implementation issues
- Liability coverage for update-related incidents

Contact Edequity AI to discuss your requirements.

---

## Appendix: Implementation checklist

Use this checklist for each module or package update:

### Pre-implementation
- [ ] Current version documented
- [ ] Change type classified (schema, logic, config, etc.)
- [ ] Breaking changes identified
- [ ] Downstream dependencies mapped
- [ ] Development environment prepared
- [ ] Configuration verified
- [ ] Dependencies updated

### Development testing
- [ ] Module executes without errors
- [ ] Output schema validated
- [ ] Data quality checks passed
- [ ] Downstream consumers tested
- [ ] Breaking changes remediated

### Production deployment
- [ ] Deployment window scheduled
- [ ] Backups created
- [ ] Module deployed successfully
- [ ] Downstream updates deployed
- [ ] Data integrity verified

### Post-implementation
- [ ] Monitoring in place
- [ ] User feedback gathered
- [ ] Documentation updated
- [ ] Lessons learned recorded

---

*Last updated: December 2025*  
*This guide is provided as-is without warranty. OEAI accepts no liability for implementations performed using this guidance.*
