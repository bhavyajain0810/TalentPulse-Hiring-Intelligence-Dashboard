# Power BI Dashboard Blueprint

## Data Sources

Import the following CSVs:

Raw:
- candidates.csv
- jobs.csv
- recruiters.csv
- sources.csv
- applications.csv
- stage_history.csv
- interviews.csv
- offers.csv
- candidate_feedback.csv
- skill_catalog.csv
- candidate_skills.csv

Processed:
- hiring_master.csv
- funnel_summary.csv
- source_summary.csv
- recruiter_summary.csv
- monthly_kpis.csv
- skill_demand_summary.csv

## Page 1: Executive Overview

### Objective
Give leadership a quick snapshot of hiring pipeline health.

### Visuals
- KPI cards: Total Applications, Shortlisted, Interviewed, Offers, Hires
- KPI cards: Offer Acceptance Rate, Interview Conversion Rate, Avg Time-to-Hire
- Line chart: Applications and Hires by Month
- Funnel chart: Applied to Hired
- Bar chart: Top 5 Sources by Quality Score
- Slicers: Month, Department, Location, Source Type

## Page 2: Hiring Funnel

### Objective
Identify stage-wise drop-off and bottlenecks.

### Visuals
- Funnel chart by stage
- Bar chart: Drop-off % by stage
- Matrix: Stage by Department
- Decomposition tree: Drop-off by Source, Recruiter, Department, Job Title
- Table: Active applications stuck for 10+ days

## Page 3: Source & Channel Analytics

### Objective
Compare sourcing channels by quality, not just volume.

### Visuals
- Bar chart: Source Quality Score
- Scatter chart: Applications vs Hire Rate
- Matrix: Source Type x Stage
- Line chart: Applications by Source over Month
- KPI cards: Best Source, Highest Hire Rate, Highest Volume Source

## Page 4: Recruiter Productivity

### Objective
Show recruiter workload, conversion, and outcomes.

### Visuals
- Bar chart: Recruiter Productivity Score
- Matrix: Recruiter, Applications, Shortlisted, Interviews, Offers, Hires
- Bar chart: Avg Time-to-Hire by Recruiter
- KPI card: Top recruiter by productivity
- Slicer: Team/Region

## Page 5: Skills & Talent Intelligence

### Objective
Identify high-demand skills and talent availability.

### Visuals
- Bar chart: Top Skills by Applicant Count
- Bar chart: Skills by Hire Rate
- Matrix: Skill Category x Shortlist Rate
- Word cloud if available: skill frequency
- Slicer: Department, Role, Experience Band

## Page 6: Diversity, Location & Department Insights

### Objective
Review pipeline representation and regional sourcing.

### Visuals
- Map: Candidate location
- Bar chart: Application and Hire Rate by Location
- Bar chart: Diverse Candidate Share by Department
- Matrix: Department x Source Type
- KPI card: Diverse Candidate Share
