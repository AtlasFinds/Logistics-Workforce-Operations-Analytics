# Logistics Workforce & Driver Retention Analytics Dashboard

An executive-ready data project and interactive portal designed to diagnose, monitor, and mitigate employee turnover, driver attrition, and safety risks within a large-scale supply chain logistics and transportation network.

## Business Objective
Logistics and freight enterprises face industry-wide driver shortages and high front-line turnover. Replacing CDL drivers and warehouse operators costs businesses thousands of dollars in recruitment, onboarding, training, and lost capacity. The objective of this project is to:
1. **Analyze workforce distribution** and shift allocation across major Regional Distribution Centers (RDCs).
2. **Quantify 90-day early turnover** for critical job classes (CDL Class-A Drivers).
3. **Pinpoint high-risk cohorts** (e.g., voluntary exits under 2 years of tenure).
4. **Determine the correlation** between safety compliance violations and driver retention.
5. **Estimate enterprise financial impact** from workforce replacement costs in real-time.

---

## Project Architecture & File Deliverables

The workspace contains the following deliverables:

1. **`synthetic_logistics_hr_data.csv`**
   - A logically consistent dataset of 250 enterprise employees.
   - *Key fields:* `Employee_ID`, `Facility_Location` (Chicago RDC, Atlanta Depot, Dallas Hub), `Job_Role` (CDL Driver, Warehouse Associate, Logistics Coordinator, Maintenance Tech), `Employment_Status` (Active, Terminated), `Separation_Reason` (Voluntary, Involuntary, N/A), `Hire_Date`, `Tenure_Years`, `Safety_Violation_Count`, `Annual_Salary`, and `Shift` (Day, Night, Weekend).

2. **`analytics_queries.sql`**
   - Production SQL scripts tailored for PostgreSQL or Google BigQuery.
   - Calculates headcount & FTE breakdowns, early 90-day turnover rates, voluntary churn in under 2 years, and safety violation retention correlations.

3. **`dashboard_mockup.html`**
   - A client-ready, single-page interactive dashboard built with **HTML5, Tailwind CSS (Dark Mode), and Chart.js**.
   - Features dynamic filtering by facility and job role, live KPI updating, high-risk registry lookups, and visual trend charts.

---

## Key Insights Discovered

* **High Initial Attrition:** CDL Class-A Drivers and Warehouse Associates represent the highest turnover rates, with a significant spike in voluntary resignations occurring under 2.0 years of tenure.
* **Onboarding Gaps:** The 90-day driver turnover query highlights critical onboarding/recruiting misalignment, specifically concentrated at certain hubs.
* **Safety & Retention Linkage:** Employees with 3 or more safety violations experience a precipitous drop in retention, showing a direct correlation between active infractions and termination (both voluntary and involuntary).
* **Cost Impact:** Front-line turnover costs the business substantial capital. Using industry benchmarks ($15k per CDL driver, $8k per associate), the dashboard estimates the total financial leakage from terminations.

---

## Project Summary

### **Situation**
In a highly competitive supply chain market, our enterprise experienced elevated front-line turnover, specifically among CDL Class-A Drivers and Warehouse Associates. Executive leadership lacked an integrated tool to track regional headcount distribution, analyze the root causes of early-stage turnover, correlate safety violations with employee churn, and quantify the total financial impact of recruitment and replacement costs.

### **Task**
To create a robust analytics package and dashboard mockup to identify early turnover indicators, isolate high-risk cohorts, analyze safety compliance correlations, and present findings in an interactive, executive-ready dashboard to drive operational policy changes.

### **Action**
* **Data Engineering:** Developed a synthetic HR database containing 250 records with key variables such as hire date, tenure, job classification, safety violations, and salaries.
* **Database Querying:** Authored advanced SQL scripts calculating 90-day driver attrition, segmenting cohorts by tenure and voluntary separation, and grouping safety violation levels against retention percentages.
* **Dashboard Design:** Designed and developed a dark-themed interactive HTML dashboard using Tailwind CSS and Chart.js, incorporating dynamic filters (Facility, Job Role), live KPI calculation engines, and interactive high-risk registries.

### **Result**
* Provided a visual tool that immediately highlights the **financial impact** (estimating turnover costs dynamically).
* Uncovered a direct correlation showing that safety violations of **3 or more** lead to a near-total drop in retention, allowing safety managers to intervene early.
* Allowed regional directors to view shift and headcount allocation dynamically across the **Chicago RDC, Atlanta Depot, and Dallas Hub**, facilitating workforce optimization strategies.
