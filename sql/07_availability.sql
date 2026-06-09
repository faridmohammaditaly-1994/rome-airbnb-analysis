-- ============================================================
-- 07_availability.sql
-- Q7 -- De facto hotels: how available are listings year-round?
--
-- If these were homes occasionally rented out, they'd be open only
-- part of the year. Instead, 61% are bookable more than 200 days a
-- year and 35% more than 300 -- these are rentals, not part-time
-- spare rooms.
--
-- availability_365 is TEXT in the raw table, so it is cast inline.
--
-- Reads from the `rome` view created in 00_setup.sql.
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE NULLIF(availability_365, '')::int >= 200)                               AS avail_200plus,
    ROUND(100.0 * COUNT(*) FILTER (WHERE NULLIF(availability_365, '')::int >= 200) / COUNT(*), 1)  AS pct_200plus,
    COUNT(*) FILTER (WHERE NULLIF(availability_365, '')::int >= 300)                               AS avail_300plus,
    ROUND(100.0 * COUNT(*) FILTER (WHERE NULLIF(availability_365, '')::int >= 300) / COUNT(*), 1)  AS pct_300plus
FROM rome_project.rome;

-- Result (verified 9 June 2026):
--   200+ days available:  23,022 listings   61.1%
--   300+ days available:  13,201 listings   35.1%
