"""Fail if any notebook is invalid JSON, or carries outputs or execution counts."""
import json
import pathlib
import sys

failures = []
for nb_path in sorted(pathlib.Path(".").rglob("*.ipynb")):
    if ".ipynb_checkpoints" in nb_path.parts or "node_modules" in nb_path.parts:
        continue
    try:
        nb = json.loads(nb_path.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, UnicodeDecodeError) as exc:
        failures.append(f"{nb_path}: not valid JSON ({exc})")
        continue
    for i, cell in enumerate(nb.get("cells", [])):
        if cell.get("outputs"):
            failures.append(f"{nb_path}: cell {i} has outputs (run nbstripout)")
        if cell.get("execution_count") is not None:
            failures.append(f"{nb_path}: cell {i} has an execution count (run nbstripout)")

if failures:
    print("\n".join(failures))
    sys.exit(1)
print("All notebooks clean.")
