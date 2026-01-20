# Date-Product-Sales-Matrix
Building a Complete Date × Product Sales Matrix
## Business Context

A retail company tracks daily product sales.
Management noticed that some products appear to have no sales trends or sudden drops, but dashboards only show days where sales actually happened.

### Problem:
Transactional data hides days with zero sales, leading to:

- Incorrect trend analysis
- Misleading averages
- Poor inventory and replenishment decisions

## Business Requirement

Show daily sales for every product, including days with zero sales, so that missing activity is visible and measurable.

## Data Available

products
product_id, product_name, category

orders
order_id, product_id, order_date, quantity, revenue

calendar
date, day, month, year

## Key Challenge

Days without sales do not exist in the orders table.
A simple LEFT JOIN between products and orders will still drop missing dates.
To make absence visible, we must generate expected combinations first.

## Solution Strategy (Why CROSS JOIN)

We create a Date × Product matrix using CROSS JOIN, then bring in transactional data.
CROSS JOIN acts as a data generator, not a relationship join.

## SQL Implementation (Interview-Safe)
### Step 1: Generate a complete Date × Product grid
SELECT
  d.date,
  p.product_id,
  p.product_name
FROM calendar d
CROSS JOIN products p;

### Step 2: LEFT JOIN actual sales
LEFT JOIN orders o
  ON o.product_id = p.product_id
 AND o.order_date = d.date;

### Step 3: Aggregate & handle missing data
SELECT
  d.date,
  p.product_id,
  COALESCE(SUM(o.quantity), 0) AS total_quantity,
  COALESCE(SUM(o.revenue), 0) AS total_revenue
FROM calendar d
CROSS JOIN products p
LEFT JOIN orders o
  ON o.product_id = p.product_id
 AND o.order_date = d.date
GROUP BY d.date, p.product_id;

## Output (What This Solves)
Date	Product	Quantity	Revenue
2024-01-01	A	0	0
2024-01-02	A	5	500
2024-01-03	A	0	0

- Zero-sale days now exist explicitly
- Trends are accurate
- Gaps are visible

## Business Insights Enabled

- Identify products with frequent zero-sale days
- Detect supply chain or pricing issues
- Improve demand forecasting
- Enable true daily averages
- Support inventory planning

## How This Helped Reporting (Power BI)

- Continuous time-series lines (no broken charts)
- Correct moving averages
- Accurate KPIs like:
- Days without sales
- Sell-through rate
- Stock risk alerts
