# Dataset Design and Example Rows

## Candidates

| candidate_id | candidate_name | gender | location | education | graduation_year | experience_years | current_company | linkedin_url | email_domain | notice_period_days | willing_to_relocate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CAND0001 | Sakshi Bansal | Female | Mumbai | MCA | 2024 | 0 | HCLTech | https://www.linkedin.com/in/sakshi-bansal-0001/ | company.com | 90 | Yes |
| CAND0002 | Arjun Jain | Male | Chennai | MBA HR | 2022 | 4 | Accenture | https://www.linkedin.com/in/arjun-jain-0002/ | outlook.com | 60 | No |
| CAND0003 | Priya Nair | Female | Jaipur | B.Sc Statistics | 2022 | 1 | Freshworks | https://www.linkedin.com/in/priya-nair-0003/ | gmail.com | 0 | Maybe |

## Jobs

| job_id | job_title | department | location | employment_type | openings | priority | posted_date | target_close_date | salary_band | required_experience_years | required_skills |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| JOB001 | Data Analyst Intern | Data & Analytics | Bangalore | Internship | 12 | High | 2025-11-04 | 2026-04-24 | Entry-6LPA | 0 | Pandas;Python;DAX;Power BI;LLMs |
| JOB002 | Digital Analyst Intern | Marketing | Bangalore | Internship | 2 | High | 2025-11-12 | 2026-02-16 | Intern-33K | 2 | DAX;Dashboarding;Statistics;LLMs |
| JOB003 | Talent Acquisition Analytics Intern | Talent Acquisition | Gurugram | Internship | 5 | Medium | 2026-01-15 | 2026-02-24 | Intern-30K | 0 | Power Automate;Talent Intelligence;Pandas;Dashboarding;Statistics;Excel;Communication |

## Sources

| source_id | source_name | source_type |
| --- | --- | --- |
| SRC001 | LinkedIn | Social |
| SRC002 | Campus Placement Cell | Campus |
| SRC003 | Employee Referral | Referral |

## Recruiters

| recruiter_id | recruiter_name | team | region |
| --- | --- | --- | --- |
| REC001 | Aarushi Rao | Talent Acquisition | APAC |
| REC002 | Kunal Mehra | Talent Acquisition | India |
| REC003 | Priya Menon | Campus Hiring | India |

## Applications

| application_id | candidate_id | job_id | source_id | recruiter_id | application_date | current_stage | application_status | candidate_location | expected_ctc_lpa | notice_period_days | is_diverse_candidate | last_updated |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| APP00001 | CAND0206 | JOB017 | SRC006 | REC003 | 2026-05-17 | Interview 2 | In Process | Kolkata | 11.7 | 45 | Yes | 2026-06-08 |
| APP00002 | CAND0070 | JOB010 | SRC001 | REC005 | 2026-02-26 | Offer | Rejected | Noida | 15.5 | 45 | No | 2026-04-04 |
| APP00003 | CAND0400 | JOB002 | SRC006 | REC006 | 2026-04-22 | Screened | Rejected | Noida | 13.1 | 15 | Yes | 2026-06-01 |

## Stage History

| application_id | stage_name | stage_rank | stage_date | stage_status | days_in_previous_stage |
| --- | --- | --- | --- | --- | --- |
| APP00001 | Applied | 1 | 2026-05-17 | Completed |  |
| APP00001 | Screened | 2 | 2026-05-24 | Completed | 7 |
| APP00001 | Shortlisted | 3 | 2026-06-01 | Completed | 8 |

## Interviews

| interview_id | application_id | interview_round | interview_date | interviewer | technical_score | communication_score | culture_fit_score | interview_result | interview_mode |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| INT00001 | APP00001 | Interview 1 | 2026-06-09 | TA Panel | 96 | 91 | 89 | Selected | Video |
| INT00002 | APP00001 | Interview 2 | 2026-06-16 | Business Panel | 78 | 55 | 57 | Selected | In-person |
| INT00003 | APP00002 | Interview 1 | 2026-03-07 | TA Panel | 79 | 71 | 78 | Selected | Phone |

## Offers

| offer_id | application_id | offer_date | offered_ctc_lpa | offer_status | joining_date | decline_reason |
| --- | --- | --- | --- | --- | --- | --- |
| OFF00001 | APP00002 | 2026-03-22 | 13.3 | Pending |  | Compensation |
| OFF00002 | APP00004 | 2026-06-28 | 11.4 | Accepted | 2026-07-17 |  |
| OFF00003 | APP00010 | 2026-07-16 | 17.6 | Accepted | 2026-08-17 |  |

## Candidate Skills

| candidate_id | skill_id | skill_name | skill_level | years_of_experience |
| --- | --- | --- | --- | --- |
| CAND0001 | SK002 | Excel | Advanced | 2.2 |
| CAND0001 | SK003 | Power BI | Beginner | 4.5 |
| CAND0001 | SK006 | Data Cleaning | Advanced | 5.0 |
