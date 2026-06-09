-- ============================================================
-- 01_room_types.sql
-- Q1 -- Room type breakdown: how many listings, and what are they?
--
-- 75% of Rome's listings are entire homes -- not spare rooms.
-- The "home sharing" framing doesn't hold.
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
