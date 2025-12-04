# Batch Allocate Videos to Tasks

Efficiently batch allocate videos to tasks based on project and filtering criteria.

## IMPORTANT: Use MCP Tools Only
This command uses the SmartSuite MCP tools (`mcp__smartsuite-shim__*`), NOT raw API calls.
The MCP tools handle authentication, field mapping, and error handling automatically.

## Command Syntax
```
/batch [PROJECT_CODE] [FILTER] to [TASK_URL]
```

## Examples

### Basic Allocation
```
/batch EAV007 all
# Allocates ALL videos from project EAV007 to the current/specified task

/batch EAV007 new
# Allocates only NEW production videos (prodtype01 = "new_prod")

/batch EAV007 amend
# Allocates only AMEND videos (prodtype01 = "amend_minor" or "amend_major")

/batch EAV007 reuse
# Allocates only REUSE videos (prodtype01 = "reuse_prod")
```

### Status-Based Allocation
```
/batch EAV007 status:pend_script
# Videos with main_status = "pend_script"

/batch EAV007 status:in_edit
# Videos with main_status = "in_edit"

/batch EAV007 status:video_in_review
# Videos with main_status = "video_in_review"
```

### Combined Filters
```
/batch EAV007 new status:pend_script
# NEW videos that are in PEND_SCRIPT status

/batch EAV007 amend status:in_edit
# AMEND videos currently IN_EDIT

/batch EAV007 not:allocated
# Only videos NOT already allocated to other tasks
```

### Specific Task Allocation
```
/batch EAV007 all to https://app.smartsuite.com/.../editRecord=TASK_ID
# Allocates to specific task URL

/batch EAV007 new to V5-Scenes
# Allocates to task by partial name match
```

## Implementation Steps (Using MCP Tools)

When this command is invoked, Claude will use these MCP tools:

1. **Parse Command**
   - Extract project code (e.g., EAV007)
   - Identify filters (new/amend/reuse/status/etc.)
   - Extract target task (URL or current context)

2. **Get Project ID** using `mcp__smartsuite-shim__smartsuite_query`
   ```python
   mcp__smartsuite-shim__smartsuite_query(
     operation="list",
     appId="68a8ff5237fde0bf797c05b3",  # Projects table
     filters={"operator": "and", "fields": [
       {"field": "autonumber", "comparison": "is", "value": "7"}
     ]},
     limit=1
   )
   ```

3. **Query Videos** using `mcp__smartsuite-shim__smartsuite_query`
   ```python
   mcp__smartsuite-shim__smartsuite_query(
     operation="list",
     appId="68b2437a8f1755b055e0a124",  # Videos table
     filters={"operator": "and", "fields": [
       {"field": "projects_link", "comparison": "has_any_of", "value": [project_id]},
       # Add production type filter if specified
       {"field": "prodtype01", "comparison": "is", "value": "new_prod"},
       # Add status filter if specified  
       {"field": "main_status", "comparison": "is", "value": "in_edit"}
     ]},
     limit=50  # Reasonable batch size
   )
   ```

4. **Check Allocation Status** (if not:allocated specified)
   ```python
   # Query tasks to find already allocated videos
   mcp__smartsuite-shim__smartsuite_query(
     operation="list",
     appId="68a8ffac490e5496953e5b1c",  # Tasks table
     filters={"operator": "and", "fields": [
       {"field": "batch_alloc", "comparison": "is_not_empty", "value": true}
     ]}
   )
   ```

5. **Execute Allocation** using `mcp__smartsuite-shim__smartsuite_record`
   ```python
   # ALWAYS dry run first
   mcp__smartsuite-shim__smartsuite_record(
     operation="update",
     appId="68a8ffac490e5496953e5b1c",  # Tasks table
     recordId=task_id,
     data={"batch_alloc": video_ids},
     dry_run=True  # MANDATORY first step
   )
   
   # Then execute if dry run passes
   mcp__smartsuite-shim__smartsuite_record(
     operation="update",
     appId="68a8ffac490e5496953e5b1c",
     recordId=task_id,
     data={"batch_alloc": video_ids},
     dry_run=False
   )
   ```

## Filter Reference

### Production Type Values
- `new` → `prodtype01 = "new_prod"`
- `amend_minor` → `prodtype01 = "amend_minor"`
- `amend_major` → `prodtype01 = "amend_major"`
- `amend` → `prodtype01 IN ["amend_minor", "amend_major"]`
- `reuse` → `prodtype01 = "reuse_prod"`

### Main Status Values
- `pend_start` - Awaiting start
- `pend_spec` - Pending specification
- `pend_script` - Pending script creation
- `script_in_review` - Script under review
- `pend_scenes` - Pending scene planning
- `pend_filming` - Pending filming
- `in_edit` - Currently editing
- `video_in_review` - Video under review
- `delivered` - Completed delivery

### VO Status Values
- `pend_script_approval` - Awaiting script approval
- `pend_vo` - Pending voice generation
- `vo_ready` - Voice-over ready
- `vo_delivered` - Voice-over delivered

## Quick Actions

### Allocate All Available
```
/batch EAV007 all not:allocated
```

### Allocate by Video Sequence
```
/batch EAV007 seq:1-5
# Videos 1 through 5

/batch EAV007 seq:1,3,5,7
# Specific video numbers
```

### Clear Allocation
```
/batch EAV007 clear
# Removes all video allocations from current task
```

## Error Handling

The command will:
1. Validate project exists
2. Confirm videos found before allocation
3. Show preview of videos to be allocated
4. Request confirmation for large batches (>20 videos)
5. Report success/failure clearly

## SmartSuite Table References

- **Projects Table**: `68a8ff5237fde0bf797c05b3`
- **Videos Table**: `68b2437a8f1755b055e0a124`
- **Tasks Table**: `68a8ffac490e5496953e5b1c`

## Critical MCP Tool Patterns

**ALWAYS use MCP tools, never raw API calls:**
- `mcp__smartsuite-shim__smartsuite_query` for reading/searching
- `mcp__smartsuite-shim__smartsuite_record` for creating/updating
- `mcp__smartsuite-shim__smartsuite_schema` for understanding structure

**Key filtering pattern for linked records:**
```python
{"field": "projects_link", "comparison": "has_any_of", "value": [project_id]}
```

**Never use:**
- `"comparison": "is"` for array fields
- `"comparison": "contains"` for linked records
- Raw API calls bypassing MCP tools

**Always:**
- Use `dry_run=True` before any update
- Limit queries to reasonable sizes (50-100 records)
- Use MCP tools for ALL SmartSuite operations