-- ============================================================
-- 03_top_hosts.sql
-- Q3 -- Who owns the listings? Top hosts by listing count.
--
-- The biggest host, "Elena Sofia", manages 252 listings with an
-- ESTIMATED EUR 7,032,282 in revenue over the last 12 months.
-- 3 hosts control more than 100 listings; 19 control more than 50.
--
-- NOTE: estimated_revenue_l365d is an Inside Airbnb MODEL estimate,
-- not booking records -- always label it "estimated" on screen.
-- It is TEXT in the raw table, so it is cast inline below.
--
-- Reads from the `rome` view created in 00_setup.sql.
-- ============================================================

-- Top 10 hosts by listing count, with estimated annual revenue:
SELECT
    host_name,
    COUNT(*)                                                AS listings,
    ROUND(SUM(NULLIF(estimated_revenue_l365d, '')::numeric)) AS est_revenue_eur
FROM rome_project.rome
GROUP BY host_id, host_name
ORDER BY listings DESC
LIMIT 10;

-- How concentrated is ownership? Count hosts by portfolio size:
WITH h AS (
    SELECT host_id, COUNT(*) AS n
    FROM rome_project.rome
    GROUP BY host_id
)
SELECT
    COUNT(*) FILTER (WHERE n > 100) AS hosts_over_100,
    COUNT(*) FILTER (WHERE n > 50)  AS hosts_over_50
FROM h;

-- Results (verified 9 June 2026):
--   Top hosts:  Elena Sofia  252  est. EUR 7,032,282
--               Francesco    195  est. EUR 2,147,880
--               WonderWhereToStay 110  est. EUR 313,818
--   Concentration:  3 hosts over 100 listings, 19 hosts over 50.
