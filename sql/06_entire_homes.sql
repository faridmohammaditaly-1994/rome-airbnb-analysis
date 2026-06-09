-- ============================================================
-- 06_entire_homes.sql
-- Q6 -- Homes, not spare rooms: the room-type mix.
--
-- Same breakdown as Q1, surfaced here to make the human-cost point:
-- 75% of listings are entire apartments and only ~0.3% are shared
-- rooms. The "stay in someone's spare room" model is effectively
-- extinct in Rome -- these are empty homes run as businesses.
-- (~1% are actual hotel rooms, now listed on Airbnb too.)
--
-- Reads from the `rome` view created in 00_setup.sql.
-- ============================================================

SELECT
    room_type,
    COUNT(*)                                            AS listings,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)  AS pct
FROM rome_project.rome
GROUP BY room_type
ORDER BY listings DESC;

-- Result (verified 9 June 2026):
--   Entire home/apt   28,294   75.1%
--   Private room       8,887   23.6%
--   Hotel room           370    1.0%
--   Shared room          101    0.3%
