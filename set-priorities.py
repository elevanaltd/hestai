#!/usr/bin/env python3
"""
Set GitHub Project V2 item priorities via GraphQL API
Reads GITHUB_TOKEN from .env.local
"""

import os
import json
import sys
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.error import URLError

# Load environment variables
env_file = Path(__file__).parent / '.env.local'
if env_file.exists():
    with open(env_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                key, value = line.split('=', 1)
                os.environ[key.strip()] = value.strip()

GITHUB_TOKEN = os.environ.get('GITHUB_TOKEN', '').strip()
if not GITHUB_TOKEN or GITHUB_TOKEN == 'your_github_token_here':
    print("❌ ERROR: GITHUB_TOKEN not set in .env.local")
    print("   Please create a GitHub Personal Access Token:")
    print("   1. Go to https://github.com/settings/tokens")
    print("   2. Click 'Generate new token (classic)'")
    print("   3. Select scopes: 'repo' and 'project'")
    print("   4. Copy the token and add to .env.local")
    sys.exit(1)

# Mapping of issue numbers to priorities
PRIORITY_MAP = {
    24: 'Medium',
    25: 'Medium',
    26: 'Medium',
    27: 'High',
    28: 'Medium',
    29: 'Low',
    30: 'High',
    31: 'High'
}

# Priority option IDs (from earlier query)
PRIORITY_OPTIONS = {
    'High': '7f3ba8d0',
    'Medium': '84f776ed',
    'Low': '73f976ad',
    'Critical': '7ac37ec7'
}

# Item IDs for each issue
ITEM_IDS = {
    24: 'PVTI_lADODBy18c4BKNCtzgiV0IE',
    25: 'PVTI_lADODBy18c4BKNCtzgiV0IU',
    26: 'PVTI_lADODBy18c4BKNCtzgiV0I4',
    27: 'PVTI_lADODBy18c4BKNCtzgiV0Jg',
    28: 'PVTI_lADODBy18c4BKNCtzgiV0J4',
    29: 'PVTI_lADODBy18c4BKNCtzgiV0Kg',
    30: 'PVTI_lADODBy18c4BKNCtzgiV0LI',
    31: 'PVTI_lADODBy18c4BKNCtzgiV0L0'
}

FIELD_ID = 'PVTSSF_lADODBy18c4BKNCtzg6I_FI'
PROJECT_ID = 'PVT_kwDODBy18c4BKNCtzg'

def make_graphql_request(query: str, variables: dict = None) -> dict:
    """Make a GraphQL request to the GitHub API"""
    payload = {
        'query': query,
        'variables': variables or {}
    }

    request = Request(
        'https://api.github.com/graphql',
        data=json.dumps(payload).encode('utf-8'),
        headers={
            'Authorization': f'Bearer {GITHUB_TOKEN}',
            'Content-Type': 'application/json',
            'User-Agent': 'HestAI-Priority-Setter'
        }
    )

    try:
        with urlopen(request) as response:
            result = json.loads(response.read().decode('utf-8'))

            # Check for GraphQL errors
            if 'errors' in result:
                print(f"❌ GraphQL Error: {result['errors']}")
                return None

            return result.get('data')
    except URLError as e:
        print(f"❌ Network Error: {e}")
        return None

def update_project_item_field(item_id: str, option_id: str) -> bool:
    """Update a project item's field value"""
    mutation = """
    mutation UpdateProjectItemField($input: UpdateProjectV2ItemFieldValueInput!) {
      updateProjectV2ItemFieldValue(input: $input) {
        clientMutationId
      }
    }
    """

    variables = {
        'input': {
            'projectId': PROJECT_ID,
            'itemId': item_id,
            'fieldId': FIELD_ID,
            'value': {
                'singleSelectOptionId': option_id
            }
        }
    }

    result = make_graphql_request(mutation, variables)
    return result is not None

def main():
    print("🚀 Setting GitHub Project Priorities\n")
    print(f"Project: elevanaltd/HestAI (ID: {PROJECT_ID})")
    print(f"Field: Priority (ID: {FIELD_ID})\n")

    successes = 0
    failures = 0

    for issue_num in sorted(PRIORITY_MAP.keys()):
        priority = PRIORITY_MAP[issue_num]
        item_id = ITEM_IDS[issue_num]
        option_id = PRIORITY_OPTIONS[priority]

        print(f"[{issue_num}/31] Issue #{issue_num}: Setting priority to '{priority}'...", end=' ', flush=True)

        if update_project_item_field(item_id, option_id):
            print("✅")
            successes += 1
        else:
            print("❌")
            failures += 1

    print(f"\n{'='*50}")
    print(f"Results: {successes} successful, {failures} failed")

    if failures == 0:
        print("✨ All priorities updated successfully!")
        return 0
    else:
        print(f"⚠️  {failures} updates failed")
        return 1

if __name__ == '__main__':
    sys.exit(main())
