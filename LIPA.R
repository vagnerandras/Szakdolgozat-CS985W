# Load necessary libraries
library(ape)         # For phylogenetic tree manipulation
library(phylobase)   # For handling phylo4d objects
library(phylosignal) # For lipaMoran and plotting functions

# === Load Data ===
# Load phylogenetic tree
tree <- read.tree("/scratch/vandras/vax/JiPengLi/species.tree.nwk")

# Load trait data (CSV format, species names as row names)
traits <- read.csv("/scratch/vandras/vax/wax synthase copynum table - Sheet11 (1).csv", row.names = 1)

# Ensure traits are aligned with the tree tips
traits <- traits[match(tree$tip.label, rownames(traits)), , drop = FALSE]

# Convert categorical traits to numeric
traits$LifestyleTraitNumeric <- as.numeric(factor(traits$LifestyleTrait))
traits$MorphologicalTraitNumeric <- as.numeric(factor(traits$MorphologicalTrait))

# Convert the data to a phylo4d object
phylo_data <- phylo4d(tree, traits)

# === Compute Local Moran's I (LIPA) ===
# Example: Compute LIPA for the LifestyleTrait
local_i_lifestyle <- lipaMoran(
  phylo_data,
  trait = "LifestyleTraitNumeric",  # Replace with your trait of interest
  prox.phylo = "nNodes",           # Use phylogenetic proximity based on nodes
  as.p4d = TRUE                    # Return a phylo4d object for plotting
)

# === Extract p-values and Assign Colors ===
# Extract p-values for nodes (LifestyleTrait)
points_col_lifestyle <- lipaMoran(
  phylo_data,
  trait = "LifestyleTraitNumeric",
  prox.phylo = "nNodes"
)$p.value

# Assign colors based on significance
points_col_lifestyle <- ifelse(points_col_lifestyle < 0.05, "red", "black")  # Red for significant nodes

# === Visualize Local Moran's I on Phylogeny (LifestyleTrait) ===
pdf("/scratch/vandras/vax/LifestyleTrait_LIPA_Plot.pdf", width = 10, height = 18)
par(mar = c(12, 4, 4, 2), las = 2)
dotplot.phylo4d(
  local_i_lifestyle,
  dot.col = points_col_lifestyle,   # Node colors based on significance
  main = "Local Moran's I (LIPA) for LifestyleTrait", cex = 0.5
)
dev.off()

# === Repeat for MorphologicalTrait ===
local_i_morph <- lipaMoran(
  phylo_data,
  trait = "MorphologicalTraitNumeric",  # Replace with your trait of interest
  prox.phylo = "nNodes",
  as.p4d = TRUE
)

points_col_morph <- lipaMoran(
  phylo_data,
  trait = "MorphologicalTraitNumeric",
  prox.phylo = "nNodes"
)$p.value

points_col_morph <- ifelse(points_col_morph < 0.05, "red", "black")

pdf("/scratch/vandras/vax/MorphologicalTrait_LIPA_Plot.pdf", width = 10, height = 18)
par(mar = c(12, 4, 4, 2), las = 2)
dotplot.phylo4d(
  local_i_morph,
  dot.col = points_col_morph,
  main = "Local Moran's I (LIPA) for MorphologicalTrait", cex = 0.5
)
dev.off()


# === Compute Local Moran's I (LIPA) ===
# Example: Compute LIPA for the CopyNumbers
local_i_lifestyle <- lipaMoran(
  phylo_data,
  trait = "CopyNumbers",  # Replace with your trait of interest
  prox.phylo = "nNodes",           # Use phylogenetic proximity based on nodes
  as.p4d = TRUE                    # Return a phylo4d object for plotting
)

# === Extract p-values and Assign Colors ===
# Extract p-values for nodes (CopyNumbers)
points_col_lifestyle <- lipaMoran(
  phylo_data,
  trait = "CopyNumbers",
  prox.phylo = "nNodes"
)$p.value

# Assign colors based on significance
points_col_lifestyle <- ifelse(points_col_lifestyle < 0.05, "red", "black")  # Red for significant nodes

# === Visualize Local Moran's I on Phylogeny (LifestyleTrait) ===
pdf("/scratch/vandras/vax/CopyNumbers_LIPA_Plot.pdf", width = 10, height = 18)
par(mar = c(12, 4, 4, 2), las = 2)
dotplot.phylo4d(
  local_i_lifestyle,
  dot.col = points_col_lifestyle,   # Node colors based on significance
  main = "Local Moran's I (LIPA) for CopyNumbers", cex = 0.5
)
dev.off()

