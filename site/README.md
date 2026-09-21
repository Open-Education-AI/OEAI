# OEAI documentation site (Material for MkDocs)

A browsable documentation site generated from the Markdown and notebooks already in this repository. Nothing is authored here: the repository is the source, and every page carries an "edit on GitHub" link back to it.

```bash
pip install -r site/requirements.txt
mkdocs serve -f site/mkdocs.yml     # http://127.0.0.1:8000/OEAI/
mkdocs build -f site/mkdocs.yml     # builds to ../OEAI-site (outside the repository)
```

What the site includes, from `site/mkdocs.yml`:

* README, roadmap and known issues as the landing pages.
* The reference architecture and partner integration guidance as tabbed sections, with Mermaid diagrams rendered.
* Every module and package README, and every notebook rendered read-only by `mkdocs-jupyter` so the code is browsable without opening Fabric.
* The self-implementation guide, use-case template page, contributing and security pages.

Binary assets, the Power BI report, reference data and scripts are excluded.

Deployment is the `docs-site` GitHub Actions workflow to GitHub Pages. Enable Pages on the repository (Settings → Pages → Source: GitHub Actions) for it to publish. A members-only edition would be the same build placed behind an access layer (for example Cloudflare Pages with Access); GitHub Pages cannot gate a public repository's site.
