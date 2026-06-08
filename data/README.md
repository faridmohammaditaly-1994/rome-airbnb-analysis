# Data

This folder documents the dataset used in this analysis. **The data file
itself is not committed to the repo** (it's large, and Inside Airbnb's
license is best honored by sending people to the source). Follow the steps
below to obtain the identical file and load it.

## What dataset this is

- **Source:** Inside Airbnb — https://insideairbnb.com/get-the-data/
- **City:** Rome, Italy
- **Scrape date:** 15 September 2025
- **File:** `listings.csv.gz` (the **detailed** listings file — ~75 columns,
  one row per listing)
- **License:** Creative Commons CC BY 4.0

> ⚠️ Use the **detailed** `listings.csv.gz`, *not* the smaller summary
> `listings.csv` (a "Summary information" file with only ~16 columns). This
> project relies on columns — `description`, `amenities`,
> `estimated_revenue_l365d`, `review_scores_*`, `license`, and more — that
> only exist in the detailed file.

## How to obtain it

1. Go to https://insideairbnb.com/get-the-data/
2. Scroll to the **Rome, Lazio, Italy** section.
3. In the data table, find the row for the **15 September 2025** scrape.
4. Download **`listings.csv.gz`** (the detailed file, listed under "Detailed
   Listings data").
5. Decompress it to `listings.csv`:
   ```bash
   gunzip listings.csv.gz
   ```

> Inside Airbnb publishes only the most recent scrape per city on the main
> page. If 15 Sept 2025 is no longer listed, the verification steps below let
> you confirm whether any file you have matches the one used here.

## Where to put it

Place the decompressed file at:

```
data/listings.csv
```

Then point the loader at it. In `sql/00_setup.sql`, STEP 4 has the `COPY`
path — update it to your local absolute path to `data/listings.csv`.

(The file is git-ignored on purpose; only this README is committed.)

## How to verify it's the same file

Run these from the `data/` folder and compare against the expected values.

**1. Row count** — should be **37,652 listings**. Some text fields contain
newlines, so a raw line count will be inflated; the authoritative check is
after loading, via `sql/00_setup.sql` STEP 5:

```sql
SELECT COUNT(*) FROM rome_project.rome;  -- Expected: 37652
```

**2. Checksum** — compute a hash of your file and compare to the exact file
used to produce this analysis:

```bash
shasum -a 256 listings.csv
```

- **SHA-256:** `412811febba6f550044b03f79c372eaab96e9ff79ac311ea113c4e98079e4715`

If your hash matches, you have a byte-for-byte identical file.

**3. Spot-check the apex** — after loading, this confirms you have the same
data we did:

```sql
-- The real most-expensive bookable listing: €4,750/night,
-- Centro Storico, 269 reviews since 2015.
SELECT name, neighbourhood_cleansed, price, number_of_reviews
FROM rome_project.rome
WHERE number_of_reviews >= 5
  AND room_type = 'Entire home/apt'
  AND price_num IS NOT NULL
ORDER BY price_num DESC NULLS LAST
LIMIT 5;
```

## Citation

> Inside Airbnb. *Rome, Italy listings data*, scraped 15 September 2025.
> Licensed under CC BY 4.0. https://insideairbnb.com
