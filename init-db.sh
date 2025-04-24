#!/bin/bash
set -e

echo "Starting database initialization..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE giphy_scraper_repo;
    CREATE DATABASE graphql_api_assignment_repo_test;
    CREATE DATABASE giphy_scraper_repo_test;
    \l
EOSQL
echo "Database initialization completed!"