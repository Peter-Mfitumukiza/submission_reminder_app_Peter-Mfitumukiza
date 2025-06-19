# Submission Reminder App

A simple shell application that tracks student assignment submissions and reminds students who haven't submitted their work.

## How to Run the Application

### Step 1: Set Up the Application Environment

Run the setup script to create your submission reminder app:

```bash
./create_environment.sh
```

This will:
- Ask for your name
- Create a directory called `submission_reminder_[YourName]`
- Set up all the necessary files and folders
- Make all scripts executable

### Step 2: Run the Reminder System

Navigate to your app directory and start it:

```bash
cd submission_reminder_[YourName]
./startup.sh
```

This will show you which students haven't submitted the current assignment.
### Step 3: Change Assignment Names (Optional)

To check submissions for a different assignment, use the copilot script:

```bash
./copilot_shell_script.sh
```

This will:
- Show the current assignment
- Let you enter a new assignment name
- Update the configuration
- Run the reminder check for the new assignment
## What the App Does

The application checks a list of students and their submission status, then displays reminders for students who haven't submitted the current assignment.

**Example output:**

```
Assignment: Shell Navigation
Days remaining to submit: 2 days
--------------------------------------------
Reminder: John has not submitted the Shell Navigation assignment!
Reminder: Sarah has not submitted the Shell Navigation assignment!
```
## Files Created

When you run the setup, it creates:
- `config/config.env` - Assignment settings
- `modules/functions.sh` - Logic for checking submissions
- `assets/submissions.txt` - Student data
- `reminder.sh` - Main reminder script
- `startup.sh` - Application launcher

That's it! If you want to contribute or add your own amazing feature feel free to fork the repo ✌️
