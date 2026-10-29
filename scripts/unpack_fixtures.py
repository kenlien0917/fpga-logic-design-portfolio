"""Restore the original golden data without third-party dependencies."""
from pathlib import Path
import gzip, hashlib, json
root = Path(__file__).resolve().parent.parent
manifest = json.loads((root / "source-manifest.json").read_text(encoding="utf-8"))
for entry in manifest:
    if entry.get("compression") != "gzip":
        continue
    packed = root / entry["destination"]
    data = gzip.decompress(packed.read_bytes())
    if hashlib.sha256(data).hexdigest() != entry["sha256_original"]:
        raise ValueError("Fixture hash mismatch: " + entry["destination"])
    target = root / entry["restore_path"]
    if target.exists() and target.read_bytes() != data:
        raise FileExistsError("Refusing to overwrite modified fixture: " + str(target))
    target.write_bytes(data)
    print(target.relative_to(root))
