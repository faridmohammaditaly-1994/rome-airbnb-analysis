-- ============================================================
-- 09_growth_by_year.sql
-- Q9 -- The 2024 explosion: when did listings first go live?
--
-- Using first_review as a proxy for when a listing first went
-- active. 2024 was the single biggest year ever -- 7,326 new
-- listings -- and almost HALF of all Rome listings first went
-- active in the last three years (2023-2025). The growth is
-- accelerating, not historical.
--
-- CAVEAT: first_review is a proxy. Listings with zero reviews
-- (~5,400) have no first_review and are excluded from the yearly
-- curve; many are themselves brand-new, so recent growth is, if
-- anything, understated. 2025 is partial (scrape was mid-Sep 2025).
--
-- first_review_d is cast in the `rome` view (see 00_setup.sql).
-- ============================================================

-- New listings per year (first_review proxy):
SELECT
    EXTRACT(YEAR FROM first_review_d)::int AS year_went_live,
    COUNT(*)                               AS new_listings
FROM rome_project.rome
WHERE first_review_d IS NOT NULL
GROUP BY year_went_live
ORDER BY year_went_live;

-- Share that first went live in the last three years (2023-2025):
SELECT
    COUNT(*) FILTER (WHERE EXTRACT(YEAR FROM first_review_d) >= 2023)                              AS since_2023,
    ROUND(100.0 * COUNT(*) FILTER (WHERE EXTRACT(YEAR FROM first_review_d) >= 2023) / COUNT(*), 1) AS pct_of_all_listings
FROM rome_project.rome;

-- Results (verified 9 June 2026):
--   Peak years: 2024 = 7,326 (biggest ever), 2025 = 6,682 (partial), 2023 = 4,628
--   Last 3 years (2023-2025): 18,636 listings = 49.5% of all 37,652 (57.8% of reviewed)
