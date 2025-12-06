# Claude Code Skills - Directory Structure

## Location

Skills are stored in: `~/.claude/skills/`

(Full path: `/home/xanacan/.claude/skills/`)

## Structure

Each skill is organized as a folder containing a `SKILL.md` file:

```
~/.claude/skills/
├── api-first-design/
│   └── SKILL.md
├── database-design/
│   └── SKILL.md
├── debug-protocol/
│   └── SKILL.md
├── interruption-recovery/
│   └── SKILL.md
├── london-tdd/
│   └── SKILL.md
├── preflight-architecture/
│   └── SKILL.md
├── thin-slice-mvp/
│   └── SKILL.md
├── web-builder/
│   └── SKILL.md
├── workflow-orchestration/
│   └── SKILL.md
└── README.md (this file)
```

## Skill File Format

Each `SKILL.md` file contains:

1. **Frontmatter** (YAML):
   ```yaml
   ---
   name: Skill Name
   description: Brief description of what the skill does
   ---
   ```

2. **Content**: Detailed skill instructions in Markdown

## How to Use Skills

### From CLI

Skills can be invoked using the Skill tool:

```bash
# Invoke a skill by folder name
skill("api-first-design")
skill("london-tdd")
skill("web-builder")
```

### Referencing Other Skills

When one skill needs to reference another, use relative paths:

```bash
# From workflow-orchestration/SKILL.md
../thin-slice-mvp/SKILL.md
../web-builder/SKILL.md
../london-tdd/SKILL.md
```

## Adding New Skills

### Workflow When You Add a New Skill

**You do:**
1. Drop a new markdown file (e.g., `new-skill-name.md`) into `~/.claude/skills/`

**Claude does:**
1. Create folder: `~/.claude/skills/new-skill-name/`
2. Move content to: `~/.claude/skills/new-skill-name/SKILL.md`
3. Remove original file: `~/.claude/skills/new-skill-name.md`
4. Update `workflow-orchestration/SKILL.md`:
   - Add skill count if needed
   - Add to skill reference links section
   - Add to workflow decision tree if applicable
   - Add to LLM requirements if applicable

### Example

**You drop:** `time-boxing.md`

**Claude creates:**
```
~/.claude/skills/
├── time-boxing/           # New folder created
│   └── SKILL.md          # Content from time-boxing.md moved here
└── (time-boxing.md deleted)
```

**Claude updates:** `workflow-orchestration/SKILL.md` with references to the new skill

## Orchestrator

The **workflow-orchestration** skill coordinates all other skills and determines which skill to use based on the current task.

**Always start with**: Read `workflow-orchestration/SKILL.md` to understand which skill to use for your current work.
