#!/bin/bash

# Check if correct number of arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <path_to_repo> <new_remote_url> <branch_name>"
    exit 1
fi

# Assign arguments to variables
REPO_PATH=$1
NEW_REMOTE_URL=$2
BRANCH_NAME=$3

# Check if REPO_PATH is a valid directory
if [ ! -d "$REPO_PATH" ]; then
    echo "Error: $REPO_PATH is not a valid directory."
    exit 1
fi

# Navigate to the repository
cd "$REPO_PATH" || exit 1

# Check if it's a git repository
if [ ! -d ".git" ]; then
    echo "Error: $REPO_PATH is not a git repository."
    exit 1
fi

# Check if 'origin' remote exists
if git remote | grep -q '^origin$'; then
    # Change the remote URL
    git remote set-url origin "$NEW_REMOTE_URL"
    echo "Changed remote 'origin' to $NEW_REMOTE_URL"
else
    # Add the remote
    git remote add origin "$NEW_REMOTE_URL"
    echo "Added remote 'origin' as $NEW_REMOTE_URL"
fi

# Set the local branch to the specified branch name
git branch -M "$BRANCH_NAME"

# Check if there are any commits
if [ -z "$(git rev-parse --verify HEAD 2>/dev/null)" ]; then
    echo "No commits found. Creating an initial commit."
    touch README.md
    git add README.md
    git commit -m "Initial commit"
fi

# Push to the new remote repository
git push -u origin "$BRANCH_NAME"
