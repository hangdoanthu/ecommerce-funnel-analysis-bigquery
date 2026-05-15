-- ============================================================
-- PROJECT  : E-Commerce Sales Funnel Analysis
-- DATASET  : user_events (BigQuery · sql_practices)
-- PERIOD   : Dec 2025 – Feb 2026  |  9,381 events · 5,000 users
-- TOOL     : Google BigQuery (Standard SQL)
-- AUTHOR   : [Hang Doan Hoang Thu]
-- ============================================================
-- QUESTIONS ANSWERED:
--   1. What is the overall conversion rate through the purchase funnel?
--   2. Which traffic source drives the highest purchase conversion?
--   3. How long does a user take to go from view to purchase?
--   4. What is the revenue profile of buyers vs. all visitors?
-- ============================================================


-- ============================================================
-- QUERY 1: Overall Funnel Conversion Rates
-- Counts distinct users at each stage of the purchase journey,
-- then calculates the step-by-step and overall conversion rates.
-- ============================================================

WITH funnel_stages AS (
   SELECT
    COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS stage_1_views,
    COUNT(DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END) AS stage_2_cart,
    COUNT(DISTINCT CASE WHEN event_type='checkout_start' THEN user_id END) AS stage_3_checkout,
    COUNT(DISTINCT CASE WHEN event_type='payment_info' THEN user_id END) AS stage_4_payment,
    COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS stage_5_purchase

FROM `project-32cbe250-4ba1-45fc-9e0.sql_practices.user_events`

)


SELECT 

ROUND(stage_2_cart * 100 / stage_1_views, 2) AS view_to_cart_rate,

ROUND(stage_3_checkout * 100 / stage_2_cart, 2) AS cart_to_checkout_rate,

ROUND(stage_4_payment * 100 / stage_3_checkout, 2) AS checkout_to_payment_rate,

ROUND(stage_5_purchase * 100 / stage_4_payment, 2) AS payment_to_purchase_rate,

ROUND(stage_5_purchase * 100 / stage_1_views, 2) AS overall_conversion_rate

FROM funnel_stages;

-- ============================================================
-- QUERY 2: Funnel Breakdown by Traffic Source
-- Compares views, cart adds, and purchases across traffic sources
-- to identify which channel drives the highest-quality traffic.
-- ============================================================

WITH funnel_source AS(
    SELECT
    traffic_source,
    COUNT (DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
    COUNT (DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS cart,
    COUNT (DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchase

FROM `project-32cbe250-4ba1-45fc-9e0.sql_practices.user_events` 

GROUP BY traffic_source

)

SELECT 
       traffic_source,
       views,
       cart,
       purchase,
       ROUND(cart * 100 / views) AS cart_conversion_rate,
       ROUND(purchase * 100 / views) AS purchase_conversion_rate,
       ROUND(purchase * 100 / cart) AS cart_to_purchase_conversion_rate

FROM funnel_source 
ORDER BY purchase DESC;

-- ============================================================
-- QUERY 3: Time-to-Conversion Analysis
-- For users who completed a purchase, measures how many minutes
-- elapsed between each key funnel stage (view → cart → purchase).
-- Only includes users who reached the purchase stage (HAVING clause).
-- ============================================================

WITH user_journey AS(
 SELECT
    user_id,
    MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
    MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
    MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time

 FROM `project-32cbe250-4ba1-45fc-9e0.sql_practices.user_events` 

 GROUP BY user_id
 HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL

) 

SELECT
 COUNT (*) 
   AS converted_users,
 ROUND (AVG (TIMESTAMP_DIFF(cart_time, view_time,MINUTE))) AS avg_view_to_cart_minutes,
 ROUND (AVG (TIMESTAMP_DIFF(purchase_time, cart_time,MINUTE))) AS avg_cart_to_purchase_minutes,
 ROUND (AVG (TIMESTAMP_DIFF(purchase_time, view_time,MINUTE))) AS avg_total_journey_minutes
FROM user_journey;

-- ============================================================
-- QUERY 4: Revenue Funnel
-- Calculates total revenue and key per-user revenue metrics
-- to understand the monetary value of each funnel stage.
-- ============================================================

WITH funnel_revenue AS(
    SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
    SUM(CASE WHEN event_type = 'purchase' THEN amount END) AS total_revenue,
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders

FROM `project-32cbe250-4ba1-45fc-9e0.sql_practices.user_events` 

)

SELECT 
 total_visitors,
 total_buyers,
 total_orders,
 total_revenue,
 total_revenue/total_orders AS avg_order_value,
 total_revenue/total_buyers AS revenue_per_buyer,
 total_revenue/total_visitors AS revenue_per_visitor

FROM funnel_revenue;







