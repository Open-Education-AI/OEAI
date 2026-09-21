"""Fail if a relative Markdown link (or image) points at a path that does not exist."""
import pathlib
import re
import sys
import urllib.parse

LINK = re.compile(r"!?\[[^\]]*\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)")
SKIP_PREFIXES = ("http://", "https://", "mailto:", "#", "tel:")
failures = []

for md in sorted(pathlib.Path(".").rglob("*.md")):
    if "node_modules" in md.parts or ".git" in md.parts:
        continue
    text = md.read_text(encoding="utf-8")
    for match in LINK.finditer(text):
        target = match.group(1)
        if target.startswith(SKIP_PREFIXES):
            continue
        path_part = urllib.parse.unquote(target.split("#", 1)[0])
        if not path_part:
            continue
        resolved = (md.parent / path_part).resolve()
        if not resolved.exists():
            failures.append(f"{md}: {target}")

if failures:
    print("Broken relative links:\n" + "\n".join(failures))
    sys.exit(1)
print("All relative links resolve.")
