# 1-2 Day Build Roadmap

## Day 1: Data + SQL + Excel

### Hour 1: Repository Setup
- Create GitHub repository.
- Add folders: data, sql, excel, powerbi, scripts, docs, screenshots.
- Add README.md and project summary.

### Hour 2: Dataset
- Use the existing synthetic CSVs in `data/raw`.
- Inspect applications, candidates, sources, recruiters, offers, and stage history.
- Confirm relationships using candidate_id, job_id, source_id, recruiter_id, application_id.

### Hour 3: SQL Schema
- Run `python scripts/build_sqlite_database.py`.
- Open `sql/talentpulse.sqlite`.
- Execute schema and analysis queries.

### Hour 4: SQL Analysis
Run and screenshot results for:
- Hiring funnel
- Source effectiveness
- Recruiter productivity
- Time-to-hire
- Skill intelligence
- Offer acceptance

### Hour 5: Excel Workbook
- Open `excel/TalentPulse_Excel_Analytics_Workbook.xlsx`.
- Review formulas in Dashboard and Lookup_Examples.
- Add screenshots of dashboard and formula examples if uploading to GitHub.

## Day 2: Power BI + Documentation + Polish

### Hour 1: Power BI Data Model
- Import CSVs from data/raw and data/processed.
- Create relationships from Data_Model.md.

### Hour 2: DAX Measures
- Add DAX measures from DAX_Measures.md.

### Hour 3: Dashboard Pages
Build pages:
- Executive Overview
- Hiring Funnel
- Source & Channel Analytics
- Recruiter Productivity
- Skills & Talent Intelligence
- Diversity/Location Insights

### Hour 4: Automation
- Run `python scripts/refresh_kpis.py`.
- Run `python scripts/weekly_ta_report.py`.
- Add generated report to docs.

### Hour 5: GitHub Polish
- Add screenshots.
- Add short demo GIF or screenshots.
- Update README with dashboard images.
- Push to GitHub.

## Interview Preparation

Prepare a 90-second explanation:
“I built TalentPulse to show how a TA team can move from raw recruiting data to business-ready insights. I designed a relational dataset, wrote SQL queries for funnel/source/recruiter analysis, built an Excel KPI workbook with lookup and COUNTIFS formulas, designed Power BI pages with DAX measures, and added Python scripts for automated weekly reporting.”
