# TalentPulse: AI-Assisted Talent Acquisition Analytics Dashboard

TalentPulse is an end-to-end Talent Acquisition Analytics Command Center built to analyze recruitment funnel health, source quality, recruiter productivity, skill demand, offer conversion, candidate drop-off, and hiring velocity. It uses a realistic synthetic hiring dataset and demonstrates Excel dashboards, SQL analysis, Power BI design, DAX measures, and Python automation.

This project is designed as a believable but impressive portfolio project for a Talent Acquisition Analytics Intern role: practical enough to build in 1–2 days, but deep enough to discuss in interviews.


## Business Problem

Talent Acquisition teams often receive applications from many sources such as LinkedIn, referrals, campus hiring, job portals, GitHub search, and recruiter outreach. Without a clean analytics layer, teams struggle to answer questions such as:

- Which hiring sources bring the highest-quality candidates?
- Where do candidates drop off in the hiring funnel?
- Which recruiters are handling the strongest pipelines?
- Which roles or departments take the longest to close?
- Which skills are most common among shortlisted or hired candidates?
- How can weekly hiring reporting be automated?

TalentPulse solves this by combining a structured SQL database, Excel KPI workbook, Power BI dashboard design, and Python automation scripts.

## Project Features

- Synthetic recruitment dataset with candidates, jobs, recruiters, sources, applications, stage history, interviews, offers, feedback, and skills.
- SQL schema with normalized tables and foreign keys.
- Advanced SQL queries using joins, CTEs, window functions, aggregations, conversion analysis, source scoring, recruiter productivity, and time-to-hire logic.
- Excel workbook with KPI dashboard, lookup formulas, formula-driven summaries, charts, conditional formatting, and monthly reporting sheets.
- Power BI implementation blueprint with dashboard pages and DAX measures.
- Python automation scripts to rebuild the SQLite database, refresh KPI CSVs, and generate a weekly TA report.

## Tech Stack

- Excel: formulas, dashboards, conditional formatting, lookup workflows, KPI reporting
- SQL: SQLite, joins, CTEs, window functions, funnel analysis, aggregation
- Power BI: data modeling, dashboard design, DAX measures, KPI visualizations
- Python: CSV automation, SQLite refresh, weekly report generation
- Analytics: recruitment funnel optimization, source quality scoring, recruiter productivity, offer acceptance analysis

## Dataset Overview

| Table | Description |
|---|---|
| `candidates.csv` | Candidate demographics, education, experience, location, relocation preference |
| `jobs.csv` | Job roles, departments, locations, openings, priority, required skills |
| `recruiters.csv` | Recruiter ownership metadata |
| `sources.csv` | Application sources and source categories |
| `applications.csv` | Main application records with stage/status/source/recruiter details |
| `stage_history.csv` | Stage-level movement from Applied to Hired |
| `interviews.csv` | Interview rounds, scores, results, interview mode |
| `offers.csv` | Offer status, offered compensation, joining date, decline reason |
| `candidate_feedback.csv` | Candidate experience feedback |
| `skill_catalog.csv` | Skills and skill categories |
| `candidate_skills.csv` | Candidate-to-skill mapping |

Current generated dataset size:
- 500 candidates
- 720 applications
- 3,057 stage history events
- 726 interview records
- 192 offers
- 3,511 candidate skill records

## Dashboard Pages for Power BI

1. Executive Overview
2. Hiring Funnel
3. Source & Channel Analytics
4. Recruiter Productivity
5. Skills & Talent Intelligence
6. Diversity, Location & Department Insights

## Key Business Insights Generated

- Source Quality Score identifies channels that produce better downstream conversion, not just higher volume.
- Funnel analysis highlights stage-wise drop-off from Applied to Hired.
- Recruiter Productivity Score balances hires, offers, interviews, shortlisted candidates, and workload.
- Time-to-hire analysis helps prioritize roles or departments requiring process improvement.
- Skill intelligence reveals skills associated with better shortlisting and hiring outcomes.
- Weekly reporting script creates a reusable TA update from refreshed KPI files.

## Repository Structure

```text
TalentPulse_Hiring_Intelligence_Dashboard/
├── data/
│   ├── raw/
│   └── processed/
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_analysis_queries.sql
│   └── talentpulse.sqlite
├── excel/
│   └── TalentPulse_Excel_Analytics_Workbook.xlsx
├── powerbi/
│   ├── DAX_Measures.md
│   ├── PowerBI_Dashboard_Blueprint.md
│   ├── Data_Model.md
│   └── powerbi_theme.json
├── scripts/
│   ├── build_sqlite_database.py
│   ├── refresh_kpis.py
│   ├── weekly_ta_report.py
│   └── generate_sample_data.py
├── docs/
│   ├── project_plan.md
│   ├── data_dictionary.md
│   ├── excel_workbook_plan.md
│   ├── implementation_roadmap.md
│   ├── resume_bullets.md
│   ├── interview_talking_points.md
│   ├── github_linkedin_description.md
│   └── insights_report.md
└── screenshots/
    └── excel_dashboard_preview.png
```

## How to Run

### 1. Rebuild SQLite database

```bash
python scripts/build_sqlite_database.py
```

### 2. Run SQL analysis

Open `sql/talentpulse.sqlite` in DB Browser for SQLite, SQLiteStudio, VS Code SQLite extension, or Python, then execute queries from:

```text
sql/02_analysis_queries.sql
```

### 3. Refresh KPI CSVs

```bash
python scripts/refresh_kpis.py
```

### 4. Generate weekly report

```bash
python scripts/weekly_ta_report.py
```

### 5. Open Excel Workbook

Open:

```text
excel/TalentPulse_Excel_Analytics_Workbook.xlsx
```

Review:
- Dashboard
- Applications
- Lookup_Examples
- Source_Analytics
- Recruiter_Analytics
- Monthly_Report
- Skills_Intelligence

### 6. Build Power BI Dashboard

In Power BI Desktop:
1. Get data from CSV folder: `data/raw/` and `data/processed/`
2. Create relationships using `powerbi/Data_Model.md`
3. Add DAX measures from `powerbi/DAX_Measures.md`
4. Build dashboard pages using `powerbi/PowerBI_Dashboard_Blueprint.md`
