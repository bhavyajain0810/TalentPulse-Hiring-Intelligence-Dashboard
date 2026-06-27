"""
Refresh processed TalentPulse KPI CSVs from sql/talentpulse.sqlite.

Usage:
    python scripts/refresh_kpis.py
"""
from pathlib import Path
import sqlite3
import csv

ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "sql" / "talentpulse.sqlite"
OUT = ROOT / "data" / "processed"

QUERIES = {
    "funnel_summary.csv": """
        WITH stage_counts AS (
            SELECT stage_name, stage_rank, COUNT(DISTINCT application_id) AS applications_reached
            FROM stage_history
            GROUP BY stage_name, stage_rank
        ),
        ordered AS (
            SELECT stage_name, stage_rank, applications_reached,
                   LAG(applications_reached) OVER (ORDER BY stage_rank) AS prev_count
            FROM stage_counts
        )
        SELECT stage_name, stage_rank, applications_reached,
               ROUND(applications_reached * 1.0 / NULLIF(prev_count, 0), 4) AS stage_conversion_rate,
               ROUND(1 - applications_reached * 1.0 / NULLIF(prev_count, 0), 4) AS dropoff_from_previous
        FROM ordered
        ORDER BY stage_rank;
    """,
    "source_summary.csv": """
        WITH source_funnel AS (
            SELECT s.source_name, s.source_type,
                   COUNT(a.application_id) AS applications,
                   COUNT(DISTINCT CASE WHEN sh_short.application_id IS NOT NULL THEN a.application_id END) AS shortlisted,
                   COUNT(DISTINCT CASE WHEN sh_int.application_id IS NOT NULL THEN a.application_id END) AS interviewed,
                   COUNT(DISTINCT o.application_id) AS offers,
                   COUNT(DISTINCT CASE WHEN a.application_status = 'Hired' THEN a.application_id END) AS hires
            FROM applications a
            JOIN sources s ON a.source_id = s.source_id
            LEFT JOIN stage_history sh_short ON a.application_id = sh_short.application_id AND sh_short.stage_name = 'Shortlisted'
            LEFT JOIN stage_history sh_int ON a.application_id = sh_int.application_id AND sh_int.stage_name = 'Interview 1'
            LEFT JOIN offers o ON a.application_id = o.application_id
            GROUP BY s.source_name, s.source_type
        )
        SELECT source_name, source_type, applications, shortlisted, interviewed, offers, hires,
               ROUND(shortlisted * 1.0 / NULLIF(applications, 0), 4) AS shortlist_rate,
               ROUND(interviewed * 1.0 / NULLIF(applications, 0), 4) AS interview_rate,
               ROUND(hires * 1.0 / NULLIF(applications, 0), 4) AS hire_rate,
               '' AS avg_time_to_hire_days,
               ROUND(100 * (0.35 * shortlisted * 1.0 / NULLIF(applications, 0)
                           +0.35 * interviewed * 1.0 / NULLIF(applications, 0)
                           +0.30 * hires * 1.0 / NULLIF(applications, 0)), 1) AS source_quality_score
        FROM source_funnel
        ORDER BY source_quality_score DESC;
    """,
    "monthly_kpis.csv": """
        WITH monthly AS (
            SELECT STRFTIME('%Y-%m', application_date) AS month,
                   COUNT(*) AS total_applications,
                   SUM(CASE WHEN current_stage IN ('Shortlisted','Interview 1','Interview 2','Offer','Hired') THEN 1 ELSE 0 END) AS shortlisted,
                   SUM(CASE WHEN current_stage IN ('Interview 1','Interview 2','Offer','Hired') THEN 1 ELSE 0 END) AS interviewed,
                   SUM(CASE WHEN current_stage IN ('Offer','Hired') THEN 1 ELSE 0 END) AS offers,
                   SUM(CASE WHEN application_status = 'Hired' THEN 1 ELSE 0 END) AS hires
            FROM applications
            GROUP BY STRFTIME('%Y-%m', application_date)
        ),
        with_lag AS (
            SELECT *, LAG(total_applications) OVER (ORDER BY month) AS previous_month_apps
            FROM monthly
        )
        SELECT month, total_applications, shortlisted, interviewed, offers, hires,
               ROUND(offers * 1.0 / NULLIF(interviewed, 0), 4) AS offer_acceptance_rate,
               ROUND(interviewed * 1.0 / NULLIF(total_applications, 0), 4) AS interview_conversion_rate,
               ROUND(hires * 1.0 / NULLIF(total_applications, 0), 4) AS hire_rate,
               '' AS avg_time_to_hire_days,
               ROUND((total_applications - previous_month_apps) * 1.0 / NULLIF(previous_month_apps, 0), 4) AS application_mom_change
        FROM with_lag
        ORDER BY month;
    """,
}

def write_query(conn, filename, sql):
    cur = conn.execute(sql)
    cols = [d[0] for d in cur.description]
    rows = cur.fetchall()
    with (OUT / filename).open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(cols)
        writer.writerows(rows)

def main():
    OUT.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(DB)
    for filename, query in QUERIES.items():
        write_query(conn, filename, query)
        print(f"Updated {OUT / filename}")
    conn.close()

if __name__ == "__main__":
    main()
