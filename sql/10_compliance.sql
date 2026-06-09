-- ============================================================
-- 10_compliance.sql
-- Q10 -- Operating outside the rules: licences and ghost listings.
--
-- Rome/Lazio require a regional licence code on every short-term
-- rental. 8.1% (3,063 listings) show no licence at all -- roughly
-- one in twelve, operating outside the rules.
-- Separately, 14.3% (5,397) have never received a single review --
-- "ghost" listings that may never host a real guest. NOTE: zero
-- reviews is NOT a legal violation (many are simply new), so the
-- two figures are reported separately, not summed into one claim.
--
-- number_of_reviews is TEXT in the raw table, so it is cast inline.
--
-- Reads from the `rome` view created in 00_setup.sql.
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE license IS NULL OR license = '')                                     AS no_license,
    ROUND(100.0 * COUNT(*) FILTER (WHERE license IS NULL OR license = '') / COUNT(*), 1)        AS pct_no_license,
    COUNT(*) FILTER (WHERE NULLIF(number_of_reviews, '')::int = 0)                              AS zero_reviews,
    ROUND(100.0 * COUNT(*) FILTER (WHERE NULLIF(number_of_reviews, '')::int = 0) / COUNT(*), 1) AS pct_zero_reviews
FROM rome_project.rome;

-- Result (verified 9 June 2026):
--   no_license:    3,063    8.1%   (~ one in twelve, operating outside the rules)
--   zero_reviews:  5,397   14.3%   (ghost listings -- separate, not a legal issue)
--   (for reference, the union of the two = 7,237 = 19.2%, but they are NOT
--    combined in the narration, since zero reviews is not a violation.)
