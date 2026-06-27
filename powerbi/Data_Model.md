# Power BI Data Model

## Recommended Relationships

Use `applications` as the central fact table.

| From Table | Column | To Table | Column | Cardinality |
|---|---|---|---|---|
| applications | candidate_id | candidates | candidate_id | Many-to-one |
| applications | job_id | jobs | job_id | Many-to-one |
| applications | source_id | sources | source_id | Many-to-one |
| applications | recruiter_id | recruiters | recruiter_id | Many-to-one |
| stage_history | application_id | applications | application_id | Many-to-one |
| interviews | application_id | applications | application_id | Many-to-one |
| offers | application_id | applications | application_id | Many-to-one |
| candidate_feedback | application_id | applications | application_id | Many-to-one |
| candidate_skills | candidate_id | candidates | candidate_id | Many-to-one |
| candidate_skills | skill_id | skill_catalog | skill_id | Many-to-one |

## Date Table

Create a Calendar table in Power BI:

```DAX
Calendar =
ADDCOLUMNS(
    CALENDAR(DATE(2026,1,1), DATE(2026,12,31)),
    "Year", YEAR([Date]),
    "Month Number", MONTH([Date]),
    "Month", FORMAT([Date], "MMM YYYY"),
    "YearMonth", FORMAT([Date], "YYYY-MM")
)
```

Relationship:
- `Calendar[Date]` to `applications[application_date]`

## Model Notes

- Keep `applications` as the main fact for funnel KPIs.
- Use `stage_history` when stage-level movement dates are required.
- Use `offers` for offer acceptance and compensation analysis.
- Use `candidate_skills` and `skill_catalog` for skill intelligence.
