# Online Sales SQL Analysis

An educational DuckDB analysis of Kaggle's
[`shreyanshverma27/online-sales-dataset-popular-marketplace-data`](https://www.kaggle.com/datasets/shreyanshverma27/online-sales-dataset-popular-marketplace-data).
The CSV is not tracked in this repository.

## Contents

- [`sql/`](sql): exploration, data-quality, KPI, monthly, category, region and
  payment queries.
- [`notebooks/online-sale-sql.ipynb`](notebooks/online-sale-sql.ipynb): the
  recorded DuckDB workflow and outputs.

The stored notebook output reports 240 transactions and total revenue of
`80,567.85`. Revenue is not profit, and these are recorded sample-dataset
outputs rather than a claim about a broader market.

Load a local copy of the Kaggle CSV into DuckDB, then run the SQL files in their
numeric order. The notebook records the original analysis environment and is the
best reference for table loading details.

AI tools were used to assist with SQL review and documentation. Queries,
calculations and reported findings were checked against the recorded dataset
outputs.
