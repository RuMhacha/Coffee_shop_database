# ☕ Coffee Shop Sales Analysis using PostgreSQL

## Project Overview

This project analyses transactional sales data from three coffee shop locations using PostgreSQL.

The objective was to transform raw transaction data into meaningful business insights by examining overall sales performance, store performance, monthly trends, customer purchasing behaviour, and product performance.

The analysis also demonstrates practical SQL skills including aggregation, conditional logic, Common Table Expressions (CTEs), subqueries, window functions, ranking functions, and time-based analysis.

---

## Business Questions

The analysis was designed to answer questions such as:

- How much revenue did the coffee shop generate?
- How many transactions and units were sold?
- Which store generates the most revenue?
- How does revenue change over time?
- Which months perform best?
- What times of day generate the most sales?
- Which product categories contribute the most revenue?
- Which individual products generate the most revenue?
- Which store performs best within each product category?
- Which products or categories may require further attention?

---

## Dataset

The dataset contains transaction-level sales records from three coffee shop locations:

- Astoria
- Hell's Kitchen
- Lower Manhattan

The analysis covers transactions from January through June 2023.

Important fields used in the analysis include:

- `transaction_id`
- `transaction_date`
- `transaction_time`
- `transaction_qty`
- `store_location`
- `product_category`
- `product_type`
- `product_detail`
- `unit_price`

---

## Tools & Technologies

- PostgreSQL
- DBeaver
- SQL

---

# Data Analysis

## 1. Data Quality Checks

Before performing the analysis, the dataset was validated to ensure the results were reliable.

Checks included:

- Total row count
- Unique transaction IDs
- Missing values in key columns
- Transaction date range
- Transaction quantity range
- Unit price range

The dataset covers transactions between **1 January 2023 and 30 June 2023**.

These checks helped verify that the core fields required for the analysis were suitable for further exploration.

---

## 2. Overall Sales Performance

The business generated approximately:

| Metric | Result |
|---|---:|
| Total Transactions | 149,116 |
| Total Units Sold | 214,470 |
| Total Revenue | $698,812.33 |

These metrics establish the overall scale of sales activity during the six-month period.

---

## 3. Store Performance

Sales performance was compared across the three store locations.

The analysis measured:

- Total transactions
- Units sold
- Revenue
- Average transaction value

**Hell's Kitchen recorded the highest transaction volume**, with approximately **50,735 transactions**, followed closely by Astoria.

Despite relatively similar activity across the locations, analysing each store separately helps identify differences in product mix and customer purchasing patterns.

---

## 4. Sales Trends

### Monthly Revenue

Monthly revenue was calculated to identify changes in sales performance over time.

Revenue increased substantially during the analysis period, with particularly strong performance toward the end of the dataset.

Approximate monthly revenue included:

| Month | Revenue |
|---|---:|
| January | $81,677.74 |
| February | $76,145.19 |
| March | $98,834.68 |
| April | $118,941.08 |
| May | $156,727.76 |
| June | $166,485.88 |

February experienced a small decline compared with January, followed by sustained growth from March onward.

June generated the highest monthly revenue.

### Month-over-Month Growth

The `LAG()` window function was used to compare each month's revenue with the previous month and calculate month-over-month growth.

This analysis demonstrates that the business experienced strong overall growth during the first half of 2023.

---

## 5. Customer Purchasing Patterns

### Sales by Time of Day

Transactions were grouped into five dayparts:

- Early Morning
- Late Morning
- Lunch / Early Afternoon
- Afternoon
- Evening

**Early Morning was the busiest sales period**, generating approximately **53,440 transactions** and **76,881 units sold**.

This indicates that morning demand is particularly important to the business.

Operationally, this suggests that staffing, product availability, and inventory preparation should be prioritised before the morning rush.

### Weekday vs Weekend Behaviour

Sales were also compared between weekdays and weekends.

Because the dataset contains more weekdays than weekend days, daily averages were calculated rather than relying only on total sales.

Average daily transaction activity was slightly higher on weekdays than weekends, indicating relatively consistent demand throughout the week with a modest weekday advantage.

---

## 6. Product Performance

### Revenue by Product Category

Product categories were ranked according to revenue contribution.

The largest categories were:

| Product Category | Revenue | Revenue Share |
|---|---:|---:|
| Coffee | $269,952.45 | 38.63% |
| Tea | $196,405.95 | 28.11% |
| Bakery | $82,315.64 | 11.78% |
| Drinking Chocolate | $72,416.00 | 10.36% |
| Coffee Beans | $40,085.25 | 5.74% |

Coffee and Tea together generated approximately **66.7% of total revenue**, demonstrating that beverage sales are the core revenue driver.

Smaller categories such as Branded products, Loose Tea, Flavours, and Packaged Chocolate contributed considerably less revenue.

### Top Products by Revenue

The highest-revenue product types included:

1. Barista Espresso
2. Brewed Chai Tea
3. Hot Chocolate
4. Gourmet Brewed Coffee
5. Brewed Black Tea
6. Brewed Herbal Tea
7. Premium Brewed Coffee
8. Organic Brewed Coffee
9. Scone
10. Drip Coffee

**Barista Espresso was the highest-revenue product type**, generating approximately **$91.4K** in revenue.

This highlights the importance of espresso-based products within the overall product portfolio.

---

## 7. Store & Product Analysis

Product performance was also analysed across individual store locations.

Window functions were used to rank stores within each product category and identify the store generating the most revenue for each category.

Examples include:

- **Coffee:** Hell's Kitchen
- **Tea:** Astoria
- **Bakery:** Lower Manhattan
- **Drinking Chocolate:** Astoria
- **Coffee Beans:** Hell's Kitchen

The results demonstrate that no single location dominates every product category.

Instead, different stores show strengths across different areas of the product portfolio.

This could help management develop location-specific merchandising, inventory, and promotional strategies.

---

# SQL Techniques Used

This project demonstrates several SQL techniques commonly used in data analyst roles:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `HAVING`
- `CASE`
- Aggregate functions
  - `SUM()`
  - `COUNT()`
  - `AVG()`
  - `MIN()`
  - `MAX()`
- Date and time functions
  - `DATE_TRUNC()`
  - `EXTRACT()`
  - `TO_CHAR()`
- Common Table Expressions (CTEs)
- Subqueries
- Window functions
- `LAG()`
- `ROW_NUMBER()`
- `RANK()`
- `PARTITION BY`
- Cumulative calculations
- Percentage calculations
- Month-over-month growth calculations

---

# Key Business Insights

The analysis produced several important findings:

1. The coffee shops generated approximately **$698.8K in revenue from 149K transactions** during the first six months of 2023.

2. Revenue showed strong growth toward the end of the period, with **June producing the highest monthly revenue**.

3. **Coffee and Tea dominate the product mix**, together contributing roughly two-thirds of total revenue.

4. **Early Morning is the most important customer purchasing period**, suggesting that morning operations are particularly important.

5. **Barista Espresso is the highest-revenue product type**, making espresso-based products an important contributor to overall performance.

6. Store performance is relatively balanced overall, but individual locations show different strengths across product categories.

---

# Business Recommendations

Based on the analysis, the business could consider the following actions:

### Optimise Morning Operations

Because Early Morning generates the highest transaction volume, stores should ensure sufficient staffing, inventory, and preparation before peak morning demand.

### Protect Core Beverage Categories

Coffee and Tea account for the majority of revenue. Maintaining product availability and service quality within these categories should therefore remain a priority.

### Use Location-Specific Product Strategies

Different stores lead different product categories. Promotions and inventory decisions could therefore be tailored to the purchasing behaviour of each location rather than applying identical strategies across all stores.

### Investigate Lower-Revenue Categories

Categories with relatively small revenue contributions should be evaluated to determine whether they provide strategic value, support higher-margin purchases, or could benefit from improved merchandising and promotions.

### Investigate Drivers of Revenue Growth

Revenue increased significantly from March through June. Further analysis could determine whether this growth resulted from increased customer traffic, seasonal demand, changes in product mix, or other factors.

---

# Repository Structure

```text
coffee-shop-sales-analysis/
│
├── README.md
│
├── sql/
│   └── coffee_shop_sales_analysis.sql
│
├── data/
│   └── coffee_shop_sales.csv
│
└── images/
    └── analysis_screenshots/
