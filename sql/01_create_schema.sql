-- TalentPulse: Talent Acquisition Analytics Command Center
-- SQLite schema. Import CSVs from data/raw or use the prebuilt talentpulse.sqlite.

DROP TABLE IF EXISTS candidate_skills;
DROP TABLE IF EXISTS candidate_feedback;
DROP TABLE IF EXISTS offers;
DROP TABLE IF EXISTS interviews;
DROP TABLE IF EXISTS stage_history;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS skill_catalog;
DROP TABLE IF EXISTS candidates;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS recruiters;
DROP TABLE IF EXISTS sources;

CREATE TABLE candidates (
    candidate_id TEXT PRIMARY KEY,
    candidate_name TEXT NOT NULL,
    gender TEXT,
    location TEXT,
    education TEXT,
    graduation_year INTEGER,
    experience_years REAL,
    current_company TEXT,
    linkedin_url TEXT,
    email_domain TEXT,
    notice_period_days INTEGER,
    willing_to_relocate TEXT
);

CREATE TABLE jobs (
    job_id TEXT PRIMARY KEY,
    job_title TEXT NOT NULL,
    department TEXT,
    location TEXT,
    employment_type TEXT,
    openings INTEGER,
    priority TEXT,
    posted_date DATE,
    target_close_date DATE,
    salary_band TEXT,
    required_experience_years REAL,
    required_skills TEXT
);

CREATE TABLE recruiters (
    recruiter_id TEXT PRIMARY KEY,
    recruiter_name TEXT NOT NULL,
    team TEXT,
    region TEXT
);

CREATE TABLE sources (
    source_id TEXT PRIMARY KEY,
    source_name TEXT NOT NULL,
    source_type TEXT
);

CREATE TABLE applications (
    application_id TEXT PRIMARY KEY,
    candidate_id TEXT NOT NULL,
    job_id TEXT NOT NULL,
    source_id TEXT NOT NULL,
    recruiter_id TEXT NOT NULL,
    application_date DATE NOT NULL,
    current_stage TEXT,
    application_status TEXT,
    candidate_location TEXT,
    expected_ctc_lpa REAL,
    notice_period_days INTEGER,
    is_diverse_candidate TEXT,
    last_updated DATE,
    FOREIGN KEY(candidate_id) REFERENCES candidates(candidate_id),
    FOREIGN KEY(job_id) REFERENCES jobs(job_id),
    FOREIGN KEY(source_id) REFERENCES sources(source_id),
    FOREIGN KEY(recruiter_id) REFERENCES recruiters(recruiter_id)
);

CREATE TABLE stage_history (
    application_id TEXT NOT NULL,
    stage_name TEXT NOT NULL,
    stage_rank INTEGER,
    stage_date DATE,
    stage_status TEXT,
    days_in_previous_stage INTEGER,
    FOREIGN KEY(application_id) REFERENCES applications(application_id)
);

CREATE TABLE interviews (
    interview_id TEXT PRIMARY KEY,
    application_id TEXT NOT NULL,
    interview_round TEXT,
    interview_date DATE,
    interviewer TEXT,
    technical_score INTEGER,
    communication_score INTEGER,
    culture_fit_score INTEGER,
    interview_result TEXT,
    interview_mode TEXT,
    FOREIGN KEY(application_id) REFERENCES applications(application_id)
);

CREATE TABLE offers (
    offer_id TEXT PRIMARY KEY,
    application_id TEXT NOT NULL,
    offer_date DATE,
    offered_ctc_lpa REAL,
    offer_status TEXT,
    joining_date DATE,
    decline_reason TEXT,
    FOREIGN KEY(application_id) REFERENCES applications(application_id)
);

CREATE TABLE candidate_feedback (
    feedback_id TEXT PRIMARY KEY,
    application_id TEXT NOT NULL,
    feedback_date DATE,
    candidate_rating INTEGER,
    candidate_sentiment TEXT,
    feedback_text TEXT,
    FOREIGN KEY(application_id) REFERENCES applications(application_id)
);

CREATE TABLE skill_catalog (
    skill_id TEXT PRIMARY KEY,
    skill_name TEXT NOT NULL,
    skill_category TEXT,
    business_priority INTEGER
);

CREATE TABLE candidate_skills (
    candidate_id TEXT NOT NULL,
    skill_id TEXT NOT NULL,
    skill_name TEXT,
    skill_level TEXT,
    years_of_experience REAL,
    FOREIGN KEY(candidate_id) REFERENCES candidates(candidate_id),
    FOREIGN KEY(skill_id) REFERENCES skill_catalog(skill_id)
);

CREATE INDEX idx_applications_job ON applications(job_id);
CREATE INDEX idx_applications_candidate ON applications(candidate_id);
CREATE INDEX idx_applications_source ON applications(source_id);
CREATE INDEX idx_applications_recruiter ON applications(recruiter_id);
CREATE INDEX idx_stage_history_app ON stage_history(application_id);
CREATE INDEX idx_offers_app ON offers(application_id);
CREATE INDEX idx_interviews_app ON interviews(application_id);
