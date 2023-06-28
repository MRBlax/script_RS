#!/bin/bash

# Database connection details
DB_HOST="instance-2"
DB_PORT="5432"
DB_NAME="users"
DB_USER="Testuser"
DB_PASSWORD="Testuser"

# Query to retrieve data from the users table
QUERY="SELECT * FROM users;"

# Execute the query and store the result in a variable
RESULT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "$QUERY" 2>&1)

# Check if the query was successful
if [ $? -ne 0 ]; then
  echo "Error executing the query: $RESULT"
  exit 1
fi

# Email details
RECIPIENT="recipient@example.com"
SUBJECT="Users Data"
BODY="Here is the data from the users table:\n\n$RESULT"

# Send the email
echo -e "$BODY" | mail -s "$SUBJECT" "$RECIPIENT"

echo "Data retrieved successfully and sent via email."
