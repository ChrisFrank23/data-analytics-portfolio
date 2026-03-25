# 📊 Customer Segmentation Analysis (RFM) | BigQuery + Power BI

---

## 📌 Project Overview

This project focuses on customer segmentation using the RFM (Recency, Frequency, Monetary) model. The goal was to analyze customer purchasing behavior and classify customers into meaningful business segments.

The entire data processing and analysis pipeline was built using SQL in Google BigQuery, followed by preparation for visualization in Power BI.

---

## 🎯 Objectives

- Analyze customer behavior based on purchase activity  
- Calculate RFM metrics (Recency, Frequency, Monetary)  
- Segment customers into business categories  
- Prepare a clean dataset for dashboard creation  
- Generate insights to support data-driven decision making  

---

## 🛠️ Tools & Technologies

- Google BigQuery (SQL)
- Data Modeling
- Data Analysis
- Power BI (for dashboard visualization)

---

## 🔄 Project Process

### 1. Data Preparation

- Combined multiple monthly sales tables using `UNION ALL`
- Standardized the dataset structure
- Created a consolidated table for analysis

---

### 2. RFM Metrics Calculation

- **Recency:** Days since last purchase  
- **Frequency:** Total number of purchases  
- **Monetary:** Total amount spent  

---

### 3. Ranking & Scoring

- Applied window functions (`ROW_NUMBER`, `NTILE`)
- Created scores from 1 to 10 for each RFM metric  
- Generated a total RFM score  

---

### 4. Customer Segmentation

Customers were classified into meaningful business segments:

- Champions  
- VIPs  
- Loyals  
- Promising  
- Engaged  
- Attention  
- Risk  
- Lost/Inactive  

---

### 5. Final Dataset

- Created a final table optimized for Power BI  
- Structured for easy visualization and analysis  

---

## 📊 Key Insights (Example)

- High-value customers (Champions & VIPs) contribute significantly to revenue  
- A portion of customers are at risk of churn  
- Customer engagement varies significantly across segments  
- Opportunities exist for targeted marketing strategies  

---

## 📈 Business Value

This project demonstrates how raw transactional data can be transformed into actionable business insights, enabling:

- Customer retention strategies  
- Targeted marketing campaigns  
- Revenue optimization  

---

## 📷 Dashboard Preview

![image alt](https://github.com/ChrisFrank23/data-analytics-portfolio/blob/c2604f100693abcc903226e1c83a27bace07a37e/RFM%20Project/Captura%20de%20tela%202026-03-25%20185028.png)

---

## 🔗 Links

- 💼 LinkedIn: (your link)
- 🌐 Portfolio Website: (your site)


