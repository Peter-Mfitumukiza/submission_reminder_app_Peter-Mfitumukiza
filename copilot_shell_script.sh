#!/bin/bash

echo "=== Submission Reminder App Copilot ==="
echo "This script helps you update the assignment name for checking submissions."
echo

# Function to find the submission reminder directory
find_app_directory() {
    local app_dirs=($(find . -maxdepth 1 -type d -name "submission_reminder_*" 2>/dev/null))
    
    if [[ ${#app_dirs[@]} -eq 0 ]]; then
        echo "Error: No submission reminder app directory found!"
        echo "Please make sure you have run create_environment.sh first."
        return 1
    elif [[ ${#app_dirs[@]} -eq 1 ]]; then
        echo "${app_dirs[0]}"
        return 0
    else
        echo "Multiple submission reminder directories found:"
        for i in "${!app_dirs[@]}"; do
            echo "$((i+1)). ${app_dirs[i]}"
        done
        echo
        read -p "Please select a directory (1-${#app_dirs[@]}): " choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#app_dirs[@]} ]]; then
            echo "${app_dirs[$((choice-1))]}"
            return 0
        else
            echo "Error: Invalid selection!"
            return 1
        fi
    fi
}

# Find the app directory
app_dir=$(find_app_directory)
if [[ $? -ne 0 ]]; then
    exit 1
fi

config_file="$app_dir/config/config.env"
startup_script="$app_dir/startup.sh"

# Check if config file exists
if [[ ! -f "$config_file" ]]; then
    echo "Error: Config file not found at $config_file"
    echo "Please ensure the submission reminder app is properly set up."
    exit 1
fi

# Check if startup script exists
if [[ ! -f "$startup_script" ]]; then
    echo "Error: Startup script not found at $startup_script"
    echo "Please ensure the submission reminder app is properly set up."
    exit 1
fi

echo "Found application directory: $app_dir"
echo "Current configuration:"
echo "--------------------"
cat "$config_file"
echo "--------------------"
echo

# Prompt for new assignment name
read -p "Enter the new assignment name: " new_assignment

# Validate input
if [[ -z "$new_assignment" ]]; then
    echo "Error: Assignment name cannot be empty!"
    exit 1
fi

# Create backup of config file
backup_file="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
cp "$config_file" "$backup_file"
echo "Backup created: $backup_file"

# Update the ASSIGNMENT value in config.env using sed
if sed -i.tmp "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"; then
    # Remove the temporary file created by sed on macOS
    rm -f "${config_file}.tmp"
    echo "Successfully updated assignment name to: $new_assignment"
    echo
    echo "Updated configuration:"
    echo "--------------------"
    cat "$config_file"
    echo "--------------------"
    echo
    
    # Ask if user wants to run the application
    read -p "Would you like to run the reminder check for the new assignment? (y/n): " run_check
    
    if [[ "$run_check" =~ ^[Yy]([Ee][Ss])?$ ]]; then
        echo
        echo "Running reminder check for assignment: $new_assignment"
        echo "=============================================="
        
        # Change to app directory and run startup script
        cd "$app_dir"
        ./startup.sh
        
        # Return to original directory
        cd - > /dev/null
    else
        echo "You can run the reminder check later by executing:"
        echo "cd $app_dir && ./startup.sh"
    fi
    
else
    echo "Error: Failed to update the assignment name in $config_file"
    echo "Restoring from backup..."
    cp "$backup_file" "$config_file"
    exit 1
fi

echo
echo "Copilot operation completed successfully!"