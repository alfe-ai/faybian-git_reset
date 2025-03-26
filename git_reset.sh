#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 5 ]; then
    echo "Usage: $0 <path_to_repo> <commit_hash> <github_username> <project_name> <branch_name_to_push>"
    exit 1
fi

# Store the arguments
REPO_PATH=$1
COMMIT_HASH=$2
GITHUB_USERNAME=$3
PROJECT_NAME=$4
MAIN_OR_MASTER=$5

# Check if the provided path is a directory
if [ ! -d "$REPO_PATH" ]; then
    echo "Error: $REPO_PATH is not a valid directory."
        exit 1
fi

# Change to the repository directory
cd "$REPO_PATH" || exit 1

# Check if it's a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: $REPO_PATH is not a git repository."
    exit 1
fi

# Set the 'origin' remote to the SSH URL
NEW_URL="git@github.com:$GITHUB_USERNAME/$PROJECT_NAME.git"
git remote set-url origin "$NEW_URL"
echo "Changed remote 'origin' URL to use SSH: $NEW_URL"

# Fetch the latest changes
git fetch origin

# Check if the provided commit hash exists
if ! git cat-file -e "$COMMIT_HASH^{commit}" 2> /dev/null; then
    echo "Error: The provided commit hash does not exist in this repository."
    exit 1
fi

# Reset to the specified commit
git reset --hard "$COMMIT_HASH"

# Ask for confirmation before pushing
read -p "Are you sure you want to force push this change to the remote repository? ( $NEW_URL ) (Y/n): " confirm

# Convert the input to lowercase for easier comparison
confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

# Check the user's response
if [[ $confirm == "y" || $confirm == "yes" || $confirm == "" ]]; then
    # Force push the changes to the remote repository
    git push origin +HEAD:$MAIN_OR_MASTER
    echo "Repository has been reset to commit $COMMIT_HASH and force pushed to remote."
else
    echo "Operation cancelled. No changes were pushed to the remote repository."
fi
