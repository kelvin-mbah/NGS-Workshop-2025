# =====================================================
# MTB Genome Annotation Analysis & Visualization Script
# =====================================================

# Load Required Packages
library(ggplot2)    # for plotting
library(dplyr)      # for data manipulation
library(stringr)    # for string operations

# --------------------------
# Load Annotation Data
# --------------------------
df <- read.delim("PROKKA_09212025.tsv")  # Load Prokka annotation table

# --------------------------
# 1. COG Distribution - All
# --------------------------
ggplot(na.omit(df), aes(x = COG)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Gene Counts by COG Category", x = "COG ID", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# --------------------------
# 2. Top 20 COGs - Bar Plot
# --------------------------
top_cogs <- df %>%
  filter(!is.na(COG)) %>%
  count(COG, sort = TRUE) %>%
  top_n(20, n)

# Linear Scale
ggplot(top_cogs, aes(x = reorder(COG, -n), y = n)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Top 20 COG Categories", x = "COG ID", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Logarithmic Scale
ggplot(top_cogs, aes(x = reorder(COG, -n), y = n)) +
  geom_bar(stat = "identity", fill = "darkred") +
  scale_y_log10() +
  labs(title = "Top 20 COG Categories (Log Scale)", x = "COG ID", y = "Count (log10)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# --------------------------
# 3. Feature Type Distribution
# --------------------------
ggplot(df, aes(x = ftype)) +
  geom_bar(fill = "skyblue") +
  labs(title = "Feature Type Distribution", x = "Feature Type", y = "Count") +
  theme_minimal()

# --------------------------
# 4. Top 20 EC Numbers
# --------------------------
df %>%
  filter(!is.na(EC_number) & EC_number != "") %>%
  count(EC_number, sort = TRUE) %>%
  top_n(20, n) %>%
  ggplot(aes(x = reorder(EC_number, -n), y = n)) +
  geom_bar(stat = "identity", fill = "darkolivegreen") +
  labs(title = "Top 20 EC Numbers", x = "EC Number", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# --------------------------
# 5. Top EC Numbers + Enzyme Classes
# --------------------------
ec_summary <- df %>%
  filter(!is.na(EC_number) & EC_number != "") %>%
  count(EC_number, sort = TRUE) %>%
  top_n(20, n) %>%
  mutate(
    EC_class = str_extract(EC_number, "^[0-9]"),
    EC_class_name = recode(EC_class,
                           "1" = "Oxidoreductases",
                           "2" = "Transferases",
                           "3" = "Hydrolases",
                           "4" = "Lyases",
                           "5" = "Isomerases",
                           "6" = "Ligases",
                           "7" = "Translocases")
  )

ggplot(ec_summary, aes(x = reorder(EC_number, -n), y = n, fill = EC_class_name)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 20 EC Numbers by Enzyme Class", x = "EC Number", y = "Gene Count", fill = "Enzyme Class") +
  scale_fill_brewer(palette = "Set2") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# --------------------------
# 6. EC Numbers + Function Annotation
# --------------------------
ec_summary <- df %>%
  filter(!is.na(EC_number) & EC_number != "") %>%
  group_by(EC_number, product) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  group_by(EC_number) %>%
  slice_max(order_by = count, n = 1) %>%
  ungroup() %>%
  top_n(20, count) %>%
  mutate(
    EC_class = str_extract(EC_number, "^[0-9]"),
    EC_class_name = recode(EC_class,
                           "1" = "Oxidoreductases",
                           "2" = "Transferases",
                           "3" = "Hydrolases",
                           "4" = "Lyases",
                           "5" = "Isomerases",
                           "6" = "Ligases",
                           "7" = "Translocases"),
    label = paste(EC_number, "-", product)
  )

ggplot(ec_summary, aes(x = reorder(label, -count), y = count, fill = EC_class_name)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 20 EC Numbers with Functional Annotation", x = "EC Number + Function", y = "Gene Count", fill = "Enzyme Class") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# --------------------------
# 7. Distribution of Gene Lengths
# --------------------------
ggplot(df, aes(x = length_bp)) +
  geom_histogram(fill = "darkgreen", bins = 30) +
  labs(title = "Distribution of Gene Lengths", x = "Length (bp)", y = "Count")
