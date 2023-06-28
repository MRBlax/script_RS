#!/bin/bash

file_name="$1"

if [ -e "$file_name" ]; then
  echo "File exists."
else
  echo "File not found."
fi
