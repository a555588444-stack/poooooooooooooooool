from pathlib import Path
import re

sql_dir = Path(__file__).resolve().parents[1] / "sql"
files = sorted([p for p in sql_dir.glob("*.sql") if p.name != "full_schema.sql"])

text = "\n".join(p.read_text(encoding="utf-8") for p in files)

table_count = len(re.findall(r"\bCREATE\s+TABLE\b", text, flags=re.IGNORECASE))
index_count = len(re.findall(r"\bCREATE\s+INDEX\b", text, flags=re.IGNORECASE))
view_count = len(re.findall(r"\bCREATE\s+(?:MATERIALIZED\s+)?VIEW\b", text, flags=re.IGNORECASE))
trigger_count = len(re.findall(r"\bCREATE\s+TRIGGER\b", text, flags=re.IGNORECASE))

print("SQL files:", len(files))
print("CREATE TABLE count:", table_count)
print("CREATE INDEX count:", index_count)
print("CREATE VIEW/MATERIALIZED VIEW count:", view_count)
print("CREATE TRIGGER count:", trigger_count)

assert table_count >= 40, "Expected at least 40 tables for a large social schema"
assert index_count >= 10, "Expected at least 10 indexes"
assert view_count >= 3, "Expected at least 3 views/materialized views"
assert trigger_count >= 4, "Expected at least 4 triggers"
print("Structure verification passed ✅")
