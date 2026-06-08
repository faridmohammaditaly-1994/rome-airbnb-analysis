# Rome Airbnb Analysis

A data analysis of the short-term rental market in Rome, Italy, using the
public Inside Airbnb dataset.

This project explores the scale, geography, ownership concentration,
pricing, and legal compliance of Rome's Airbnb listings using SQL on
PostgreSQL. It is the supporting code for a YouTube video essay.

## Dataset

- **Source:** [Inside Airbnb](https://insideairbnb.com) (CC BY 4.0)
- **City:** Rome, Italy
- **Scrape date:** 15 September 2025
- **Rows:** 37,652 listings
- **File used:** `listings.csv` (detailed version, 79 columns)

The CSV itself is not committed to this repo — it is ~83 MB and can be
downloaded directly from Inside Airbnb.

## Tooling

- **Database:** PostgreSQL 16
- **Client:** DBeaver
- **Language:** SQL (PostgreSQL dialect)

## Repository structure

```
rome-airbnb-analysis/
├── sql/            -- All SQL scripts (setup + analysis queries)
├── data/           -- Data dictionary and notes (no raw data committed)
├── graphics/       -- Motion graphics exports
├── narration/      -- Voiceover scripts and notes
├── screenshots/    -- Query result screenshots used in the video
└── README.md
```

## How to reproduce

1. Install PostgreSQL and DBeaver.
2. Create a database called `rome_project` and a schema called `rome_project`.
3. Download `listings.csv` from Inside Airbnb's Rome page (15 Sept 2025 scrape).
4. Update the file path in `sql/00_setup.sql` to match where you saved the CSV.
5. Run `sql/00_setup.sql` end to end. It will:
   - Create the `listings` table
   - Load the CSV via `COPY`
   - Create the cleaned `rome` view used by all analysis queries
6. Run any analysis script in `sql/` against the `rome` view.

## Methodology notes

- All columns are loaded as `TEXT` to avoid type-inference errors during
  import. Type conversions are handled in the `rome` view.
- Revenue and occupancy figures (`estimated_revenue_l365d`,
  `estimated_occupancy_l365d`) are **estimates produced by Inside Airbnb**,
  not booking records. See their methodology for details.
- The `rome` view adds three derived columns:
  - `price_num` — numeric price (strips `$` and `,`)
  - `host_since_d` — host join date as `DATE`
  - `first_review_d` — first review date as `DATE`

## License

Code in this repository is released under the MIT License (see `LICENSE`).
The underlying dataset is published by Inside Airbnb under CC BY 4.0.
