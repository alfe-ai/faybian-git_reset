#!/bin/bash

git config advice.addIgnoredFile false

# Configure user identity if not set
#if [ -z "$(git config user.email)" ]; then
#    git config --global user.email "todo"
#fi
#if [ -z "$(git config user.name)" ]; then
#    git config --global user.name "todo"
#fi

echo "---Initial Git Status:"
git status
echo "---Adding *:"
git add .gitignore
git add *
echo "---Added, git status:"
git status
echo "---Git commit:"
commit_message=$(git status | sed -n '/Changes to be committed:/,/^$/p' | sed '1d;/^$/d;/.*git restore .*/d')
git commit -m "$commit_message"
echo "---Git push:"
# Push with 'set-upstream' if no upstream is set
branch=$(git rev-parse --abbrev-ref HEAD)
if git rev-parse --symbolic-full-name @{u} >/dev/null 2>&1; then
    push_output=$(git push 2>&1)
else
    push_output=$(git push --set-upstream origin "$branch" 2>&1)
fi

echo "$push_output"

# Check for repository moved message
if echo "$push_output" | grep -Fq "This repository moved. Please use the new location"; then
    # Extract new location from the next line containing 'git@'
    new_location=$(echo "$push_output" | grep -o 'git@[^ ]*')
    
    # Update the remote URL
    git remote set-url origin "$new_location"
    echo "Remote origin updated to $new_location"
    
    # Retry push
    if git rev-parse --symbolic-full-name @{u} >/dev/null 2>&1; then
        push_output=$(git push 2>&1)
    else
        push_output=$(git push --set-upstream origin "$branch" 2>&1)
    fi
    
    echo "$push_output"
fi

sleep 1

echo "---Final Git status:"
git status

# Generate .patch file and save to .patchfiles_ignore directory
commit_hash=$(git rev-parse HEAD)
commit_datetime=$(git show -s --format=%ct HEAD)
mkdir -p ".patchfiles_ignore/${commit_datetime}"
git show "$commit_hash" > ".patchfiles_ignore/${commit_datetime}/${commit_hash}.patch"

# Output the full path to the .patch file
patch_file_path=".patchfiles_ignore/${commit_datetime}/${commit_hash}.patch"
full_patch_file_path=$(realpath "$patch_file_path")
echo "Patch file created at: $full_patch_file_path"

echo "---Git log:"
git log -n 3 --pretty=format:'%H %ai %an <%ae> %s' --abbrev-commit

