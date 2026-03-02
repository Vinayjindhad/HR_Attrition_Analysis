-- ============================================================
-- PROJECT: HR Attrition Analysis
-- Author: Vinay Kumar
-- Tool: SQL (SQLite / MySQL compatible)
-- Dataset: 1,200 employee records across 6 departments
-- ============================================================

-- ── 1. OVERALL ATTRITION RATE ──────────────────────────────
SELECT 
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate_Pct
FROM HR_Attrition;

-- ── 2. ATTRITION BY DEPARTMENT ─────────────────────────────
SELECT 
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate_Pct
FROM HR_Attrition
GROUP BY Department
ORDER BY AttritionRate_Pct DESC;

-- ── 3. ATTRITION BY OVERTIME ────────────────────────────────
SELECT 
    OverTime,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate_Pct
FROM HR_Attrition
GROUP BY OverTime;

-- ── 4. ATTRITION BY JOB SATISFACTION ───────────────────────
SELECT 
    JobSatisfaction,
    CASE JobSatisfaction 
        WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium' 
        WHEN 3 THEN 'High' WHEN 4 THEN 'Very High' 
    END AS SatisfactionLabel,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate_Pct
FROM HR_Attrition
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- ── 5. ATTRITION BY INCOME BAND ────────────────────────────
SELECT 
    CASE 
        WHEN MonthlyIncome < 50000 THEN 'Below 50K'
        WHEN MonthlyIncome BETWEEN 50000 AND 100000 THEN '50K - 1L'
        WHEN MonthlyIncome BETWEEN 100001 AND 150000 THEN '1L - 1.5L'
        ELSE 'Above 1.5L'
    END AS IncomeBand,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate_Pct
FROM HR_Attrition
GROUP BY IncomeBand
ORDER BY AttritionRate_Pct DESC;

-- ── 6. ATTRITION BY TENURE BAND ────────────────────────────
SELECT 
    CASE 
        WHEN YearsAtCompany <= 2 THEN '0-2 Years'
        WHEN YearsAtCompany BETWEEN 3 AND 5 THEN '3-5 Years'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 Years'
        ELSE '10+ Years'
    END AS TenureBand,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate_Pct
FROM HR_Attrition
GROUP BY TenureBand
ORDER BY AttritionRate_Pct DESC;

-- ── 7. HIGH-RISK EMPLOYEE SEGMENTS ─────────────────────────
-- Employees with 3+ attrition risk factors
SELECT 
    EmployeeID, Department, JobRole, MonthlyIncome,
    JobSatisfaction, WorkLifeBalance, OverTime, YearsAtCompany,
    (
        CASE WHEN JobSatisfaction <= 2 THEN 1 ELSE 0 END +
        CASE WHEN WorkLifeBalance <= 2 THEN 1 ELSE 0 END +
        CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN MonthlyIncome < 50000 THEN 1 ELSE 0 END +
        CASE WHEN YearsAtCompany <= 2 THEN 1 ELSE 0 END
    ) AS RiskScore
FROM HR_Attrition
WHERE Attrition = 'No'
  AND (
        CASE WHEN JobSatisfaction <= 2 THEN 1 ELSE 0 END +
        CASE WHEN WorkLifeBalance <= 2 THEN 1 ELSE 0 END +
        CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN MonthlyIncome < 50000 THEN 1 ELSE 0 END +
        CASE WHEN YearsAtCompany <= 2 THEN 1 ELSE 0 END
      ) >= 3
ORDER BY RiskScore DESC;

-- ── 8. DEPARTMENT-WISE AVERAGE SALARY & SATISFACTION ───────
SELECT 
    Department,
    ROUND(AVG(MonthlyIncome), 0) AS AvgMonthlyIncome,
    ROUND(AVG(JobSatisfaction), 2) AS AvgJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AvgWorkLifeBalance,
    ROUND(AVG(TrainingTimesLastYear), 1) AS AvgTrainingTimes
FROM HR_Attrition
GROUP BY Department
ORDER BY AvgMonthlyIncome DESC;

-- ── 9. GENDER-WISE ATTRITION COMPARISON ────────────────────
SELECT 
    Gender,
    COUNT(*) AS Total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate_Pct,
    ROUND(AVG(MonthlyIncome), 0) AS AvgIncome
FROM HR_Attrition
GROUP BY Gender;

-- ── 10. TOP 5 JOB ROLES BY ATTRITION ───────────────────────
SELECT 
    JobRole,
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate_Pct
FROM HR_Attrition
GROUP BY JobRole, Department
ORDER BY AttritionRate_Pct DESC
LIMIT 10;
