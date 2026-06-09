-- ============================================================
-- 04_market_size.sql
-- Q4 -- How big is the market, and how concentrated is the money?
--
-- Rome's Airbnb market generated an ESTIMATED EUR 481,736,712 over
-- the last 12 months. The top 10% of earning listings capture
-- 45.3% of all that revenue.
--
-- NOTE: estimated_revenue_l365d is an Inside Airbnb MODEL estimate,
-- not booking records -- always label it "estimated" on screen.
-- It is TEXT in the raw table, so it is cast inline below.
-- 33,564 of the 37,652 listings carry a revenue estimate; the totals
-- and the decile split are computed over those (the rest show none).
--
-- Reads from the `rome` view created in 00_setup.sql.
-- ============================================================

-- Total estimated market size:
SELECT ROUND(SUM(NULLIF(estimated_revenue_l365d, '')::numeric)) AS total_market_eur
FROM rome_project.rome;

-- Revenue concentration: share captured by the top 10% of earning listings.
WITH ranked AS (
    SELECT NULLIF(estimated_revenue_l365d, '')::numeric AS rev,
           NTILE(10) OVER (ORDER BY NULLIF(estimated_revenue_l365d, '')::numeric DESC) AS decile
    FROM rome_project.rome
    WHERE NULLIF(estimated_revenue_l365d, '') IS NOT NULL
)
SELECT
    ROUND(100.0 * SUM(rev) FILTER (WHERE decile = 1) / SUM(rev), 1) AS top10pct_share
FROM ranked;

-- Results (verified 9 June 2026):
--   total_market_eur  481,736,712
--   top10pct_share     45.3%   (over 33,564 listings with a revenue estimate)
