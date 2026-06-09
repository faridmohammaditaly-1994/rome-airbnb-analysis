-- ============================================================
-- 08_minimum_nights.sql
-- Q8 -- Tourist churn: how short are the stays?
--
-- 72% of listings accept stays of just 1-2 nights (median minimum
-- stay = 2). That's high-turnover tourist accommodation, not
-- residential or even monthly letting.
--
-- minimum_nights is TEXT in the raw table, so it is cast inline.
--
-- Reads from the `rome` view created in 00_setup.sql.
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE NULLIF(minimum_nights, '')::int <= 2)                                 AS short_stay,
    ROUND(100.0 * COUNT(*) FILTER (WHERE NULLIF(minimum_nights, '')::int <= 2) / COUNT(*), 1)    AS pct_short_stay,
    ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY NULLIF(minimum_nights, '')::int))          AS median_min_nights
FROM rome_project.rome;

-- Result (verified 9 June 2026):
--   short_stay (<=2 nights):  27,004 listings   71.7%  (rounds to 72%)
--   median minimum nights:    2
