#!/bin/bash

# Define the path to the input file
input_file="path/to/your/file.txt"

# Define the common English words to be excluded from counting
excluded_words=("the" "and" "in")

# Read the file, convert all words to lowercase, and split them into an array
words=($(tr '[:upper:]' '[:lower:]' < "$input_file" | tr -cs '[:alnum:]' '\n'))

# Declare an associative array to store word counts
declare -A word_counts

# Loop through each word and count its occurrences
for word in "${words[@]}"; do
  # Exclude common English words and empty strings
  if [[ ! " ${excluded_words[@]} " =~ " $word " && -n $word ]]; then
    ((word_counts[$word]++))
  fi
done

# Sort the words based on their counts in descending order
sorted_words=$(for word in "${!word_counts[@]}"; do
  echo "${word_counts[$word]} $word"
done | sort -nr)

# Display the word count in descending order of frequency
echo "Word Count:"
echo "$sorted_words"
