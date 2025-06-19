#!/bin/bash

echo "=== Submission Reminder App Environment Setup ==="
echo

# Prompt user for their name
read -p "Please enter your name: " user_name

# Validate input
if [[ -z "$user_name" ]]; then
    echo "Error: Name cannot be empty!"
    exit 1
fi

# Create main directory
main_dir="submission_reminder_${user_name}"
echo "Creating directory: $main_dir"

if [[ -d "$main_dir" ]]; then
    echo "Warning: Directory $main_dir already exists. Removing it first..."
    rm -rf "$main_dir"
fi

mkdir -p "$main_dir"
cd "$main_dir"

# Create subdirectories
echo "Creating subdirectories..."
mkdir -p config
mkdir -p modules
mkdir -p assets

echo "Directory structure created successfully!"
echo

# Create config.env file
echo "Creating config/config.env..."
cat > config/config.env << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create functions.sh file
echo "Creating modules/functions.sh..."
cat > modules/functions.sh << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# Create submissions.txt file with original data plus 5 additional students
echo "Creating assets/submissions.txt..."
cat > assets/submissions.txt << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Michael, Shell Navigation, submitted
Sarah, Shell Navigation, not submitted
David, Git, not submitted
Emily, Shell Basics, submitted
James, Shell Navigation, not submitted
Lisa, Git, submitted
EOF

# Create reminder.sh file
echo "Creating reminder.sh..."
cat > reminder.sh << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# Create startup.sh file
echo "Creating startup.sh..."
cat > startup.sh << 'EOF'
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
EOF

# Make all .sh files executable
echo "Making all .sh files executable..."
find . -name "*.sh" -exec chmod +x {} \;

echo
echo "=== Environment Setup Complete ==="
echo "Directory created: $main_dir"
echo "Files created:"
echo "  - config/config.env"
echo "  - modules/functions.sh"
echo "  - assets/submissions.txt (with 6 additional student records)"
echo "  - reminder.sh"
echo "  - startup.sh"
echo
echo "All .sh files have been made executable."
echo
echo "To test the application:"
echo "1. cd $main_dir"
echo "2. ./startup.sh"
echo
echo "Environment setup completed successfully!"