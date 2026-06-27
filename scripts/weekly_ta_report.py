"""
Generate a simple weekly TA analytics markdown report from processed CSVs.

Usage:
    python scripts/weekly_ta_report.py
"""
from pathlib import Path
import csv
from datetime import datetime

ROOT = Path(__file__).resolve().parents[1]
PROCESSED = ROOT / "data" / "processed"
OUT = ROOT / "docs" / "weekly_ta_report.md"

def load_csv(filename):
    with (PROCESSED / filename).open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))

def main():
    funnel = load_csv("funnel_summary.csv")
    sources = load_csv("source_summary.csv")
    recruiters = load_csv("recruiter_summary.csv")
    monthly = load_csv("monthly_kpis.csv")

    top_sources = sorted(sources, key=lambda r: float(r["source_quality_score"]), reverse=True)[:3]
    top_recruiters = sorted(recruiters, key=lambda r: float(r["productivity_score"]), reverse=True)[:3]
    latest_month = monthly[-1]

    lines = [
        "# Weekly Talent Acquisition Analytics Report",
        "",
        f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M')}",
        "",
        "## Executive Summary",
        f"- Latest month applications: {latest_month['total_applications']}",
        f"- Latest month hires: {latest_month['hires']}",
        f"- Latest month interview conversion rate: {float(latest_month['interview_conversion_rate'])*100:.1f}%",
        "",
        "## Funnel Snapshot",
    ]
    for row in funnel:
        lines.append(f"- {row['stage_name']}: {row['applications_reached']} candidates reached this stage")

    lines.extend(["", "## Top Sources by Quality Score"])
    for row in top_sources:
        lines.append(f"- {row['source_name']}: score {row['source_quality_score']}, hires {row['hires']}")

    lines.extend(["", "## Top Recruiters by Productivity Score"])
    for row in top_recruiters:
        lines.append(f"- {row['recruiter_name']}: score {row['productivity_score']}, hires {row['hires']}")

    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUT}")

if __name__ == "__main__":
    main()
