# Netflix Data Visualization - ratings distribution in R
#
# Recreates the notebook's "Distribution of content ratings" chart with ggplot2.
# The script prepares the data itself (unzip + rename), so it can run on its own.
#
# Requires ggplot2:  install.packages("ggplot2")

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
ZIP_FILE    <- "netflix_data.zip"
DATA_FILE   <- "Netflix_shows_movies.csv"
OUTPUT_FILE <- file.path("charts", "ratings_distribution_r.png")
TYPE_COLORS <- c("Movie" = "#2a78d6", "TV Show" = "#eb6834")   # Same palette as the notebook

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------

# Unzip the dataset and rename it, unless the notebook has already done so.
prepare_data <- function(zip_file, data_file) {
  if (file.exists(data_file)) return(data_file)
  if (!file.exists(zip_file)) stop("'", zip_file, "' not found. Keep it in the same folder as this script.")

  extracted <- unzip(zip_file, exdir = ".")
  csv_file  <- extracted[grepl("\\.csv$", extracted, ignore.case = TRUE)]
  if (length(csv_file) != 1) stop("Expected one CSV inside '", zip_file, "'.")
  if (!file.rename(csv_file, data_file)) stop("Could not rename '", csv_file, "' to '", data_file, "'.")
  data_file
}

# Load the data and apply the same cleaning as the notebook for the columns used here.
load_ratings <- function(data_file) {
  netflix <- read.csv(data_file, na.strings = c("", "NA"), stringsAsFactors = FALSE)
  netflix <- netflix[!is.na(netflix$rating) & !is.na(netflix$date_added), ]
  netflix$rating[netflix$rating == "UR"] <- "NR"          # Unrated and Not Rated mean the same

  # Order ratings from most to least common
  rating_order <- names(sort(table(netflix$rating), decreasing = TRUE))
  netflix$rating <- factor(netflix$rating, levels = rating_order)
  netflix
}

# Build the grouped bar chart of ratings by content type.
plot_ratings <- function(netflix) {
  ggplot(netflix, aes(x = rating, fill = type)) +
    geom_bar(position = position_dodge2(preserve = "single", padding = 0.08), width = 0.8) +
    scale_fill_manual(values = TYPE_COLORS, name = NULL) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
    labs(title = "Distribution of content ratings on Netflix",
         x = "Rating", y = "Number of titles") +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(face = "bold"),
          panel.grid.major.x = element_blank(),
          legend.position = "top")
}

# ---------------------------------------------------------------------------
# Main program
# ---------------------------------------------------------------------------
main <- function() {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("ggplot2 is not installed. Run install.packages(\"ggplot2\") first.")
  }
  library(ggplot2)

  netflix <- load_ratings(prepare_data(ZIP_FILE, DATA_FILE))
  cat("Titles plotted:", nrow(netflix), "\n")
  print(table(netflix$rating, netflix$type))

  chart <- plot_ratings(netflix)
  if (interactive()) print(chart)        # Show in RStudio; Rscript just saves the file
  dir.create(dirname(OUTPUT_FILE), showWarnings = FALSE)
  ggsave(OUTPUT_FILE, chart, width = 11, height = 5.5, dpi = 150, bg = "white")
  cat("Chart saved to", OUTPUT_FILE, "\n")
}

tryCatch(main(), error = function(e) message("Error: ", conditionMessage(e)))
