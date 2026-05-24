# 🛒 Ecommerce Sales Analysis Using SQL

## 📌 Project Overview
This project focuses on analyzing ecommerce sales data using SQL to generate meaningful business insights related to revenue, customer behavior, product performance, returns, and regional trends.

The project simulates real-world ecommerce analytics scenarios commonly handled by Data Analysts and Business Intelligence teams.

---

# 🛠 Tech Stack
- MySQL
- SQL

---

# 📂 Database Schema

The project consists of 5 tables:

- Customers
- Products
- Orders
- OrderDetails
- Regions

---

# 🎯 Business Problems Solved

## General Sales Insights
- Total revenue generated
- Revenue excluding returned orders
- Revenue by year and month
- Revenue by product and category
- Average Order Value (AOV)
- AOV trends over time
- Average order size by region

---

## Customer Insights
- Top 10 customers by revenue
- Repeat customer rate
- Average time between customer orders
- Customer segmentation based on spend
- Customer Lifetime Value (CLV)

### Customer Segments

| Segment | Spend Range |
|---|---|
| Platinum | > 1500 |
| Gold | 1000 – 1500 |
| Silver | 500 – 999 |
| Bronze | < 500 |

---

## Product & Order Insights
- Top-selling products by quantity
- Top-selling products by revenue
- Product return rate analysis
- Return rate by category
- Average product price by region
- Category-wise sales trends

---

## Temporal Trends
- Monthly sales trends
- Monthly/weekly AOV analysis

---

## Regional Insights
- Region-wise order volume
- Revenue comparison across regions

---

## Return & Refund Insights
- Return rate by category
- Return rate by region
- Customers with frequent returns

---

# 🧠 SQL Concepts Used
- Joins
- Aggregate Functions
- CTEs
- Window Functions
- Subqueries
- CASE Statements
- Date Functions
- GROUP BY & ORDER BY
- Business KPI Calculations

---

# 📊 Key KPIs Analysed
- Total Revenue
- Average Order Value (AOV)
- Customer Lifetime Value (CLV)
- Repeat Customer Rate
- Return Rate
- Regional Revenue
- Product Performance

---

# 📁 Sample Queries Included

## Total Revenue

```sql
Select Sum(OD.quantity * p.price) AS Total_Revenue
From orderdetails OD
Join Products P on p.productid=od.productid;
```

## Repeat Customer Rate

```sql
Select Round(
Count(Distinct Case When OrderCount > 1 Then CustomerID END)
/ Count(distinct CustomerID),2) AS Repeat_Customer_Rate
From (
    Select CustomerID, Count(orderID) AS Ordercount
    From Orders
    Group By CustomerID
) AS T;
```

## Customer Segmentation

```sql
Case
    When Sum(OD.Quantity*P.Price) > 1500 Then 'Platinum'
    When Sum(OD.Quantity*P.Price) Between 1000 and 1500 Then 'Gold'
    When Sum(OD.Quantity*P.Price) Between 500 and 999 Then 'Silver'
    Else 'Bronze'
End
```

---

# 🚀 Key Learnings
- Solving real-world business problems using SQL
- Writing analytical SQL queries
- Understanding ecommerce KPIs
- Working with customer and sales analytics
- Performing trend and return analysis

---

# 📌 Future Improvements
- Build Power BI Dashboard
- Add Data Visualization
- Create Automated Reports
- Add Python/Pandas Analysis
- Implement Forecasting Models

---

# ⭐ About This Project
This project was created as part of my SQL and Data Analytics learning journey to strengthen practical business analysis skills using SQL.
