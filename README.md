# E-Commerce Sales Funnel Analysis
**SQL · Google BigQuery · Standard SQL**

Analysis of a 5,000-user e-commerce dataset to understand where customers drop off in the purchase journey, which traffic channels convert best, and how long it takes users to complete a purchase.

---

## Business Questions
1. What is the overall conversion rate from page view to purchase?
2. Which traffic source drives the highest purchase conversion rate?
3. How long does a user typically take to go from first view to purchase?
4. What is the revenue profile per buyer and per visitor?

---

## Dataset
| Field | Detail |
|---|---|
| Source | `user_events` table · Google BigQuery |
| Period | Dec 2025 – Feb 2026 |
| Rows | 9,381 events |
| Users | 5,000 unique users |
| Events | page_view · add_to_cart · checkout_start · payment_info · purchase |
| Traffic sources | organic · social · paid_ads · email |

---

## Key Findings

### 1 · Overall Funnel
| Stage | Users | Conversion from previous |
|---|---|---|
| Page View | 5,000 | — |
| Add to Cart | 1,553 | 31.06% |
| Checkout Start | 1,103 | 71.02% |
| Payment Info | 899 | 81.50% |
| Purchase | 826 | 91.88% |
| **Overall (view → purchase)** | | **16.52%** |

> **Biggest drop-off:** Page view → Add to cart (only 31%). This is where the majority of potential buyers are lost.

---

### 2 · Conversion by Traffic Source
| Source | Views | Purchases | Purchase Rate |
|---|---|---|---|
| Email | 522 | 177 | **34%** ✅ |
| Paid Ads | 968 | 204 | 21% |
| Organic | 2,038 | 343 | 17% |
| Social | 1,472 | 102 | **7%** ⚠️ |

> **Key insight:** Email converts at 34% — nearly 5× higher than Social (7%). Despite having the lowest volume, email delivers the highest-quality traffic.

---

### 3 · Time to Conversion (converted users only)
| Metric | Value |
|---|---|
| View → Add to Cart | avg. 11 minutes |
| Add to Cart → Purchase | avg. 13 minutes |
| Full journey (View → Purchase) | avg. 25 minutes |

---

### 4 · Revenue Metrics
| Metric | Value |
|---|---|
| Total Revenue | $87,975 |
| Total Orders | 826 |
| Avg Order Value | $106.51 |
| Revenue per Buyer | $106.51 |
| Revenue per Visitor | $17.60 |

---

## Recommendations
1. **Improve the view → cart experience** : with only 31% of viewers adding to cart, this is the highest-leverage optimization point. Consider improving product page UX, adding clearer CTAs, or running A/B tests on product descriptions.
2. **Scale email campaigns** : email has the highest purchase conversion rate (34%) but the lowest traffic volume (522 sessions). Increasing email list size or send frequency could significantly lift total revenue with minimal cost.
3. **Audit social media strategy** : social drives 1,472 sessions but converts at only 7%, the lowest of all channels. Either improve landing page relevance for social traffic or reallocate budget toward email and paid ads.

---

## SQL Techniques Used
- `CTE` (Common Table Expressions) — `WITH ... AS (...)`
- `CASE WHEN` inside aggregate functions
- `COUNT(DISTINCT ...)` for unique user counts
- `TIMESTAMP_DIFF()` — BigQuery-specific time difference function
- `HAVING` clause to filter aggregated results
- `ROUND()` for formatted percentage outputs

---

## Files
| File | Description |
|---|---|
| `Funnel-Analysis.sql` | All 4 queries with section headers and inline comments |

---

## Tools
![BigQuery](https://img.shields.io/badge/Google_BigQuery-4285F4?style=flat&logo=google-cloud&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Standard-blue?style=flat)
