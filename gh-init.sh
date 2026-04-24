#!/bin/bash

# Extract the name of the current directory
REPO_NAME=$(basename "$PWD")

echo "--- Fabricating repository: $REPO_NAME ---"

# Initialize local git if not already done
git init -b main

# Stage and commit all files
git add .
git commit -m "Initial commit via automation"

# Create the GitHub repo and push
# Change --public to --private if you prefer secrecy
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push

echo "--- Success! Your hoard is secured at GitHub. ---"
