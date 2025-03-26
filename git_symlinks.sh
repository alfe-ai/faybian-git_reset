#!/bin/bash

# setup_alfe_symlinks.sh
# Creates necessary symlinks for AlfeSH configuration
#
# TODO: These directory mappings should eventually be handled natively by AlfeSH
# rather than requiring external symlink setup.

#set -euo pipefail

#echo "Setting up AlfeSH symlinks..."

# Check if ~/.fayra exists
#if [ ! -d "$HOME/.fayra" ]; then
#    echo "Error: ~/.fayra directory does not exist"
#    echo "Please create the directory structure before running this script"
#    exit 1
#fi

# Check if ~/.fayra/Whimsical exists
#if [ ! -d "$HOME/.fayra/Whimsical" ]; then
#    echo "Error: ~/.fayra/Whimsical directory does not exist"
#    echo "Please create the complete directory structure before running this script"
#    exit 1
#fi

# Remove existing ~/.alfe if it's a symlink
#if [ -L "$HOME/.alfe" ]; then
#    echo "Removing existing ~/.alfe symlink..."
#    rm "$HOME/.alfe"
#elif [ -e "$HOME/.alfe" ]; then
#    echo "Error: ~/.alfe exists but is not a symlink"
#    echo "Please backup and remove this directory before running the script"
#    exit 1
#fi

# Create ~/.alfe symlink
#echo "Creating ~/.alfe symlink..."
#ln -s "$HOME/.fayra" "$HOME/.alfe"

# Setup git directory symlink
#if [ -L "$HOME/.fayra/git" ]; then
#    echo "Removing existing git symlink..."
#    rm "$HOME/.fayra/git"
#elif [ -e "$HOME/.fayra/git" ]; then
#    echo "Error: ~/.fayra/git exists but is not a symlink"
#    echo "Please backup and remove this directory before running the script"
#    exit 1
#fi

#echo "Creating git directory symlink..."
#ln -s "$HOME/.fayra/Whimsical/git" "$HOME/.fayra/git"

#echo "Symlink setup completed successfully!"
