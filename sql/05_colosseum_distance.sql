-- ============================================================
-- 05_colosseum_distance.sql
-- Q5 -- The Colosseum premium: median price by distance band.
--
-- Median nightly price falls with distance from the Colosseum
-- (41.8902, 12.4922): from ~EUR 200 within 500 m to ~EUR 90 past
-- 10 km -- more than double, just for proximity.
--
-- Haversine distance in km, no PostGIS needed. latitude/longitude
-- are TEXT in the raw table, so they are cast inline.
-- Entire homes only; prices >= EUR 2,000 trimmed as outliers.
--
-- Reads from the `rome` view created in 00_setup.sql.
-- ============================================================

SELECT
    CASE
        WHEN d_km < 0.5 THEN '1 - <0.5 km'
        WHEN d_km < 1   THEN '2 - 0.5-1 km'
        WHEN d_km < 2   THEN '3 - 1-2 km'
        WHEN d_km < 5   THEN '4 - 2-5 km'
        WHEN d_km < 10  THEN '5 - 5-10 km'
        ELSE                 '6 - 10 km+'
    END                              AS distance_band,
    COUNT(*)                         AS listings,
    ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY price_num)) AS median_price
FROM (
    SELECT price_num,
           6371 * 2 * asin(sqrt(
               power(sin(radians(NULLIF(latitude, '')::numeric - 41.8902) / 2), 2) +
               cos(radians(41.8902)) * cos(radians(NULLIF(latitude, '')::numeric)) *
               power(sin(radians(NULLIF(longitude, '')::numeric - 12.4922) / 2), 2)
           )) AS d_km
    FROM rome_project.rome
    WHERE room_type = 'Entire home/apt'
      AND price_num IS NOT NULL
      AND price_num < 2000          -- trim extreme outliers
) t
GROUP BY distance_band
ORDER BY distance_band;

-- Result (verified 9 June 2026):
--   <0.5 km     527   EUR 200
--   0.5-1 km   1508   EUR 180
--   1-2 km     6392   EUR 180
--   2-5 km    12319   EUR 137
--   5-10 km    3479   EUR  95
--   10 km+     1671   EUR  90   (EUR 200 / EUR 90 = 2.2x premium)
