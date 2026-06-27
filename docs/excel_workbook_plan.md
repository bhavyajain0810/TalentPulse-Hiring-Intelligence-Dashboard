# Excel Workbook Plan

Workbook: `excel/TalentPulse_Excel_Analytics_Workbook.xlsx`

## Sheets

### README
Explains the project purpose, dataset, and workbook usage.

### Applications
Main application-level data model. This is the Excel equivalent of a cleaned fact table. It can be filtered by:
- Month
- Source
- Recruiter
- Job title
- Department
- Current stage
- Application status

### Dashboard
Formula-driven KPI dashboard using:
- Total applications
- Shortlisted candidates
- Interviewed candidates
- Offers made
- Hires
- Offer acceptance rate
- Interview conversion rate
- Average time-to-hire
- Diverse candidate share
- Pipeline drop-off

### Lookup_Examples
Demonstrates strong Excel formula usage:
- XLOOKUP for application-level lookup
- COUNTIFS for source and monthly metrics
- IFERROR for safe metric calculations
- TEXT for month formatting

### Source_Analytics
Source/channel summary with applications, shortlisted, interviewed, offers, hires, conversion rates, and source quality score.

### Recruiter_Analytics
Recruiter-level productivity summary.

### Monthly_Report
Month-wise applications, shortlist, interview, offers, hires, and MoM trend.

### Skills_Intelligence
Skill demand and conversion summary.

## Excel Formulas to Showcase

```excel
=COUNTA(Applications!$A$2:$A$721)
=COUNTIF(Applications!$X$2:$X$721,"Yes")
=COUNTIFS(Applications!$L:$L,$B$10,Applications!$AA:$AA,"Yes")
=IFERROR(B13/B11,0)
=XLOOKUP($B$2,Applications!$A:$A,Applications!$C:$C)
=TEXT(XLOOKUP($B$2,Applications!$A:$A,Applications!$O:$O),"mmm yyyy")
=AVERAGEIF(Applications!$W$2:$W$721,">0")
```

## Pivot Table Ideas

1. Applications by Month and Department
2. Source vs Current Stage
3. Recruiter vs Hires/Offers
4. Job Title vs Time-to-Hire
5. Skill Name vs Shortlist Rate

## Conditional Formatting

- Source Quality Score: color scale
- Recruiter Productivity Score: color scale
- Skill Shortlist Rate: data bars
- Funnel Drop-off: highlight high drop-off stages

## Dashboard Design

The Excel dashboard is intentionally lightweight and interview-friendly. It proves that the same data model can support manual Excel reporting and scalable Power BI dashboards.
