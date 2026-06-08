-- ============================================================
-- 00_cold_open_real_apex.sql
-- Cold open: what a GENUINELY high-end Rome Airbnb costs.
--
-- The EUR 10,000+ listings are blocking prices, not real luxury.
-- A weak filter (number_of_reviews >= 5) does NOT separate the two:
-- some normal apartments carry a blocking price AND a real review
-- history (e.g. "Amazing apartment in Roma with kitchen", EUR 9,999,
-- 23 reviews). So we look only at long-established listings --
-- entire homes with 100+ reviews -- and rank by price.
--
-- IMPORTANT: reviews do NOT record the price paid at the time, so we
-- can only say these listings have hosted hundreds of stays since
-- ~2015 -- NOT that any guest paid the current nightly price.
--
-- Reads from the `rome` view created in 00_setup.sql.
-- number_of_reviews is still TEXT in the raw table, so it is cast
-- inline here (see CLAUDE.md "untyped columns" note).
-- ============================================================

SELECT
    name,
    neighbourhood_cleansed,
    NULLIF(number_of_reviews, '')::int  AS number_of_reviews,
    first_review_d,
    price_num
FROM rome_project.rome
WHERE NULLIF(number_of_reviews, '')::int >= 100
  AND room_type = 'Entire home/apt'
  AND price_num IS NOT NULL
ORDER BY price_num DESC NULLS LAST
LIMIT 20;

-- Top prices cluster just under EUR 5,000/night, all in Centro Storico
-- (verified 8 June 2026):
--   EUR 4,886  Family Apartment                         165 reviews, since 2015
--   EUR 4,750  Exclusive Penthouse in the heart of Rome 269 reviews, since 2015
--   EUR 4,750  Amazing City view in the Heart of Rome 4 294 reviews, since 2015
