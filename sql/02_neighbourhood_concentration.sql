-- ============================================================
-- 02_neighbourhood_concentration.sql
-- Q2 -- Where are the listings? Neighbourhood concentration.
--
-- Nearly half of ALL Rome listings sit in ONE district:
-- I Centro Storico -- 18,563 listings, 49.3% of the city.
-- The next-biggest district holds only 8.7%.
--
-- Reads from the `rome` view created in 00_setup.sql.
-- ============================================================

SELECT
    neighbourhood_cleansed,
    COUNT(*)                                            AS listings,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)  AS pct_of_city
FROM rome_project.rome
GROUP BY neighbourhood_cleansed
ORDER BY listings DESC
LIMIT 10;

-- Result (verified 9 June 2026), top 3:
--   I Centro Storico              18,563   49.3%
--   VII San Giovanni/Cinecitta     3,264    8.7%
--   XIII Aurelia                   2,674    7.1%
