# SmartSuite Integration Guide

## OVERVIEW

**Purpose**: Comprehensive SmartSuite integration patterns for HestAI ecosystem  
**Workspace**: `s3qnmox1` (41 applications, 10K+ records)  
**Smart Context**: Automatic injection when SmartSuite keywords detected  
**Last Updated**: 2025-08-24

## AUTHENTICATION & BASE CONFIG

**Base URL**: `https://app.smartsuite.com/api/v1`  
**Token**: `c9aa49f9b94dfc8b6bc88299f4dffad7f179618c`  
**Workspace ID**: `s3qnmox1`

**Standard Headers:**
```json
{
  "Authorization": "Token c9aa49f9b94dfc8b6bc88299f4dffad7f179618c",
  "ACCOUNT-ID": "s3qnmox1", 
  "Content-Type": "application/json"
}
```

## PRODUCTION SOLUTIONS

### EAV Management
**Solution ID**: `68a8ee89fe7e46bf89b0611e`  
**URL**: https://app.smartsuite.com/s3qnmox1/solution/68a8ee89fe7e46bf89b0611e/  
**Purpose**: Projects, Clients, Videos, Financials, Additional Costs, Expenses

**Key Tables:**
- **Projects**: `68a8ff5237fde0bf797c05b3` (4-stream readiness tracking)
- **Videos**: `68a8ff7a73b82c2f467b8191` (Main/VO/Media status pipeline)  
- **Clients**: Implementation pending (use available table: `68a8ee89fe7e46bf89b06120`)

### EAV Production  
**Solution ID**: `68a8eedc2271ce265ebdae8f`  
**URL**: https://app.smartsuite.com/s3qnmox1/solution/68a8eedc2271ce265ebdae8f/  
**Purpose**: Tasks, Schedule, Content Items

**Key Tables:**
- **Tasks**: `68a8ffac490e5496953e5b1c` (BOOKING/ASSET/MAIN/VO streams)
- **Schedule**: Implementation pending
- **Content Items**: Implementation pending

## TEST ENVIRONMENT

### TEST EAV MGMT
**Solution ID**: `68ab34b3f022de2157b34d7f`  
**Purpose**: Safe testing mirror of production structure

**Tables:**
- **Clients**: `68ab34b3f022de2157b34d80`
- **Projects**: `68ab34b3f022de2157b34d83`
- **Project Financials**: `68ab34b3f022de2157b34d89`
- **Videos**: `68ab34b3f022de2157b34d8a`
- **Additional Costs**: `68ab34b3f022de2157b34d8c`
- **Expenses**: `68ab34b3f022de2157b34d8d`

### TEST EAV PROD
**Solution ID**: `68ab34b30b1e05e11a8ba87e`  
**Purpose**: Safe testing for production workflows

**Tables:**
- **Tasks**: `68ab34b30b1e05e11a8ba87f`
- **Schedule**: `68ab34b30b1e05e11a8ba880`
- **Content Items**: `68ab34b30b1e05e11a8ba881`

## WORKFLOW STREAMS

### Four-Stream Architecture
1. **BOOKING**: Project readiness tracking → Task workflow stages
2. **ASSET**: Collection status → Workflow stage management  
3. **MAIN**: 20-stage content pipeline → Project health monitoring
4. **VO**: 3-stage voice generation → Readiness rollups

### Status Management
- **Projects Table**: 4-stream readiness checkboxes
- **Videos Table**: Main/VO/Media status pipeline
- **Tasks Table**: Workflow stream assignments with cross-dependencies

## KEY API ENDPOINTS

### Table Management
```bash
# List all applications/tables
GET /applications/

# Create new table
POST /applications/
{
  "name": "Table Name",
  "solution_id": "solution_uuid",
  "description": "Table description"
}

# Get table details
GET /applications/{app_id}

# Update table properties  
PUT /applications/{app_id}
```

### Field Management

#### Bulk Add Fields (RECOMMENDED)
```bash
# Add multiple fields to table
POST /applications/{app_id}/bulk-add-fields/
{
  "fields": [
    {
      "slug": "field_slug",
      "label": "Field Label",
      "field_type": "fieldtype",
      "params": {...},
      "is_new": true
    }
  ],
  "set_as_visible_fields_in_reports": []
}
```

#### Individual Field Operations
```bash
# List table fields
GET /applications/{app_id}/fields/

# Update field
PUT /applications/{app_id}/fields/{field_id}

# Delete field
DELETE /applications/{app_id}/fields/{field_id}
```

### Record Operations
```bash
# List records
GET /applications/{app_id}/records/

# Create record
POST /applications/{app_id}/records/
{
  "field_slug": "value",
  "another_field": "value"
}

# Update record
PUT /applications/{app_id}/records/{record_id}

# Delete record
DELETE /applications/{app_id}/records/{record_id}
```

## FIELD TYPE CONFIGURATIONS

### Text Field
```json
{
  "name": "Project Name",
  "type": "textfield",
  "configuration": {
    "unique": true,
    "required": true,
    "max_length": 255
  }
}
```

### Autonumber Field
```json
{
  "name": "EAV Code", 
  "type": "autonumberfield",
  "configuration": {
    "prefix": "EAV",
    "leading_zeros": 3,
    "start_number": 1
  }
}
```

### Single Select Field
```json
{
  "name": "Project Status",
  "type": "singleselectfield",
  "configuration": {
    "options": [
      {"value": "pre_agreement", "label": "Pre-Agreement", "color": "#ff6b6b"},
      {"value": "pend_start", "label": "Pend Start", "color": "#feca57"},
      {"value": "in_production", "label": "In Production", "color": "#48dbfb"},  
      {"value": "completed", "label": "Completed", "color": "#1dd1a1"}
    ],
    "required": true
  }
}
```

### Currency Field
```json
{
  "name": "Budget",
  "type": "currencyfield", 
  "configuration": {
    "currency": "GBP",
    "decimal_places": 2
  }
}
```

### Date Field
```json
{
  "name": "Agreement Date",
  "type": "datefield",
  "configuration": {
    "include_time": false
  }
}
```

### Linked Record Field
```json
{
  "name": "Client",
  "type": "linkedrecordfield",
  "configuration": {
    "linked_app_id": "client_table_app_id",
    "multiple": false,
    "required": true,
    "allow_linking": true,
    "backlink_enabled": true
  }
}
```

### Formula Field
```json
{
  "name": "Project Title",
  "type": "formula",
  "configuration": {
    "formula": "[EAV Code] & \" - \" & [Project Name] & \" (\" & [Client] & \")\""
  }
}
```

### Rollup Field
```json
{
  "name": "Total Additional Costs",
  "type": "rollup",
  "configuration": {
    "linked_field_id": "additional_costs_linked_field_id",
    "rollup_field_id": "amount_field_id", 
    "function": "sum"
  }
}
```

## RECORD DATA FORMATS

### Status Field Data
```json
{
  "status_field_code": {"value": "in_progress"}
}
```

### Rich Text Data
```json
{
  "rich_text_field_code": {
    "html": "<p>Content with <strong>formatting</strong></p>",
    "data": {}
  }
}
```

### Date Data
```json
{
  "date_field_code": "2025-08-22T09:00:00Z"
}
```

### User Assignment Data
```json
{
  "user_field_code": ["659beecfbbef5efee3a27544"]
}
```

### Linked Record Data
```json
{
  "linked_field_code": ["target_record_id"]
}
```

## CRITICAL API PATTERNS

### Rate Limiting
- **Delay**: 250ms between requests
- **Retry**: 30 second backoff on errors  
- **Trailing Slash**: DELETE operations require trailing slash

### Field Code Requirements
- **Must use field codes** (cryptic IDs), not field labels
- **Example**: `s6613c3d5e9f16000843fab7b` not "Project Name"
- Get field codes via: `GET /applications/{app_id}/fields/`

### Error Handling
```javascript
async function apiCall(url, options, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await fetch(url, options);
      if (response.ok) return await response.json();
      
      if (response.status === 429) {
        await new Promise(resolve => setTimeout(resolve, 30000));
        continue;
      }
      
      throw new Error(`API Error: ${response.status}`);
    } catch (error) {
      if (i === retries - 1) throw error;
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
    }
  }
}
```

## LEGACY SYSTEM REFERENCE

### Legacy Table IDs (for migration reference)
- **Companies**: `65ef1966777e4d8380a075f7`
- **Projects**: `6613bedd1889d8deeaef8b0e` (Primary legacy table)
- **Videos**: `65f1d73feb088d1b061e2f07`

### Migration Patterns
- **AV029 Methodology**: Proven data extraction and field mapping
- **Client Naming Duality**: Preserve operational/legal naming requirements
- **Field Code Preservation**: Always use field codes not labels
- **Relationship Integrity**: Maintain linked record connections

## TESTING PRACTICES

### Safe Testing Convention
**Always use TEST- prefixes in TEST environment:**
- ✅ "TEST-Acme Corporation" (client names)
- ✅ "TEST-Project Alpha" (project names) 
- ✅ "TEST-Kitchen Video" (video names)
- ❌ "Acme Corporation" (production confusion risk)

### API Testing Example
```bash
# Create TEST client record
curl -X POST "https://app.smartsuite.com/api/v1/applications/68ab34b3f022de2157b34d80/records/" \
  -H "Authorization: Token c9aa49f9b94dfc8b6bc88299f4dffad7f179618c" \
  -H "ACCOUNT-ID: s3qnmox1" \
  -H "Content-Type: application/json" \
  -d '{"title": "TEST-Sample Client"}'
```

## MCP INTEGRATION

### SmartSuite MCP Server Functions
- `mcp__smartsuite__list_records`: Query records from any table
- `mcp__smartsuite__create_record`: Create new records
- `mcp__smartsuite__update_record`: Modify existing records
- `mcp__smartsuite__set_status`: Update status fields
- `mcp__smartsuite__get_table_structure`: Inspect table configuration

### Usage Patterns
```javascript
// List projects with status filter
await mcp__smartsuite__list_records({
  app_id: "68a8ff5237fde0bf797c05b3",
  filters: {"status": "in_production"},
  limit: 50
});

// Create new project record
await mcp__smartsuite__create_record({
  app_id: "68a8ff5237fde0bf797c05b3", 
  data: {
    "title": "New Project",
    "status": {"value": "pre_agreement"}
  }
});
```

## IMPLEMENTATION NOTES

### Field Dependencies
1. Create fields in dependency order (linked records before lookups)
2. Enable backlinks for all fields supporting rollups  
3. Use field codes from API, never display labels
4. 250ms minimum between requests

### Known Limitations
- **Autonumber Fields**: Cannot create new via API (rename existing)
- **Primary Fields**: Only one per table (remove before setting new)
- **Bulk Operations**: Use `/bulk-add-fields/` not individual endpoints

### Title Field Standards
- **Auto-generation**: Use formula fields for consistent naming
- **Client Duality**: Preserve operational vs legal naming
- **EAV Code Integration**: Include EAV codes in project titles
- **Template Verification**: Test auto-generation before deployment

## SMART CONTEXT TRIGGERS

This guide automatically injects into HestAI conversations when these patterns detected:

**Keywords**: smartsuite, table, record, field, API, workspace  
**Table IDs**: `6613[a-f0-9]{20}` pattern, `s3qnmox1` workspace  
**Combinations**: ["smartsuite", "table"], ["create", "record"], ["field", "mapping"]

**Purpose**: Provide immediate SmartSuite context without manual lookup

---

**Last Verified**: 2025-08-24  
**Source Authority**: Consolidated from EAV implementation guides and API testing  
**Smart Context**: Configured in `/Volumes/HestAI-Tools/hestai-mcp-server/conf/smart_context_config.json`

<!-- SUBAGENT_AUTHORITY: hestai-doc-steward 2025-08-24T14:15:30-04:00 -->