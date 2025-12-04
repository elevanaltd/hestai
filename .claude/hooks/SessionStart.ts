#!/usr/bin/env npx tsx

/**
 * SessionStart Hook - North Star Summary Auto-Loading
 *
 * Runs at conversation startup to:
 * 1. Detect project context (.coord symlink)
 * 2. Load North Star Summary if available
 * 3. Provide lazy-load triggers for full document
 *
 * Based on Issue #7: North Star loading optimization
 */

import * as fs from 'fs';
import * as path from 'path';

interface HookInput {
  cwd: string;
  session_id: string;
}

// ANSI color codes for output formatting
const COLORS = {
  BLUE: '\x1b[34m',
  GREEN: '\x1b[32m',
  YELLOW: '\x1b[33m',
  RESET: '\x1b[0m',
  BOLD: '\x1b[1m',
};

function formatBanner(title: string): string {
  const line = '━'.repeat(44);
  return `${COLORS.BLUE}${line}\n${COLORS.BOLD}${title}${COLORS.RESET}\n${COLORS.BLUE}${line}${COLORS.RESET}`;
}

function findNorthStarSummary(cwd: string): string | null {
  // Check for .coord symlink (coordination repository)
  const coordPath = path.join(cwd, '.coord');

  if (!fs.existsSync(coordPath)) {
    return null;
  }

  // Check if it's a symlink or directory
  const stats = fs.lstatSync(coordPath);
  if (!stats.isSymbolicLink() && !stats.isDirectory()) {
    return null;
  }

  // Look for North Star Summary in workflow-docs
  const workflowDocsPath = path.join(coordPath, 'workflow-docs');

  if (!fs.existsSync(workflowDocsPath)) {
    return null;
  }

  // Find any file matching *NORTH-STAR-SUMMARY*.md pattern
  try {
    const files = fs.readdirSync(workflowDocsPath);
    const summaryFile = files.find(f =>
      f.includes('NORTH-STAR-SUMMARY') && f.endsWith('.md')
    );

    if (summaryFile) {
      return path.join(workflowDocsPath, summaryFile);
    }
  } catch (error) {
    // Directory read failed, continue
  }

  return null;
}

function loadNorthStarSummary(summaryPath: string): string {
  try {
    const content = fs.readFileSync(summaryPath, 'utf-8');
    return content;
  } catch (error) {
    return '';
  }
}

function main(): void {
  try {
    // Read hook input from stdin
    const input: HookInput = JSON.parse(fs.readFileSync(0, 'utf-8'));
    const { cwd } = input;

    // Debug output if enabled
    const debug = process.env.CLAUDE_HOOKS_DEBUG === '1';
    if (debug) {
      console.error('DEBUG: CWD:', cwd);
    }

    // Find North Star Summary
    const summaryPath = findNorthStarSummary(cwd);

    if (debug) {
      console.error('DEBUG: Summary path:', summaryPath);
    }

    if (!summaryPath) {
      // No coordination or summary found - silent exit
      console.log(`${COLORS.GREEN}✓ SessionStart complete${COLORS.RESET}`);
      return;
    }

    // Load summary content
    const summaryContent = loadNorthStarSummary(summaryPath);

    if (!summaryContent || summaryContent.trim().length === 0) {
      console.log(`${COLORS.YELLOW}⚠️  North Star Summary found but could not be loaded${COLORS.RESET}`);
      return;
    }

    // Output formatted summary
    console.log(formatBanner('📋 NORTH STAR SUMMARY'));
    console.log();
    console.log(summaryContent);
    console.log();
    console.log(`${COLORS.BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLORS.RESET}`);
    console.log();
    console.log(`${COLORS.GREEN}✓ North Star Summary loaded from coordination${COLORS.RESET}`);
    console.log(`${COLORS.BLUE}  Location: ${path.relative(cwd, summaryPath)}${COLORS.RESET}`);
    console.log();

  } catch (error) {
    // Fail silently - don't block session startup
    console.error(`${COLORS.YELLOW}⚠️  SessionStart hook error: ${error instanceof Error ? error.message : 'Unknown error'}${COLORS.RESET}`);
  }
}

main();
