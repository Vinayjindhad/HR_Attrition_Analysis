# HR Attrition Analysis Dashboard

SQL + Power BI | People Analytics

## Project Overview

Analyzed employee attrition patterns across a 1,200-person workforce dataset to identify high-risk employee segments and key drivers of turnover. Delivered findings via an interactive Power BI dashboard designed for HR leadership and business decision-makers.

---

## Objectives

- Identify departments, job roles, and employee profiles most vulnerable to attrition
- Quantify the impact of factors like overtime, income, tenure, and job satisfaction on turnover
- Build a risk-scoring model using SQL to flag at-risk employees before they leave
- Present insights in a Power BI dashboard for stakeholder consumption

---

## Tools & Technologies

| Tool | Usage |
|------|-------|
| SQL (SQLite) | Data extraction, transformation, and analytical queries |
| Power BI | Interactive dashboard and data visualization |
| Python (Pandas) | Data generation and preprocessing |
| Excel/CSV | Data source format |

---

## Dataset

- **Records:** 1,200 employees
- **Fields:** 18 attributes including Department, JobRole, MonthlyIncome, JobSatisfaction, WorkLifeBalance, OverTime, YearsAtCompany, and Attrition status
- **Departments:** Sales, Engineering, Operations, Finance, Marketing, HR

---

## Key SQL Analyses

### 1. Overall Attrition Rate
```sql
SELECT 
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate_Pct
FROM HR_Attrition;
```
**Result:** 37.9% overall attrition rate across 1,200 employees

---

### 2. Attrition by Department
```sql
SELECT Department, COUNT(*) AS Total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate_Pct
FROM HR_Attrition
GROUP BY Department ORDER BY AttritionRate_Pct DESC;
```
**Result:** Sales (42.1%) and Marketing (40.8%) showed highest attrition; HR (31.1%) lowest

---

### 3. High-Risk Employee Identification
```sql
SELECT EmployeeID, Department, JobRole, MonthlyIncome,
    (CASE WHEN JobSatisfaction <= 2 THEN 1 ELSE 0 END +
     CASE WHEN WorkLifeBalance <= 2 THEN 1 ELSE 0 END +
     CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN MonthlyIncome < 50000 THEN 1 ELSE 0 END +
     CASE WHEN YearsAtCompany <= 2 THEN 1 ELSE 0 END) AS RiskScore
FROM HR_Attrition
WHERE Attrition = 'No'
ORDER BY RiskScore DESC;
```
**Result:** Flagged 87 currently active employees with RiskScore ≥ 3 for proactive HR intervention

---

## Key Findings

| Finding | Insight |
|---------|---------|
| **Overtime drives attrition** | Employees working overtime had 46.1% attrition vs 33.4% for those who don't |
| **Tenure is a critical window** | Employees with 0–2 years tenure had 54.2% attrition — highest of any group |
| **Low satisfaction = high exit** | Employees with Low job satisfaction had 49.5% attrition vs 27.8% for Very High |
| **Income below 50K is high risk** | Sub-50K employees showed 48.3% attrition vs ~35% for higher bands |
| **Sales dept most affected** | Sales had 42.1% attrition — highest among all 6 departments |

---

## Power BI Dashboard (Screenshots)

> *Dashboard includes:*
> - KPI cards: Total Employees, Attrition Count, Attrition Rate %
> - Bar chart: Attrition by Department
> - Donut chart: Overtime vs Non-Overtime attrition
> - Heatmap: Job Satisfaction × Work-Life Balance attrition matrix
> - Line chart: Attrition by Tenure band
> - Slicer filters: Department, Gender, City, Income Band

---

## Business Recommendations

1. **Introduce an early-tenure retention programme** — focus on employees in their first 2 years with structured onboarding and mentorship
2. **Review overtime policies in Sales and Operations** — overtime is the single largest controllable attrition driver
3. **Conduct quarterly pulse surveys** targeting job satisfaction and work-life balance scores
4. **Salary benchmarking for sub-50K band** — targeted compensation review for the highest-risk income group
5. **Deploy risk score model in HR system** — flag employees with RiskScore ≥ 3 for proactive manager conversations

---

## Files in Repository

```
├── HR_Attrition_Dataset.csv       # Dataset (1,200 records, 18 fields)
├── HR_Attrition_Analysis.sql      # All SQL queries with comments
├── HR_Attrition_Dashboard.pbix    # Power BI dashboard file
└── README.md
```

---

## How to Run

1. Load `HR_Attrition_Dataset.csv` into your SQL environment or Power BI
2. Run queries from `HR_Attrition_Analysis.sql` in sequence
3. Open `HR_Attrition_Dashboard.pbix` in Power BI Desktop
4. Use slicers to filter by Department, City, Gender, or Income Band

---

*Built by Vinay Kumar | [LinkedIn](https://www.linkedin.com/in/vinaykumar2412/) | [GitHub](https://github.com/Vinayjindhad)*
