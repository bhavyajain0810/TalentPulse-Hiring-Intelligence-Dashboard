# Power BI DAX Measures

Assumption: Main fact table is `applications`. Related tables include `stage_history`, `offers`, `sources`, `recruiters`, `jobs`, and `candidates`.

## Core Volume Measures

```DAX
Total Applications =
COUNTROWS(applications)

Total Candidates =
DISTINCTCOUNT(applications[candidate_id])

Shortlisted Candidates =
CALCULATE(
    DISTINCTCOUNT(stage_history[application_id]),
    stage_history[stage_name] = "Shortlisted"
)

Interviewed Candidates =
CALCULATE(
    DISTINCTCOUNT(stage_history[application_id]),
    stage_history[stage_name] = "Interview 1"
)

Offers Made =
DISTINCTCOUNT(offers[offer_id])

Hires =
CALCULATE(
    COUNTROWS(applications),
    applications[application_status] = "Hired"
)
```

## Conversion Measures

```DAX
Shortlist Rate =
DIVIDE([Shortlisted Candidates], [Total Applications])

Interview Conversion Rate =
DIVIDE([Interviewed Candidates], [Total Applications])

Offer Rate =
DIVIDE([Offers Made], [Total Applications])

Hire Rate =
DIVIDE([Hires], [Total Applications])

Offer Acceptance Rate =
DIVIDE(
    CALCULATE(COUNTROWS(offers), offers[offer_status] = "Accepted"),
    [Offers Made]
)

Candidate Drop-off Rate =
1 - [Hire Rate]
```

## Time-to-Hire

```DAX
Average Time to Hire =
AVERAGEX(
    FILTER(applications, applications[application_status] = "Hired"),
    DATEDIFF(
        applications[application_date],
        CALCULATE(
            MIN(stage_history[stage_date]),
            stage_history[stage_name] = "Hired"
        ),
        DAY
    )
)
```

## Recruiter Productivity

```DAX
Recruiter Productivity Score =
VAR Apps = [Total Applications]
VAR Shortlisted = [Shortlisted Candidates]
VAR Interviews = [Interviewed Candidates]
VAR Offers = [Offers Made]
VAR Hires = [Hires]
RETURN
DIVIDE(
    (0.40 * Hires) + (0.25 * Offers) + (0.15 * Interviews) + (0.20 * Shortlisted),
    Apps
) * 100
```

## Source Quality

```DAX
Source Quality Score =
VAR Apps = [Total Applications]
VAR ShortlistRate = DIVIDE([Shortlisted Candidates], Apps)
VAR InterviewRate = DIVIDE([Interviewed Candidates], Apps)
VAR HireRateValue = DIVIDE([Hires], Apps)
RETURN
(0.35 * ShortlistRate + 0.35 * InterviewRate + 0.30 * HireRateValue) * 100
```

## Month-over-Month

```DAX
Applications Previous Month =
CALCULATE(
    [Total Applications],
    DATEADD('Calendar'[Date], -1, MONTH)
)

Applications MoM Change =
DIVIDE([Total Applications] - [Applications Previous Month], [Applications Previous Month])

Hires Previous Month =
CALCULATE(
    [Hires],
    DATEADD('Calendar'[Date], -1, MONTH)
)

Hires MoM Change =
DIVIDE([Hires] - [Hires Previous Month], [Hires Previous Month])
```

## Diversity and Location

```DAX
Diverse Candidate Applications =
CALCULATE(
    [Total Applications],
    applications[is_diverse_candidate] = "Yes"
)

Diverse Candidate Share =
DIVIDE([Diverse Candidate Applications], [Total Applications])
```

## Stage Drop-off

```DAX
Stage Reached =
DISTINCTCOUNT(stage_history[application_id])

Previous Stage Reached =
VAR CurrentRank = SELECTEDVALUE(stage_history[stage_rank])
RETURN
CALCULATE(
    DISTINCTCOUNT(stage_history[application_id]),
    FILTER(ALL(stage_history), stage_history[stage_rank] = CurrentRank - 1)
)

Stage Drop-off Rate =
1 - DIVIDE([Stage Reached], [Previous Stage Reached])
```
