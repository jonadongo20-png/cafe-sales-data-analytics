# Cafe Sales & Operational Analytics Case Study (SQL & Tableau)

## Executive Summary
This project analyzes a 10,000-transaction cafe sales dataset to evaluate operational efficiency, item profitability, and channel performance. Raw transaction records were ingested, structured, and cleaned using MySQL (DBeaver), resolving missing financial values and inconsistencies before visualizing business insights in an interactive Tableau Public dashboard.

---

## Interactive Dashboard
* **Live Tableau Public Dashboard:** [Cafe Sales & Operational Analytics](https://public.tableau.com/views/CafeSalesOperationalAnalytics/Dashboard1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## Business Problem & Objectives
Management required operational insights to address key commercial questions:
* **Product Mix:** Which menu items generate the highest total revenue versus volume?
* **Channel Performance:** Does spending behavior differ between In-store and Takeaway orders?
* **Payment Preference:** How are transactions distributed across payment gateways?
* **Temporal Patterns:** Are there specific months or weekdays driving peak customer traffic?

---

## Data Cleaning & Technical Architecture (SQL)
The dataset underwent a multi-step cleaning workflow in MySQL:
1. **Staging Schema:** Built `cafe_sales_staging` to isolate transformations from raw source data.
2. **Duplicate Analysis:** Verified record uniqueness using `ROW_NUMBER()` window functions.
3. **Data Type Standardization:** Re-cast text date strings into proper `DATE` format (`YYYY-MM-DD`) and altered numeric columns to `INT` and `DECIMAL(10,2)`.
4. **Noise Scrubbing:** Replaced placeholder strings (`'UNKNOWN'`, `'ERROR'`, whitespace) with standard `NULL` values.
5. **Financial Value Imputation:**
   * Recalculated missing values using $Total\ Spent = Quantity \times Price\ Per\ Unit$.
   * Imputed remaining missing unit prices using partitioned menu category averages.
6. **Record Scrubbing:** Cleared unrecoverable records missing core transactional identifiers.

---

## Key Business Insights
* **Revenue Drivers:** Salads ($17,320) and Sandwiches ($13,664) account for the largest share of overall revenue, outperforming beverage categories.
* **Balanced Order Channels:** In-store orders generated $27,127 with an Average Order Value (AOV) of $9.03, slightly outstripping Takeaway orders ($26,488 total, $8.80 AOV).
* **Payment Distribution:** Payment methods display an even split across digital wallets, credit cards, cash, and online channels (~23% to 31%).
* **Overall Metrics:** Processed **9,977 clean transactions**, capturing **$88,952 in total revenue** across **30,131 items sold** at an overall **AOV of $8.93**.

---

## Business Recommendations
1. **Menu Optimization:** Bundle lower-margin items (Cookies, Tea) with high-revenue drivers (Salads, Sandwiches) to boost average ticket size beyond $8.93.
2. **Channel Strategy:** Tailor takeaway promotions during mid-week periods to align channel spend closer to in-store order performance.
3. **Inventory Allocation:** Adjust perishable stock orders around seasonal peak periods highlighted in the monthly heatmap.

---

## Project Repository Structure
* `cafe_sales_cleaning.sql` — Full SQL data cleaning script.
* `cafe_sales_cleaned.csv` — Cleaned dataset exported from MySQL/DBeaver.
* `README.md` — Project case study documentation.
