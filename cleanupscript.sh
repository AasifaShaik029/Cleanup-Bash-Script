#!/bin/bash

# Set the threshold for free disk space in kilobytes
THRESHOLD=100000  # Adjust this value as needed

# Define the directory to clean up (change this to your desired directory)
DIRECTORY_TO_CLEAN="/home/ubuntu/filelogs"

# Check free disk space
free_space=$(df -k "$DIRECTORY_TO_CLEAN" | awk 'NR==2 {print $4}')

# Check if free space is below the threshold
if [ "$free_space" -lt "$THRESHOLD" ]; then
    echo "Low disk space detected. Cleaning up..."

    # Define a list of file extensions to consider for deletion
    # Add or remove extensions as needed
    FILE_EXTENSIONS_TO_CLEAN="log tmp"

    # Find and delete files older than 1 minute, excluding certain directories
    find "$DIRECTORY_TO_CLEAN" -type d \( -path "/proc" -o -path "/sys" -o -path "/dev" -o -path "/boot" \) -prune -o -type f -name "*.*" -mmin +1 -exec rm {} \;

    # Find and delete files with specified extensions
    for ext in $FILE_EXTENSIONS_TO_CLEAN; do
        find "$DIRECTORY_TO_CLEAN" -type d \( -path "/proc" -o -path "/sys" -o -path "/dev" -o -path "/boot" \) -prune -o -type f -name "*.$ext" -exec rm {} \;
    done

    echo "Cleanup complete."
else
    echo "Disk space is above the threshold. No action needed."
fi
