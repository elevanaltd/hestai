# Orbital Momentum Implementation Guide

**Status:** Implementation Specification  
**Purpose:** Transform linear phase gates into momentum-driven orbital workflow  
**Scope:** Practical implementation of dynamic agent spawning with orbital architecture  

## Overview

This guide implements the synthesis between ceremony reduction and quality preservation through an "Orbital Momentum Architecture" - transforming the rigid D1→D2→D3→B0→B1→B2→B3→B4 progression into three natural collaboration orbits where quality emerges from project momentum rather than imposed checkpoints.

## The Three Orbits

### Orbit 1: Alignment Orbit (Replaces D1-D3)
**Purpose:** Establish shared understanding and technical approach  
**Momentum:** Ideas crystallizing into actionable design  

```yaml
entry_signals:
  - User expresses need or problem
  - Initial requirements gathered
  - Project initiated

natural_consultations:
  - requirements-steward: Continuously refines understanding
  - technical-architect: Evaluates feasibility in real-time
  - critical-engineer: Provides early architectural guidance

momentum_indicators:
  - Requirements stability > 80%
  - Technical approach validated
  - Key stakeholders aligned
  - Design mockups approved (if applicable)

exit_criteria:
  - North Star document living and updated
  - Architecture blueprint reviewed
  - All "what" and "how" questions answered
  - Natural transition when team says "let's build this"
```

### Orbit 2: Execution Orbit (Replaces B0-B2)
**Purpose:** Transform design into working implementation  
**Momentum:** Code velocity and quality metrics  

```yaml
entry_signals:
  - Design approved organically
  - Development environment ready
  - Team assembled and briefed

natural_consultations:
  - testguard: Integrated into development flow
  - code-review-specialist: Continuous review as natural pairing
  - error-resolver: On-demand for blockers

momentum_indicators:
  - Daily commits > 5
  - Test coverage stable > 80%
  - PR merge rate > 0.8
  - No blocking issues > 2 days

exit_criteria:
  - Core features implemented
  - All tests passing
  - Performance benchmarks met
  - Natural transition when team says "it's working"
```

### Orbit 3: Validation Orbit (Replaces B3-B4)
**Purpose:** Ensure production readiness and smooth handoff  
**Momentum:** System stability and stakeholder confidence  

```yaml
entry_signals:
  - Core implementation complete
  - Integration testing started
  - Stakeholder demos scheduled

natural_consultations:
  - security-specialist: Security review as part of hardening
  - completion-architect: System integration guidance
  - solution-steward: Documentation as knowledge capture

momentum_indicators:
  - Zero critical bugs > 3 days
  - Performance SLAs consistently met
  - Security scan clear
  - Documentation complete

exit_criteria:
  - Production deployment successful
  - Monitoring active
  - Handoff complete
  - Natural transition when team says "ship it"
```

## Momentum Signals Implementation

### WorkItemStatus Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "project_id": {
      "type": "string",
      "format": "uuid"
    },
    "current_orbit": {
      "type": "integer",
      "enum": [1, 2, 3]
    },
    "momentum_score": {
      "type": "number",
      "minimum": 0,
      "maximum": 100
    },
    "metrics": {
      "type": "object",
      "properties": {
        "test_coverage": {"type": "number"},
        "test_pass_rate": {"type": "number"},
        "code_velocity": {"type": "number"},
        "pr_merge_rate": {"type": "number"},
        "open_bugs": {"type": "integer"},
        "security_issues": {"type": "integer"},
        "documentation_coverage": {"type": "number"}
      }
    },
    "human_acks": {
      "type": "object",
      "properties": {
        "critical_engineer": {"type": "string"},
        "requirements_steward": {"type": "string"},
        "testguard": {"type": "string"}
      }
    },
    "blockers": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {"type": "string"},
          "severity": {"type": "string"},
          "description": {"type": "string"},
          "assigned_to": {"type": "string"}
        }
      }
    },
    "timestamp": {
      "type": "string",
      "format": "date-time"
    }
  },
  "required": ["project_id", "current_orbit", "momentum_score", "metrics", "timestamp"]
}
```

### Momentum Calculation

```python
class MomentumCalculator:
    """
    Calculates project momentum based on velocity and quality signals
    """
    
    def calculate(self, status: WorkItemStatus) -> float:
        """
        Returns momentum score 0-100
        Higher score indicates readiness for orbit transition
        """
        
        orbit_weights = {
            1: {  # Alignment Orbit
                'requirements_stability': 0.30,
                'design_approval': 0.25,
                'stakeholder_alignment': 0.25,
                'technical_validation': 0.20
            },
            2: {  # Execution Orbit
                'code_velocity': 0.20,
                'test_coverage': 0.25,
                'test_pass_rate': 0.25,
                'pr_merge_rate': 0.15,
                'blocker_resolution': 0.15
            },
            3: {  # Validation Orbit
                'bug_closure': 0.20,
                'performance_metrics': 0.20,
                'security_clearance': 0.20,
                'documentation_complete': 0.20,
                'stakeholder_approval': 0.20
            }
        }
        
        weights = orbit_weights[status.current_orbit]
        score = 0
        
        for metric, weight in weights.items():
            metric_value = self.get_metric_value(status, metric)
            score += metric_value * weight
            
        # Apply penalties for blockers
        blocker_penalty = min(20, len(status.blockers) * 5)
        score = max(0, score - blocker_penalty)
        
        return score
```

## Complexity-Aware Orbit Execution

### Lightweight Projects (Complexity 0-30)

```yaml
orbit_compression:
  alignment_orbit:
    duration: 1-2 days
    agents:
      - unified-designer (combines clarifier + ideator + architect)
    deliverables:
      - Single unified design document
      
  execution_orbit:
    duration: 2-5 days
    agents:
      - implementation-lead (includes review + test guidance)
    deliverables:
      - Implemented solution with tests
      
  validation_orbit:
    duration: 1 day
    agents:
      - completion-architect (handles integration + handoff)
    deliverables:
      - Deployed solution with basic docs
```

### Standard Projects (Complexity 31-70)

```yaml
orbit_execution:
  alignment_orbit:
    duration: 1 week
    agents:
      primary:
        - idea-clarifier
        - design-architect
      consultative:
        - requirements-steward
        - technical-architect
        
  execution_orbit:
    duration: 2-4 weeks
    agents:
      primary:
        - implementation-lead
        - universal-test-engineer
        - code-review-specialist
      consultative:
        - testguard
        - error-resolver
        
  validation_orbit:
    duration: 1 week
    agents:
      primary:
        - completion-architect
        - security-specialist
      consultative:
        - solution-steward
```

### Comprehensive Projects (Complexity 71-100)

```yaml
parallel_orbits:
  # Multiple work streams in parallel orbits
  
  frontend_stream:
    orbit_1: UI/UX design team
    orbit_2: Frontend development team
    orbit_3: UI testing team
    
  backend_stream:
    orbit_1: API design team
    orbit_2: Backend development team
    orbit_3: Integration testing team
    
  infrastructure_stream:
    orbit_1: Architecture team
    orbit_2: DevOps team
    orbit_3: Security team
    
  coordination:
    sync_points: Daily standups
    integration_checkpoints: Weekly
    momentum_aggregation: Weighted average
```

## Practical Implementation Steps

### Step 1: Set Up Event Bus

```bash
# Using NATS for lightweight event streaming
docker run -d --name nats \
  -p 4222:4222 \
  -p 8222:8222 \
  nats:latest -js
```

```python
# momentum_publisher.py
import asyncio
from nats.aio.client import Client as NATS

class MomentumPublisher:
    def __init__(self):
        self.nc = NATS()
        
    async def connect(self):
        await self.nc.connect("nats://localhost:4222")
        
    async def publish_status(self, status: WorkItemStatus):
        await self.nc.publish(
            f"momentum.{status.project_id}",
            status.json().encode()
        )
```

### Step 2: Create Momentum Monitor

```python
# momentum_monitor.py
class MomentumMonitor:
    """
    Monitors project momentum and triggers orbit transitions
    """
    
    def __init__(self, orchestrator):
        self.orchestrator = orchestrator
        self.calculator = MomentumCalculator()
        self.threshold = 75  # Momentum score for orbit transition
        
    async def check_transition(self, status: WorkItemStatus):
        momentum = self.calculator.calculate(status)
        
        if momentum > self.threshold:
            await self.trigger_transition(status)
        elif momentum < 50:
            await self.identify_blockers(status)
            
    async def trigger_transition(self, status: WorkItemStatus):
        next_orbit = status.current_orbit + 1
        
        if next_orbit <= 3:
            await self.orchestrator.transition_orbit(
                status.project_id,
                next_orbit
            )
```

### Step 3: Implement Agent Spawning

```python
# agent_spawner.py
class OrbitalAgentSpawner:
    """
    Spawns agents based on orbit and complexity
    """
    
    def __init__(self, pool_manager):
        self.pool_manager = pool_manager
        self.orbit_configs = self.load_orbit_configs()
        
    async def spawn_for_orbit(
        self, 
        project_id: str, 
        orbit: int, 
        complexity_tier: str
    ):
        config = self.orbit_configs[complexity_tier][orbit]
        
        # Spawn primary agents
        primary_agents = []
        for role in config['primary']:
            agent = await self.pool_manager.acquire(role)
            agent.assign_project(project_id)
            primary_agents.append(agent)
            
        # Set up consultative agents (on-demand)
        consultative = {}
        for role in config['consultative']:
            consultative[role] = self.pool_manager.reserve(role)
            
        return {
            'primary': primary_agents,
            'consultative': consultative
        }
```

### Step 4: Create Orbital Dashboard

```html
<!-- orbital_dashboard.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Orbital Momentum Dashboard</title>
    <style>
        .orbit {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            position: relative;
            margin: 20px;
            display: inline-block;
        }
        .orbit-1 { border: 3px solid #4CAF50; }
        .orbit-2 { border: 3px solid #2196F3; }
        .orbit-3 { border: 3px solid #FF9800; }
        
        .project-dot {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #333;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }
        
        .momentum-bar {
            width: 100%;
            height: 20px;
            background: #ddd;
            border-radius: 10px;
            overflow: hidden;
        }
        
        .momentum-fill {
            height: 100%;
            background: linear-gradient(90deg, #4CAF50, #8BC34A);
            transition: width 0.3s ease;
        }
    </style>
</head>
<body>
    <h1>Orbital Momentum Dashboard</h1>
    
    <div id="orbits">
        <div class="orbit orbit-1" id="orbit-1">
            <h3>Alignment</h3>
            <div class="project-dots"></div>
        </div>
        
        <div class="orbit orbit-2" id="orbit-2">
            <h3>Execution</h3>
            <div class="project-dots"></div>
        </div>
        
        <div class="orbit orbit-3" id="orbit-3">
            <h3>Validation</h3>
            <div class="project-dots"></div>
        </div>
    </div>
    
    <div id="momentum-display">
        <h3>Project Momentum</h3>
        <div class="momentum-bar">
            <div class="momentum-fill" id="momentum-fill"></div>
        </div>
        <span id="momentum-score">0</span>%
    </div>
    
    <script>
        // WebSocket connection for real-time updates
        const ws = new WebSocket('ws://localhost:8080/momentum');
        
        ws.onmessage = (event) => {
            const status = JSON.parse(event.data);
            updateDashboard(status);
        };
        
        function updateDashboard(status) {
            // Update momentum bar
            const fill = document.getElementById('momentum-fill');
            fill.style.width = status.momentum_score + '%';
            
            document.getElementById('momentum-score').textContent = 
                Math.round(status.momentum_score);
            
            // Update project position in orbit
            updateProjectPosition(status.project_id, status.current_orbit);
        }
        
        function updateProjectPosition(projectId, orbit) {
            // Move project dot to current orbit
            let dot = document.getElementById('project-' + projectId);
            if (!dot) {
                dot = document.createElement('div');
                dot.className = 'project-dot';
                dot.id = 'project-' + projectId;
            }
            
            const orbitElement = document.getElementById('orbit-' + orbit);
            orbitElement.querySelector('.project-dots').appendChild(dot);
            
            // Animate position based on momentum
            animateOrbitalPosition(dot, status.momentum_score);
        }
        
        function animateOrbitalPosition(element, momentum) {
            const angle = (momentum / 100) * 360;
            const radius = 80;
            const x = radius * Math.cos(angle * Math.PI / 180);
            const y = radius * Math.sin(angle * Math.PI / 180);
            
            element.style.transform = `translate(${x}px, ${y}px)`;
        }
    </script>
</body>
</html>
```

### Step 5: CLI Tool for Momentum Management

```python
#!/usr/bin/env python3
# orbital_cli.py

import click
import asyncio
from momentum_client import MomentumClient

@click.group()
def cli():
    """Orbital Momentum CLI - Manage project progression naturally"""
    pass

@cli.command()
@click.option('--project-id', required=True)
def status(project_id):
    """Check current orbit and momentum"""
    client = MomentumClient()
    status = asyncio.run(client.get_status(project_id))
    
    click.echo(f"Project: {project_id}")
    click.echo(f"Current Orbit: {status.current_orbit} ({get_orbit_name(status.current_orbit)})")
    click.echo(f"Momentum Score: {status.momentum_score:.1f}%")
    
    if status.blockers:
        click.echo("\nBlockers:")
        for blocker in status.blockers:
            click.echo(f"  - [{blocker.severity}] {blocker.description}")
    
    if status.momentum_score > 75:
        click.echo("\n✅ Ready for orbit transition!")
    elif status.momentum_score < 50:
        click.echo("\n⚠️ Momentum low - check blockers")

@cli.command()
@click.option('--project-id', required=True)
@click.option('--metric', required=True)
@click.option('--value', required=True, type=float)
def update(project_id, metric, value):
    """Update a momentum metric"""
    client = MomentumClient()
    asyncio.run(client.update_metric(project_id, metric, value))
    click.echo(f"Updated {metric} to {value}")

@cli.command()
@click.option('--project-id', required=True)
def transition(project_id):
    """Force orbit transition (requires approval)"""
    client = MomentumClient()
    
    if click.confirm("Force orbit transition? This requires justification."):
        reason = click.prompt("Justification")
        asyncio.run(client.force_transition(project_id, reason))
        click.echo("Transition initiated")

@cli.command()
@click.option('--tier', type=click.Choice(['lightweight', 'standard', 'comprehensive']))
def simulate(tier):
    """Simulate orbital progression for different tiers"""
    simulator = OrbitalSimulator()
    asyncio.run(simulator.run(tier))

def get_orbit_name(orbit):
    return {1: "Alignment", 2: "Execution", 3: "Validation"}.get(orbit, "Unknown")

if __name__ == '__main__':
    cli()
```

## Migration Strategy

### Phase 1: Shadow Mode (Weeks 1-4)
Run orbital system in parallel with existing gates:

```yaml
shadow_mode:
  existing_workflow: Continue D1-B4 phases
  orbital_tracking: Monitor momentum in background
  data_collection: Compare ceremony time vs momentum time
  risk: None - existing process unchanged
```

### Phase 2: Pilot Projects (Weeks 5-8)
Select volunteer projects for orbital workflow:

```yaml
pilot_selection:
  lightweight_pilot:
    - Single developer tool
    - Low risk
    - 1 week timeline
    
  standard_pilot:
    - Small team web app
    - Moderate complexity
    - 4 week timeline
    
  measurements:
    - Time to production
    - Developer satisfaction
    - Quality metrics
    - Ceremony hours
```

### Phase 3: Gradual Rollout (Weeks 9-16)

```yaml
rollout_strategy:
  week_9_10:
    - All lightweight projects use orbital
    - Standard/comprehensive continue gates
    
  week_11_12:
    - Opt-in for standard projects
    - Training sessions for teams
    
  week_13_14:
    - Default orbital for new projects
    - Gates available as override
    
  week_15_16:
    - Full migration
    - Gates deprecated (available for compliance)
```

## Success Metrics

### Ceremony Reduction
```python
ceremony_metrics = {
    'gate_prep_hours': -70%,        # Time preparing gate documents
    'waiting_time': -80%,           # Waiting for gate approval
    'meeting_hours': -60%,          # Gate review meetings
    'process_overhead': -65%        # Overall process burden
}
```

### Quality Preservation
```python
quality_metrics = {
    'test_coverage': '>= 80%',      # Maintained
    'bug_escape_rate': '<= current', # Same or better
    'security_issues': 0,            # Zero tolerance maintained
    'architecture_violations': '<= 1' # Same or better
}
```

### Developer Experience
```python
experience_metrics = {
    'process_satisfaction': '>= 8/10',
    'autonomy_score': '+40%',
    'flow_state_time': '+50%',
    'context_switches': '-60%'
}
```

## Cultural Transformation

### Language Shift

| Old Language | New Language |
|--------------|--------------|
| "Submit to B0 gate" | "Ready to build" |
| "Gate approval" | "Momentum achieved" |
| "Phase completion" | "Orbit transition" |
| "Blocked at gate" | "Building momentum" |
| "Process compliance" | "Natural progression" |
| "Mandatory consultation" | "Collaborative guidance" |

### Team Behaviors

```yaml
old_behaviors:
  - Wait for phase completion
  - Prepare gate documents
  - Schedule gate reviews
  - Request approvals
  
new_behaviors:
  - Continuous momentum building
  - Living documentation
  - Real-time collaboration
  - Natural transitions
```

## Troubleshooting Guide

### Common Issues

**Low Momentum in Alignment Orbit**
```yaml
symptoms:
  - Requirements keep changing
  - Stakeholders not aligned
  - Technical approach unclear

solutions:
  - Increase stakeholder sync frequency
  - Use visual prototypes earlier
  - Bring in technical-architect sooner
```

**Stuck in Execution Orbit**
```yaml
symptoms:
  - Test coverage dropping
  - Bug count increasing
  - PR merge rate low

solutions:
  - Pair programming sessions
  - Focused bug bash
  - Temporary tier escalation
```

**Validation Orbit Delays**
```yaml
symptoms:
  - Security issues found late
  - Performance problems
  - Documentation incomplete

solutions:
  - Shift-left security scanning
  - Continuous performance testing
  - Documentation-as-code approach
```

## Appendix: Momentum Formulas

### Alignment Orbit Momentum
```
M₁ = 0.30 × RequirementStability + 
     0.25 × DesignApproval + 
     0.25 × StakeholderAlignment + 
     0.20 × TechnicalValidation - 
     5 × BlockerCount
```

### Execution Orbit Momentum
```
M₂ = 0.20 × CodeVelocity + 
     0.25 × TestCoverage + 
     0.25 × TestPassRate + 
     0.15 × PRMergeRate + 
     0.15 × BlockerResolutionRate - 
     5 × CriticalBugCount
```

### Validation Orbit Momentum
```
M₃ = 0.20 × BugClosureRate + 
     0.20 × PerformanceScore + 
     0.20 × SecurityClearance + 
     0.20 × DocumentationCompleteness + 
     0.20 × StakeholderApproval - 
     10 × ProductionBlockers
```

---

**Implementation Authority:** Technical Architecture Team  
**Pilot Coordinator:** Implementation Lead  
**Review Cycle:** Weekly during pilot, monthly after rollout