#!/usr/bin/env bash

# Change to project root directory if not already there
cd "$(dirname "$0")/.."

# Execute all SQL files in sql/ddl directory in alphabetical order
for sql_file in $(ls -1 sql/ddl/*.sql | sort);
do
    echo "Executing $sql_file..."
    mysql "$@" < "$sql_file"
done
