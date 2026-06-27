# Data Dictionary

## candidates.csv

| Column | Type | Description |
|---|---|---|
| candidate_id | Text | Unique candidate identifier |
| candidate_name | Text | Synthetic candidate name |
| gender | Text | Gender grouping for diversity analysis |
| location | Text | Candidate city |
| education | Text | Highest education/degree |
| graduation_year | Integer | Graduation year |
| experience_years | Decimal | Years of experience |
| current_company | Text | Current/previous company |
| linkedin_url | Text | Synthetic LinkedIn URL |
| email_domain | Text | Email domain category |
| notice_period_days | Integer | Notice period |
| willing_to_relocate | Text | Relocation preference |

## jobs.csv

| Column | Type | Description |
|---|---|---|
| job_id | Text | Unique job identifier |
| job_title | Text | Role title |
| department | Text | Department/function |
| location | Text | Job location |
| employment_type | Text | Internship or full-time |
| openings | Integer | Number of openings |
| priority | Text | Role priority |
| posted_date | Date | Job posting date |
| target_close_date | Date | Target closure date |
| salary_band | Text | Compensation band |
| required_experience_years | Decimal | Minimum experience |
| required_skills | Text | Semicolon-separated required skills |

## applications.csv

| Column | Type | Description |
|---|---|---|
| application_id | Text | Unique application identifier |
| candidate_id | Text | Candidate foreign key |
| job_id | Text | Job foreign key |
| source_id | Text | Source foreign key |
| recruiter_id | Text | Recruiter foreign key |
| application_date | Date | Date applied |
| current_stage | Text | Latest stage reached |
| application_status | Text | Hired, Rejected, Withdrawn, In Process |
| candidate_location | Text | Candidate location snapshot |
| expected_ctc_lpa | Decimal | Expected compensation |
| notice_period_days | Integer | Notice period snapshot |
| is_diverse_candidate | Text | Yes/No grouping |
| last_updated | Date | Last update date |

## stage_history.csv

| Column | Type | Description |
|---|---|---|
| application_id | Text | Application foreign key |
| stage_name | Text | Applied, Screened, Shortlisted, Interview 1, Interview 2, Offer, Hired |
| stage_rank | Integer | Ordered stage rank |
| stage_date | Date | Date candidate entered stage |
| stage_status | Text | Completed, Active, Rejected, Withdrawn |
| days_in_previous_stage | Integer | Days spent before entering stage |

## interviews.csv

| Column | Type | Description |
|---|---|---|
| interview_id | Text | Unique interview identifier |
| application_id | Text | Application foreign key |
| interview_round | Text | Interview 1 or Interview 2 |
| interview_date | Date | Interview date |
| interviewer | Text | Panel type |
| technical_score | Integer | Technical score |
| communication_score | Integer | Communication score |
| culture_fit_score | Integer | Culture fit score |
| interview_result | Text | Selected, Rejected, Hold |
| interview_mode | Text | Video, In-person, Phone |

## offers.csv

| Column | Type | Description |
|---|---|---|
| offer_id | Text | Unique offer identifier |
| application_id | Text | Application foreign key |
| offer_date | Date | Offer date |
| offered_ctc_lpa | Decimal | Offered CTC |
| offer_status | Text | Accepted, Declined, Pending |
| joining_date | Date | Joining date if accepted |
| decline_reason | Text | Decline reason if rejected |
