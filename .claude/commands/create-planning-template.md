# EAV Planning Template Creation Command
**Command**: `/create-planning-template PROJECT_CODE`

## ⚡ Quick Execution
```bash
bash /Users/shaunbuswell/.claude/commands/create-planning-template-v2-fixed PROJECT_CODE
```

## 📋 MANDATORY CHECKLIST

### ✅ PRE-EXECUTION (Must Complete First)
- [ ] Verify project exists: Check PROJECT_CODE in SmartSuite
- [ ] Confirm due date is set: Field `projdue456` must have a date
- [ ] Check environment: `source /Volumes/EAV/.env && echo $ACCOUNT_ID` returns `s3qnmox1`
- [ ] Verify API token: `echo $SMARTSUITE_API_TOKEN | head -c 10` shows token prefix

### ⚙️ EXECUTION STEPS

1. **Run the planning template script:**
```bash
bash /Users/shaunbuswell/.claude/commands/create-planning-template-v2-fixed PROJECT_CODE
```

2. **IMMEDIATELY validate the first record** (critical step):
```bash
source /Volumes/EAV/.env && API_TOKEN=$SMARTSUITE_API_TOKEN
curl -X POST \
  "https://app.smartsuite.com/api/v1/applications/68bace6c51dce2f0d0f5073b/records/list/" \
  -H "Authorization: Token $API_TOKEN" \
  -H "ACCOUNT-ID: $ACCOUNT_ID" \
  -H "Content-Type: application/json" \
  -d "{\"filter\": {\"operator\": \"and\", \"conditions\": [{\"field\": \"title\", \"comparison\": \"starts_with\", \"value\": \"PROJECT_CODE-\"}]}}" \
  --silent | jq '.items[0].due_date'
```

### 🔍 VALIDATION CHECKLIST

**Check the output for:**
- [ ] `from_date.date` is NOT null
- [ ] `to_date.date` is NOT null
- [ ] Dates make logical sense (from < to)

#### ✅ IF VALIDATION PASSES:
All good! Your planning template is ready.

#### ❌ IF VALIDATION FAILS (from_date is null):

**Run the fix script immediately:**
```bash
cat > /tmp/fix-planning-dates-single.sh << 'EOF'
#!/bin/bash
PROJECT_CODE=$1
source /Volumes/EAV/.env && API_TOKEN=$SMARTSUITE_API_TOKEN

# Get project due date
PROJECT_DATA=$(curl -s -X POST "https://app.smartsuite.com/api/v1/applications/68a8ff5237fde0bf797c05b3/records/list/" \
  -H "Authorization: Token $API_TOKEN" \
  -H "ACCOUNT-ID: $ACCOUNT_ID" \
  -H "Content-Type: application/json" \
  -d "{\"filter\": {\"operator\": \"and\", \"conditions\": [{\"field\": \"title\", \"comparison\": \"starts_with\", \"value\": \"$PROJECT_CODE \"}]}}")

PROJECT_DUE=$(echo "$PROJECT_DATA" | jq -r '.items[0].projdue456.to_date.date')
echo "Fixing $PROJECT_CODE with due date: $PROJECT_DUE"

# Phase configurations
declare -A PHASE_DURATIONS=(
  ["Project Start"]=0 ["Preparation"]=1 ["Recce"]=1
  ["Script & Content"]=4 ["VO Generation"]=4 ["Scene Planning"]=4
  ["Filming"]=7 ["Ingest"]=3 ["Editing"]=14
  ["Revisions & Approval"]=3 ["Delivery"]=4
)

declare -A PHASE_BEFORE_DUE=(
  ["Delivery"]=0 ["Revisions & Approval"]=4 ["Editing"]=7
  ["Ingest"]=21 ["Filming"]=24 ["Scene Planning"]=31
  ["VO Generation"]=31 ["Script & Content"]=35
  ["Recce"]=39 ["Preparation"]=39 ["Project Start"]=40
)

# Convert due date
DUE_SECONDS=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$PROJECT_DUE" +%s 2>/dev/null)

# Get and fix each planning record
RECORDS=$(curl -s -X POST "https://app.smartsuite.com/api/v1/applications/68bace6c51dce2f0d0f5073b/records/list/" \
  -H "Authorization: Token $API_TOKEN" \
  -H "ACCOUNT-ID: $ACCOUNT_ID" \
  -H "Content-Type: application/json" \
  -d "{\"filter\": {\"operator\": \"and\", \"conditions\": [{\"field\": \"title\", \"comparison\": \"starts_with\", \"value\": \"$PROJECT_CODE-\"}]}}")

echo "$RECORDS" | jq -c '.items[]' | while read -r record; do
  RECORD_ID=$(echo "$record" | jq -r '.id')
  TITLE=$(echo "$record" | jq -r '.title')
  PHASE=$(echo "$TITLE" | sed -E "s/^$PROJECT_CODE-(.+)\(.+\)$/\1/")
  
  DURATION=${PHASE_DURATIONS["$PHASE"]}
  DAYS_BEFORE=${PHASE_BEFORE_DUE["$PHASE"]}
  
  END_SECONDS=$((DUE_SECONDS - (DAYS_BEFORE * 86400)))
  START_SECONDS=$((END_SECONDS - (DURATION * 86400)))
  [ "$DURATION" -eq 0 ] && START_SECONDS=$END_SECONDS
  
  START_DATE=$(date -r $START_SECONDS +%Y-%m-%dT00:00:00Z)
  END_DATE=$(date -r $END_SECONDS +%Y-%m-%dT00:00:00Z)
  
  echo "  Fixing $PHASE: $START_DATE to $END_DATE"
  
  curl -s -X PATCH "https://app.smartsuite.com/api/v1/applications/68bace6c51dce2f0d0f5073b/records/$RECORD_ID/" \
    -H "Authorization: Token $API_TOKEN" \
    -H "ACCOUNT-ID: $ACCOUNT_ID" \
    -H "Content-Type: application/json" \
    -d "{\"due_date\": {\"from_date\": {\"date\": \"$START_DATE\", \"include_time\": false}, \"to_date\": {\"date\": \"$END_DATE\", \"include_time\": false}}}" > /dev/null
done
echo "✅ Fixed all planning dates for $PROJECT_CODE"
EOF

chmod +x /tmp/fix-planning-dates-single.sh
bash /tmp/fix-planning-dates-single.sh PROJECT_CODE
```

### 📊 FINAL VERIFICATION

After any fixes, verify all records:
```bash
source /Volumes/EAV/.env && API_TOKEN=$SMARTSUITE_API_TOKEN
curl -X POST \
  "https://app.smartsuite.com/api/v1/applications/68bace6c51dce2f0d0f5073b/records/list/" \
  -H "Authorization: Token $API_TOKEN" \
  -H "ACCOUNT-ID: $ACCOUNT_ID" \
  -H "Content-Type: application/json" \
  -d "{\"filter\": {\"operator\": \"and\", \"conditions\": [{\"field\": \"title\", \"comparison\": \"starts_with\", \"value\": \"PROJECT_CODE-\"}]}}" \
  --silent | jq '.items[] | {title: .title, from: .due_date.from_date.date, to: .due_date.to_date.date}'
```

## 🎯 Success Criteria
- All 11 phases created
- All dates have both from_date and to_date
- Dates follow backward planning from project due date
- Dependencies are properly linked

## 🛠️ Common Issues & Solutions

### Issue: "Project not found"
- Verify project code is exact (case sensitive)
- Check project title starts with code (e.g., "EAV015 - Project Name")

### Issue: "No due date"
- Set project due date in SmartSuite first
- Field: `projdue456` (Date Range type)

### Issue: "from_date is null"
- Run the fix script above immediately
- This is a known issue with bash variable scoping

## 📝 Notes
- Total duration: 40 working days
- Backward planning from due date
- Parallel phases: Preparation/Recce, VO Generation/Scene Planning
- Script location: `/Users/shaunbuswell/.claude/commands/create-planning-template-v2-fixed`

## 🔧 Python Implementation (Recommended)

For bulk operations or to avoid bash issues, use the Python scripts:

### Create Multiple Projects
```python
# Located at: /tmp/create-6-planning-templates.py
# Reliable date calculations, proper error handling
```

### Fix All Planning Dates
```python
# Located at: /tmp/fix-all-planning-dates.py
# Systematically fixes all project planning dates
```

### Comprehensive Verification
```python
# Located at: /tmp/comprehensive-planning-verification.py
# Validates all 143 records across 13 projects
# Run this after any bulk operations
```

## 📊 Current State (2025-09-06)
- **13 projects** with complete planning templates
- **143 total records** validated and verified
- Projects: EAV002, EAV007, EAV008, EAV009, EAV011, EAV012, EAV013, EAV015, EAV016, EAV029, EAV030, EAV033, EAV036

## 🎓 Lessons Learned
1. **Bash variable scoping** in loops causes null from_date values
2. **Python preferred** for complex date calculations and bulk operations
3. **Always verify** with comprehensive validation script after creation
4. **Required fields**: `proj_link1`, `phase_sel1`, `due_date`, `title`
5. **Table ID**: `68bace6c51dce2f0d0f5073b` in solution `68a8eedc2271ce265ebdae8f`