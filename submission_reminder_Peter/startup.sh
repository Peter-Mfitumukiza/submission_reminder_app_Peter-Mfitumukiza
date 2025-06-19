#!/bin/bash

echo "=== Starting Submission Reminder Application ==="
echo "Initializing application..."
echo

# Check if all required files exist
required_files=("config/config.env" "modules/functions.sh" "assets/submissions.txt" "reminder.sh")
missing_files=()

for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        missing_files+=("$file")
    fi
done

if [[ ${#missing_files[@]} -gt 0 ]]; then
    echo "Error: Missing required files:"
    for file in "${missing_files[@]}"; do
        echo "  - $file"
    done
    echo "Please ensure all files are in place before running the application."
    exit 1
fi

echo "All required files found. Starting reminder system..."
echo

# Run the reminder script
./reminder.sh

echo
echo "=== Reminder check complete ==="
