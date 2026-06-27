-- TalentPulse SQL Analysis Pack
-- These queries are written for SQLite and work directly with sql/talentpulse.sqlite.

-- 1) Hiring funnel conversion by stage
WITH stage_counts AS (
    SELECT
        stage_name,
        stage_rank,
        COUNT(DISTINCT application_id) AS applications_reached
    FROM stage_history
    GROUP BY stage_name, stage_rank
),
ordered AS (
    SELECT
        stage_name,
        stage_rank,
        applications_reached,
        LAG(applications_reached) OVER (ORDER BY stage_rank) AS previous_stage_count
    FROM stage_counts
)
SELECT
    stage_name,
    stage_rank,
    applications_reached,
    ROUND(100.0 * applications_reached / FIRST_VALUE(applications_reached) OVER (ORDER BY stage_rank), 2) AS pct_of_applied,
    ROUND(100.0 * applications_reached / NULLIF(previous_stage_count, 0), 2) AS conversion_from_previous_stage,
    ROUND(100.0 * (1 - applications_reached * 1.0 / NULLIF(previous_stage_count, 0)), 2) AS dropoff_from_previous_stage
FROM ordered
ORDER BY stage_rank;


-- 2) Source effectiveness: which channels bring quality candidates?
WITH source_funnel AS (
    SELECT
        s.source_name,
        s.source_type,
        COUNT(a.application_id) AS applications,
        COUNT(DISTINCT CASE WHEN sh_short.application_id IS NOT NULL THEN a.application_id END) AS shortlisted,
        COUNT(DISTINCT CASE WHEN sh_int.application_id IS NOT NULL THEN a.application_id END) AS interviewed,
        COUNT(DISTINCT o.application_id) AS offers,
        COUNT(DISTINCT CASE WHEN a.application_status = 'Hired' THEN a.application_id END) AS hires
    FROM applications a
    JOIN sources s ON a.source_id = s.source_id
    LEFT JOIN stage_history sh_short
        ON a.application_id = sh_short.application_id AND sh_short.stage_name = 'Shortlisted'
    LEFT JOIN stage_history sh_int
        ON a.application_id = sh_int.application_id AND sh_int.stage_name = 'Interview 1'
    LEFT JOIN offers o ON a.application_id = o.application_id
    GROUP BY s.source_name, s.source_type
)
SELECT
    source_name,
    source_type,
    applications,
    shortlisted,
    interviewed,
    offers,
    hires,
    ROUND(100.0 * shortlisted / NULLIF(applications, 0), 2) AS shortlist_rate_pct,
    ROUND(100.0 * interviewed / NULLIF(applications, 0), 2) AS interview_rate_pct,
    ROUND(100.0 * hires / NULLIF(applications, 0), 2) AS hire_rate_pct,
    ROUND(
        100 * (
            0.35 * shortlisted * 1.0 / NULLIF(applications, 0) +
            0.35 * interviewed * 1.0 / NULLIF(applications, 0) +
            0.30 * hires * 1.0 / NULLIF(applications, 0)
        ), 2
    ) AS source_quality_score
FROM source_funnel
ORDER BY source_quality_score DESC;


-- 3) Recruiter productivity dashboard query
WITH recruiter_metrics AS (
    SELECT
        r.recruiter_name,
        COUNT(a.application_id) AS applications_owned,
        COUNT(DISTINCT CASE WHEN sh_short.application_id IS NOT NULL THEN a.application_id END) AS shortlisted,
        COUNT(DISTINCT CASE WHEN sh_int.application_id IS NOT NULL THEN a.application_id END) AS interviewed,
        COUNT(DISTINCT o.application_id) AS offers,
        COUNT(DISTINCT CASE WHEN a.application_status = 'Hired' THEN a.application_id END) AS hires,
        AVG(
            CASE WHEN a.application_status = 'Hired'
                 THEN JULIANDAY(sh_hired.stage_date) - JULIANDAY(a.application_date)
            END
        ) AS avg_time_to_hire_days
    FROM applications a
    JOIN recruiters r ON a.recruiter_id = r.recruiter_id
    LEFT JOIN stage_history sh_short
        ON a.application_id = sh_short.application_id AND sh_short.stage_name = 'Shortlisted'
    LEFT JOIN stage_history sh_int
        ON a.application_id = sh_int.application_id AND sh_int.stage_name = 'Interview 1'
    LEFT JOIN stage_history sh_hired
        ON a.application_id = sh_hired.application_id AND sh_hired.stage_name = 'Hired'
    LEFT JOIN offers o ON a.application_id = o.application_id
    GROUP BY r.recruiter_name
)
SELECT
    recruiter_name,
    applications_owned,
    shortlisted,
    interviewed,
    offers,
    hires,
    ROUND(100.0 * hires / NULLIF(applications_owned, 0), 2) AS hire_rate_pct,
    ROUND(avg_time_to_hire_days, 1) AS avg_time_to_hire_days,
    ROUND(100.0 * (0.40 * hires + 0.25 * offers + 0.15 * interviewed + 0.20 * shortlisted) / NULLIF(applications_owned, 0), 2) AS productivity_score
FROM recruiter_metrics
ORDER BY productivity_score DESC;


-- 4) Time-to-hire by department and job family
SELECT
    j.department,
    j.job_title,
    COUNT(DISTINCT a.application_id) AS total_applications,
    COUNT(DISTINCT CASE WHEN a.application_status = 'Hired' THEN a.application_id END) AS hires,
    ROUND(AVG(CASE WHEN a.application_status = 'Hired'
                   THEN JULIANDAY(sh_hired.stage_date) - JULIANDAY(a.application_date)
              END), 1) AS avg_time_to_hire_days
FROM applications a
JOIN jobs j ON a.job_id = j.job_id
LEFT JOIN stage_history sh_hired
    ON a.application_id = sh_hired.application_id AND sh_hired.stage_name = 'Hired'
GROUP BY j.department, j.job_title
HAVING hires > 0
ORDER BY avg_time_to_hire_days ASC;


-- 5) Candidate drop-off by stage with reason proxy
WITH latest_stage AS (
    SELECT
        application_id,
        stage_name,
        stage_rank,
        ROW_NUMBER() OVER (PARTITION BY application_id ORDER BY stage_rank DESC) AS rn
    FROM stage_history
),
dropoff AS (
    SELECT
        ls.stage_name AS dropoff_stage,
        a.application_status,
        COUNT(*) AS candidates
    FROM latest_stage ls
    JOIN applications a ON ls.application_id = a.application_id
    WHERE ls.rn = 1
      AND a.application_status IN ('Rejected', 'Withdrawn')
    GROUP BY ls.stage_name, a.application_status
)
SELECT
    dropoff_stage,
    application_status,
    candidates,
    ROUND(100.0 * candidates / SUM(candidates) OVER (PARTITION BY dropoff_stage), 2) AS pct_within_stage
FROM dropoff
ORDER BY candidates DESC;


-- 6) Offer acceptance analysis
SELECT
    j.department,
    s.source_name,
    COUNT(o.offer_id) AS offers_made,
    SUM(CASE WHEN o.offer_status = 'Accepted' THEN 1 ELSE 0 END) AS offers_accepted,
    ROUND(100.0 * SUM(CASE WHEN o.offer_status = 'Accepted' THEN 1 ELSE 0 END) / NULLIF(COUNT(o.offer_id), 0), 2) AS offer_acceptance_rate_pct,
    ROUND(AVG(o.offered_ctc_lpa), 2) AS avg_offered_ctc_lpa
FROM offers o
JOIN applications a ON o.application_id = a.application_id
JOIN jobs j ON a.job_id = j.job_id
JOIN sources s ON a.source_id = s.source_id
GROUP BY j.department, s.source_name
HAVING offers_made >= 3
ORDER BY offer_acceptance_rate_pct DESC, offers_made DESC;


-- 7) Monthly recruiting trend with MoM application growth
WITH monthly AS (
    SELECT
        STRFTIME('%Y-%m', application_date) AS application_month,
        COUNT(*) AS applications,
        SUM(CASE WHEN application_status = 'Hired' THEN 1 ELSE 0 END) AS hires
    FROM applications
    GROUP BY STRFTIME('%Y-%m', application_date)
),
with_lag AS (
    SELECT
        application_month,
        applications,
        hires,
        LAG(applications) OVER (ORDER BY application_month) AS previous_month_applications
    FROM monthly
)
SELECT
    application_month,
    applications,
    hires,
    ROUND(100.0 * hires / NULLIF(applications, 0), 2) AS hire_rate_pct,
    ROUND(100.0 * (applications - previous_month_applications) / NULLIF(previous_month_applications, 0), 2) AS mom_application_change_pct
FROM with_lag
ORDER BY application_month;


-- 8) Skills and talent intelligence: high-demand skills with better conversion
WITH skill_pipeline AS (
    SELECT
        cs.skill_name,
        COUNT(DISTINCT a.application_id) AS applications,
        COUNT(DISTINCT CASE WHEN sh_short.application_id IS NOT NULL THEN a.application_id END) AS shortlisted,
        COUNT(DISTINCT CASE WHEN a.application_status = 'Hired' THEN a.application_id END) AS hires
    FROM candidate_skills cs
    JOIN applications a ON cs.candidate_id = a.candidate_id
    LEFT JOIN stage_history sh_short
        ON a.application_id = sh_short.application_id AND sh_short.stage_name = 'Shortlisted'
    GROUP BY cs.skill_name
)
SELECT
    skill_name,
    applications,
    shortlisted,
    hires,
    ROUND(100.0 * shortlisted / NULLIF(applications, 0), 2) AS shortlist_rate_pct,
    ROUND(100.0 * hires / NULLIF(applications, 0), 2) AS hire_rate_pct
FROM skill_pipeline
WHERE applications >= 30
ORDER BY hire_rate_pct DESC, applications DESC;


-- 9) Diversity and location insight
SELECT
    a.is_diverse_candidate,
    c.location AS candidate_location,
    COUNT(a.application_id) AS applications,
    SUM(CASE WHEN a.current_stage IN ('Shortlisted','Interview 1','Interview 2','Offer','Hired') THEN 1 ELSE 0 END) AS shortlisted_or_beyond,
    SUM(CASE WHEN a.application_status = 'Hired' THEN 1 ELSE 0 END) AS hires,
    ROUND(100.0 * SUM(CASE WHEN a.application_status = 'Hired' THEN 1 ELSE 0 END) / NULLIF(COUNT(a.application_id), 0), 2) AS hire_rate_pct
FROM applications a
JOIN candidates c ON a.candidate_id = c.candidate_id
GROUP BY a.is_diverse_candidate, c.location
HAVING applications >= 10
ORDER BY hire_rate_pct DESC;


-- 10) Stage aging: applications stuck too long in current stage
WITH latest_stage AS (
    SELECT
        sh.application_id,
        sh.stage_name,
        sh.stage_date,
        ROW_NUMBER() OVER (PARTITION BY sh.application_id ORDER BY sh.stage_rank DESC, sh.stage_date DESC) AS rn
    FROM stage_history sh
),
active_apps AS (
    SELECT
        a.application_id,
        c.candidate_name,
        j.job_title,
        r.recruiter_name,
        latest_stage.stage_name AS current_stage,
        latest_stage.stage_date AS current_stage_date,
        ROUND(JULIANDAY('2026-06-26') - JULIANDAY(latest_stage.stage_date), 0) AS days_in_current_stage
    FROM applications a
    JOIN latest_stage ON a.application_id = latest_stage.application_id AND latest_stage.rn = 1
    JOIN candidates c ON a.candidate_id = c.candidate_id
    JOIN jobs j ON a.job_id = j.job_id
    JOIN recruiters r ON a.recruiter_id = r.recruiter_id
    WHERE a.application_status = 'In Process'
)
SELECT *
FROM active_apps
WHERE days_in_current_stage >= 10
ORDER BY days_in_current_stage DESC;
