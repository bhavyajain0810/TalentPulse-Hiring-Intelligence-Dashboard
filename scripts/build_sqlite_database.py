"""
Build a SQLite database from TalentPulse CSV files.

Usage:
    python scripts/build_sqlite_database.py
"""
from pathlib import Path
import csv
import sqlite3

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
DB_PATH = ROOT / "sql" / "talentpulse.sqlite"
SCHEMA_PATH = ROOT / "sql" / "01_create_schema.sql"

TABLE_FILES = {
    "candidates": "candidates.csv",
    "jobs": "jobs.csv",
    "recruiters": "recruiters.csv",
    "sources": "sources.csv",
    "applications": "applications.csv",
    "stage_history": "stage_history.csv",
    "interviews": "interviews.csv",
    "offers": "offers.csv",
    "candidate_feedback": "candidate_feedback.csv",
    "skill_catalog": "skill_catalog.csv",
    "candidate_skills": "candidate_skills.csv",
}

def import_csv(cursor, table_name, csv_path):
    with csv_path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)
        if not rows:
            return
        cols = reader.fieldnames
    placeholders = ",".join(["?"] * len(cols))
    col_sql = ",".join(cols)
    cursor.executemany(
        f"INSERT INTO {table_name} ({col_sql}) VALUES ({placeholders})",
        [[row[col] if row[col] != "" else None for col in cols] for row in rows],
    )

def main():
    if DB_PATH.exists():
        DB_PATH.unlink()
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.executescript(SCHEMA_PATH.read_text(encoding="utf-8"))
    for table, filename in TABLE_FILES.items():
        import_csv(cur, table, RAW / filename)
    conn.commit()
    conn.close()
    print(f"Created {DB_PATH}")

if __name__ == "__main__":
    main()
