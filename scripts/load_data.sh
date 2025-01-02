#!/usr/bin/env bash

# Change to project root directory if not already there
cd "$(dirname "$0")/.."

# Execute all SQL files in sql/dml directory in alphabetical order
for sql_file in $(ls -1 sql/dml/*.sql | sort);
do
    echo "Executing $sql_file..."
    mysql --local-infile=1 "$@" < "$sql_file"
done