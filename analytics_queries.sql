-- ==============================================================================
-- LOGISTICS WORKFORCE & DRIVER RETENTION ANALYTICS QUERIES
-- Database Dialect: Standard SQL (compatible with PostgreSQL / BigQuery)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- QUERY 1: Regional Distribution Center Headcount and FTE Breakdown
-- Purpose: Provides a breakdown of total headcount and active FTEs by facility
--          and work shift. For logistics planning, each active employee is 
--          counted as 1.0 FTE.
-- ------------------------------------------------------------------------------
SELECT 
    Facility_Location,
    COUNT(CASE WHEN Employment_Status = 'Active' THEN 1 END) AS Active_Headcount,
    COUNT(CASE WHEN Employment_Status = 'Active' AND Shift = 'Day' THEN 1 END) AS FTE_Day_Shift,
    COUNT(CASE WHEN Employment_Status = 'Active' AND Shift = 'Night' THEN 1 END) AS FTE_Night_Shift,
    COUNT(CASE WHEN Employment_Status = 'Active' AND Shift = 'Weekend' THEN 1 END) AS FTE_Weekend_Shift,
    -- Total Active FTE (Assuming 1.0 FTE per active employee)
    SUM(CASE WHEN Employment_Status = 'Active' THEN 1.0 ELSE 0.0 END) AS Total_Active_FTE,
    -- Terminated headcount for context
    COUNT(CASE WHEN Employment_Status = 'Terminated' THEN 1 END) AS Terminated_Count
FROM 
    synthetic_logistics_hr_data
GROUP BY 
    Facility_Location
ORDER BY 
    Active_Headcount DESC;


-- ------------------------------------------------------------------------------
-- QUERY 2: Driver 90-Day Turnover Rate Calculation by Facility
-- Purpose: Calculates the percentage of CDL Class-A Drivers who separated 
--          within 90 days of their hire date. Early-stage turnover is a critical
--          logistics metric indicating onboarding or recruiting misalignment.
-- ------------------------------------------------------------------------------
WITH DriverCohorts AS (
    SELECT 
        Facility_Location,
        Employee_ID,
        Employment_Status,
        Separation_Reason,
        Tenure_Years,
        -- Convert tenure in years to days for precise 90-day logic
        (Tenure_Years * 365.25) AS Tenure_Days
    FROM 
        synthetic_logistics_hr_data
    WHERE 
        Job_Role = 'CDL Class-A Driver'
)
SELECT 
    Facility_Location,
    COUNT(*) AS Total_Drivers_Hired,
    COUNT(CASE WHEN Employment_Status = 'Terminated' AND Tenure_Days <= 90 THEN 1 END) AS Terminations_Within_90_Days,
    ROUND(
        100.0 * COUNT(CASE WHEN Employment_Status = 'Terminated' AND Tenure_Days <= 90 THEN 1 END) / COUNT(*), 
        2
    ) AS Driver_90_Day_Turnover_Rate_Pct
FROM 
    DriverCohorts
GROUP BY 
    Facility_Location
ORDER BY 
    Driver_90_Day_Turnover_Rate_Pct DESC;


-- ------------------------------------------------------------------------------
-- QUERY 3: High-Risk Retention Cohort Identification
-- Purpose: Identifies Warehouse Associates and CDL Drivers with under 2 years of 
--          tenure who left voluntarily. This group represents the highest risk 
--          and cost replacement category in enterprise supply chain operations.
-- ------------------------------------------------------------------------------
SELECT 
    Facility_Location,
    Job_Role,
    COUNT(*) AS Total_Employees_In_Cohort,
    COUNT(CASE WHEN Employment_Status = 'Active' THEN 1 END) AS Active_Count,
    COUNT(CASE WHEN Employment_Status = 'Terminated' AND Separation_Reason = 'Voluntary' AND Tenure_Years < 2.0 THEN 1 END) AS Voluntary_Exits_Under_2_Years,
    ROUND(
        100.0 * COUNT(CASE WHEN Employment_Status = 'Terminated' AND Separation_Reason = 'Voluntary' AND Tenure_Years < 2.0 THEN 1 END) / COUNT(*), 
        2
    ) AS Early_Voluntary_Turnover_Rate_Pct,
    ROUND(AVG(CASE WHEN Employment_Status = 'Active' THEN Tenure_Years END), 2) AS Avg_Tenure_Active_Years,
    ROUND(AVG(Annual_Salary), 2) AS Avg_Annual_Salary
FROM 
    synthetic_logistics_hr_data
WHERE 
    Job_Role IN ('CDL Class-A Driver', 'Warehouse Associate')
GROUP BY 
    Facility_Location, 
    Job_Role
ORDER BY 
    Early_Voluntary_Turnover_Rate_Pct DESC;


-- ------------------------------------------------------------------------------
-- QUERY 4: Safety Compliance & Turnover Correlation Analysis
-- Purpose: Analyzes if higher safety violation counts correlate with higher 
--          turnover rates and involuntary separations.
-- ------------------------------------------------------------------------------
SELECT 
    Safety_Violation_Count,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN Employment_Status = 'Terminated' THEN 1 END) AS Total_Terminations,
    COUNT(CASE WHEN Employment_Status = 'Terminated' AND Separation_Reason = 'Involuntary' THEN 1 END) AS Involuntary_Terminations,
    COUNT(CASE WHEN Employment_Status = 'Terminated' AND Separation_Reason = 'Voluntary' THEN 1 END) AS Voluntary_Terminations,
    ROUND(
        100.0 * COUNT(CASE WHEN Employment_Status = 'Terminated' THEN 1 END) / COUNT(*), 
        2
    ) AS Overall_Turnover_Rate_Pct,
    ROUND(
        100.0 * COUNT(CASE WHEN Employment_Status = 'Terminated' AND Separation_Reason = 'Involuntary' THEN 1 END) / COUNT(*), 
        2
    ) AS Involuntary_Turnover_Rate_Pct
FROM 
    synthetic_logistics_hr_data
GROUP BY 
    Safety_Violation_Count
ORDER BY 
    Safety_Violation_Count ASC;
