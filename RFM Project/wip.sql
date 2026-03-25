-- Project: Customer Segmentation (RFM)
-- Tool: Google BigQuery
-- Description: End-to-end RFM analysis and customer segmentation

--Union all the tables together

CREATE OR REPLACE TABLE `bigqueryanalysis-491308.sales.sales_2025`  AS 
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue FROM `bigqueryanalysis-491308.sales.sales202501`
UNION ALL
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue  FROM `bigqueryanalysis-491308.sales.sales202502`
UNION ALL
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue  FROM `bigqueryanalysis-491308.sales.sales202503`
UNION ALL
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue  FROM `bigqueryanalysis-491308.sales.sales202504`
UNION ALL
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue  FROM `bigqueryanalysis-491308.sales.sales202505`
UNION ALL
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue  FROM `bigqueryanalysis-491308.sales.sales202506`
UNION ALL
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue  FROM `bigqueryanalysis-491308.sales.sales202507`
UNION ALL
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue  FROM `bigqueryanalysis-491308.sales.sales202508`
UNION ALL
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue  FROM `bigqueryanalysis-491308.sales.sales202509`
UNION ALL
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue  FROM `bigqueryanalysis-491308.sales.sales202511`
UNION ALL
SELECT OrderID, CustomerID, OrderDate, ProductType, OrderValue  FROM `bigqueryanalysis-491308.sales.sales202512`;

-- Calculate receny, frequency, monetary and create a rank
-- Combine views with CTEs
CREATE OR REPLACE VIEW `bigqueryanalysis-491308.sales.rfm_metrics` AS
WITH current_date AS (
   SELECT DATE('2026-03-25') AS analysis_date -- Current Date
),
rfm AS(
  SELECT
  CustomerID,
  MAX(OrderDate) AS last_order_date,
  date_diff((SELECT analysis_date FROM current_date), MAX(OrderDate), DAY) AS recency,
  COUNT(*) AS frequency,
  SUM(OrderValue) AS monetary
  FROM `bigqueryanalysis-491308.sales.sales_2025`
  GROUP BY CustomerID
)
SELECT
rfm.*,
ROW_NUMBER() OVER(ORDER BY recency ASC) AS r_rank,
ROW_NUMBER() OVER(ORDER BY frequency DESC) AS f_rank,
ROW_NUMBER() OVER(ORDER BY monetary DESC) AS m_rank
FROM rfm;

-- Creating scores, 10 from 1
CREATE OR REPLACE VIEW `bigqueryanalysis-491308.sales.rfm_scores`
AS
  SELECT *,
    NTILE(10) OVER(ORDER BY r_rank DESC) AS r_score,
    NTILE(10) OVER(ORDER BY f_rank DESC) AS f_score,
    NTILE(10) OVER(ORDER BY m_rank DESC) AS m_score
      FROM `bigqueryanalysis-491308.sales.rfm_metrics`;

-- Total Score
CREATE OR REPLACE VIEW `bigqueryanalysis-491308.sales.rfm_total_scores` AS
  SELECT
    CustomerID,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score) AS rfm_total_score
    FROM `bigqueryanalysis-491308.sales.rfm_scores`
ORDER BY rfm_total_score DESC;

-- Get Data to export to PowerBi
CREATE OR REPLACE TABLE `bigqueryanalysis-491308.sales.rfm_final_segments`
AS
  SELECT
    CustomerID,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    rfm_total_score,
    CASE
      WHEN rfm_total_score >= 28 THEN 'Champions' -- 28 - 30
      WHEN rfm_total_score >= 24 THEN 'VIPS' -- 24 - 27
      WHEN rfm_total_score >= 20 THEN 'Loyals' -- 20 - 23
      WHEN rfm_total_score >= 16 THEN 'Promising' -- 16 - 19
      WHEN rfm_total_score >= 12 THEN 'Engaged' -- 12 - 15
      WHEN rfm_total_score >= 8 THEN 'Attention' -- 8 - 11
      WHEN rfm_total_score >= 4 THEN 'Risk' -- 4 - 7
      ELSE 'Lost/Inactive' END AS rfm_segments
    FROM `bigqueryanalysis-491308.sales.rfm_total_scores`
    ORDER BY rfm_total_score DESC;














