-- ============================================================
-- 00_cold_open_blocking_prices.sql
-- Cold open: the six listings priced at EUR 10,000+/night.
--
-- These are "blocking prices" -- hosts setting an absurd number
-- to hide a listing from search without taking it down.
-- 4 of the 6 have zero reviews; the other 2 have just one or two.
--
-- Reads from the `rome` view created in 00_setup.sql.
-- number_of_reviews is still TEXT in the raw table, so it is cast
-- inline here (see CLAUDE.md "untyped columns" note).
-- ============================================================

SELECT
    name,
    neighbourhood_cleansed,
    room_type,
    NULLIF(number_of_reviews, '')::int  AS number_of_reviews,
    price_num
FROM rome_project.rome
WHERE price_num >= 10000
ORDER BY price_num DESC;

-- Result: 6 listings (verified 8 June 2026):
--   EUR 10,515  Rzym Golden Apartments               I Centro Storico         0 reviews
--   EUR 10,007  Awesome apartment in Roma with WiFi  III Monte Sacro          0 reviews
--   EUR 10,002  GLI aranci Wohnung                   III Monte Sacro          1 review
--   EUR 10,000  gardenvaticanflat83                  I Centro Storico         2 reviews
--   EUR 10,000  Amy Home                             V Prenestino/Centocelle  0 reviews
--   EUR 10,000  Tripla                               XIV Monte Mario          0 reviews (private room)
