# Netflix Data Visualization

An analysis of Netflix's catalogue of movies and TV shows: 6,234 titles, up to 2019. A Python notebook prepares, cleans and explores the data, then charts the **most watched genres** and the **distribution of ratings** with Seaborn, Pyplot and Matplotlib. An R script recreates the ratings chart with ggplot2.

## Files

| File                     | Description                                                                                              |
| ------------------------ | -------------------------------------------------------------------------------------------------------- |
| `netflix_analysis.ipynb` | Python notebook: data preparation, cleaning, exploration and visualization (saved with outputs)          |
| `ratings_distribution.R` | R script: recreates the ratings distribution chart with ggplot2                                          |
| `netflix_data.zip`       | The provided Netflix dataset, zipped to keep the submission small                                        |
| `charts/`                | Saved charts: `top_genres.png`, `ratings_distribution.png` (Python) and `ratings_distribution_r.png` (R) |
| `.gitignore`             | Keeps generated and system files out of the repository                                                   |

## Requirements

- **Python 3.8+** with JupyterLab, pandas, Matplotlib and Seaborn:

  ```
  pip install jupyterlab pandas matplotlib seaborn
  ```

- **R 4.0+** with ggplot2:

  ```r
  install.packages("ggplot2")
  ```

## How to run

Keep all files in the same folder.

### 1. Python notebook

```bash
jupyter lab
```

Open `netflix_analysis.ipynb`, then choose **Run → Run All Cells**. The notebook works through four steps:

1. **Data preparation:** extracts the CSV from `netflix_data.zip` and renames it to `Netflix_shows_movies.csv`.
2. **Data cleaning:**

- Missing `director`, `cast` and `country` values (8–32% of rows) are filled with `"Unknown"`.
- The 20 rows (0.3%) missing `date_added` or `rating` are dropped.
- `UR` (Unrated) is merged into `NR` (Not Rated).
- Dates are converted, and duration is split into minutes for movies and seasons for TV shows.

1. **Data exploration:**

- Summary statistics.
- The Movie/TV split.
- Release-year statistics.
- Durations.
- Titles added per year.
- Top countries.
- Movie runtime by rating.

1. **Data visualization:** draws two charts and saves them to `charts/`:

- the top 10 genres.
- the distribution of ratings, split by Movie vs TV Show.

### 2. R script

From the same folder:

```bash
Rscript ratings_distribution.R
```

Or open it in RStudio, set the working directory to this folder (**Session → Set Working Directory → To Source File Location**) and click **Source**.

The script does its own unzip-and-rename if the notebook hasn't been run yet. It applies the same cleaning to the ratings, prints a table of ratings by type, and saves the chart to `charts/ratings_distribution_r.png`. RStudio also displays it.

## Interpreting the results

- **"Most watched" genres:** the dataset has no viewing figures, so the number of titles per genre is used as a stand-in for popularity. Titles can list several genres, and each one is counted.
  - **International Movies** (1,927) and **Dramas** (1,622) lead, followed by Comedies and International TV Shows.
- **Ratings:**
  - **TV-MA** and **TV-14** make up 60% of the catalogue, so Netflix leans toward mature and teen audiences.
  - Theatrical film ratings (`R`, `PG-13`, `PG`, `G`) apply almost entirely to movies.
  - Children's ratings are the one area where TV shows outnumber movies.
- **Catalogue:**
  - About 69% movies and 31% TV shows, mostly recent: the median release year is 2016.
  - Movies have a median runtime of 98 minutes, and most TV shows have a single season.
