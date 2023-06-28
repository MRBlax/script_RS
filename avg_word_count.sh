#!/bin/bash

# Function to calculate the average number of words per line in a file
calculate_average_words_per_line() {
  local file="$1"
  local total_words=0
  local total_lines=0
  
  while IFS='' read -r line || [[ -n "$line" ]]; do
    # Count the number of words in the line
    words=$(echo "$line" | wc -w)
    
    # Update the total number of words and lines
    total_words=$((total_words + words))
    total_lines=$((total_lines + 1))
  done < "$file"
  
  # Calculate the average number of words per line
  if [ "$total_lines" -gt 0 ]; then
    average=$(bc <<< "scale=2; $total_words / $total_lines")
    echo "$file: $average"
  else
    echo "$file: No lines found."
  fi
}

# Recursive function to find files with a .txt extension and calculate their averages
find_files_and_calculate_average() {
  local directory="$1"
  local highest_average=0
  local highest_file=""
  
  # Loop through all files and directories in the given directory
  for item in "$directory"/*; do
    if [ -f "$item" ]; then
      if [[ "$item" == *.txt ]]; then
        # Calculate the average for the current file
        average=$(calculate_average_words_per_line "$item")
        
        # Check if the current average is higher than the highest average found so far
        if (( $(echo "$average > $highest_average" | bc -l) )); then
          highest_average=$average
          highest_file="$item"
        fi
      fi
    elif [ -d "$item" ]; then
      # Recursively call the function for subdirectories
      find_files_and_calculate_average "$item"
    fi
  done
  
  # Display the file with the highest average word count
  if [ -n "$highest_file" ]; then
    echo "File with highest average word count:"
    echo "$highest_file: $highest_average"
  fi
}

# Check if a directory argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Check if the directory exists
directory="$1"
if [ ! -d "$directory" ]; then
  echo "Error: Directory '$directory' not found."
  exit 1
fi

# Call the recursive function to find files and calculate averages
find_files_and_calculate_average "$directory"
