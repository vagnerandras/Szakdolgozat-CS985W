# Set the working directory
setwd("/scratch/vandras/vax/IPRG189")

# List all files with the .tsv extension
file_list <- list.files(pattern = "\\.tsv$")

# Initialize a vector to store unique protein IDs
unique_proteins <- c()

# Loop over each file and filter lines containing "IPR032805"
for (file in file_list) {
  # Read the file content as a data frame with more robust settings
  data <- tryCatch(
    read.table(file, as.is = TRUE, header = FALSE, fill = TRUE, sep = "\t", quote = "", comment.char = ""),
    error = function(e) NULL
  )
  
  # Skip this file if reading it failed
  if (is.null(data)) {
    cat("Skipping file due to read error:", file, "\n")
    next
  }
  
  # Ensure the file has at least 12 columns
  if (ncol(data) >= 12) {
    # Filter rows where the 12th column is "IPR032805"
    filtered_rows <- data[data[, 12] == "IPR032805", ]
    
    # Extract unique protein IDs (from the first column)
    protein_ids <- unique(filtered_rows[, 1])
    
    # Combine with the list of unique proteins
    unique_proteins <- unique(c(unique_proteins, protein_ids))
  } else {
    cat("File has less than 12 columns, skipping:", file, "\n")
  }
}

# Create a data frame with the unique protein IDs
output_df <- data.frame(Protein_ID = unique_proteins)

# Print the output to confirm
print(output_df)

# Save the output to a CSV file
write.table(output_df, "/scratch/vandras/vax/unique_protein_ids.tsv", row.names = FALSE)

# Inform the user
cat("CSV file 'unique_protein_ids.csv' created successfully.\n")

