# Project Setup Command

Setup a new EAV project after duplication in SmartSuite.

## Usage
```
/project-setup EAV030
```

## What This Does
1. Looks up the project ID from the EAV code
2. Checks if tasks already exist (prevents duplicates)
3. Calculates Task Window dates from Project Due Date
4. Links all task dependencies (3-way convergence)
5. Sets initial workblock dates (weekday-aware)
6. Validates the complete setup

## Implementation

When invoked with an EAV code:

### Step 1: Find Project ID
```bash
echo "🔍 Looking up project ${ARGUMENTS}..."
PROJECT_ID=$(node /Volumes/EAV/new-system/project-setup/lookup-project.js ${ARGUMENTS} 2>/dev/null)

if [ $? -ne 0 ]; then
  echo "❌ Project ${ARGUMENTS} not found in SmartSuite"
  echo "   Please verify:"
  echo "   1. The project was duplicated in SmartSuite"
  echo "   2. The EAV code field was updated"
  exit 1
fi

echo "✅ Found project: $PROJECT_ID"
```

### Step 2: Check for Existing Tasks
```bash
echo -e "\n🔍 Checking for existing tasks..."
node /Volumes/EAV/new-system/project-setup/check-project-tasks.js $PROJECT_ID

if [ $? -eq 0 ]; then
  echo "✅ Tasks already exist - skipping creation"
else
  echo "⚠️  Task issues detected - may need manual cleanup in SmartSuite"
fi
```

### Step 3: Calculate Task Windows
```bash
echo -e "\n📅 Calculating task window dates..."
node /Volumes/EAV/new-system/project-setup/update-task-windows.js $PROJECT_ID

if [ $? -ne 0 ]; then
  echo "⚠️  Task window calculation failed - continuing..."
fi
```

### Step 4: Link Dependencies
```bash
echo -e "\n📎 Linking task dependencies..."
node /Volumes/EAV/new-system/project-setup/link-project-dependencies.js $PROJECT_ID

if [ $? -ne 0 ]; then
  echo "⚠️  Dependency linking had issues - continuing..."
fi
```

### Step 5: Set Workblock Dates
```bash
echo -e "\n📅 Setting initial workblock dates..."
node /Volumes/EAV/new-system/project-setup/set-initial-workblocks.js $PROJECT_ID

if [ $? -ne 0 ]; then
  echo "⚠️  Workblock setting had issues - continuing..."
fi
```

### Step 6: Validate Setup
```bash
echo -e "\n🔍 Validating project setup..."
node /Volumes/EAV/new-system/project-setup/validate-project-setup.js $PROJECT_ID

echo -e "\n✨ Project setup complete for ${ARGUMENTS}!"
```

## Required Scripts
All scripts are located in `/Volumes/EAV/new-system/project-setup/`:
- `lookup-project.js` - Find project ID by EAV code
- `check-project-tasks.js` - Check if tasks exist (prevent duplicates)
- `update-task-windows.js` - Calculate task window dates from project due date
- `link-project-dependencies.js` - Link task dependencies
- `set-initial-workblocks.js` - Set workblock dates
- `validate-project-setup.js` - Validate complete setup

## Troubleshooting

### "Project not found"
- Verify the project exists in SmartSuite
- Check the EAV code field is set correctly
- Ensure you have the right workspace

### "No tasks found"
- Confirm all 17 tasks were duplicated
- Check the project ID is correct

### "Dependencies not linking"
- May be rate limit issues
- Try running the dependency script again

### "Workblock dates not setting"
- Check that Task Window dates exist
- Verify date format compatibility