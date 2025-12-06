# Skills Collection

A collection of Claude Code skills I use. Some from Anthropic, some custom. Use and modify at will.

## Installation

Copy the skill folder to your Claude Code skills directory:

```bash
cp -r <skill-folder> ~/.claude/skills/
```

Or clone the whole repo:

```bash
git clone https://github.com/Hulupeep/skills.git
cp -r skills/<skill-name> ~/.claude/skills/
```

---

## Skills

### Development Workflow

| Skill | Description |
|-------|-------------|
| **issue-first-dev-loop** | Enforces Issue → Plan → Code workflow. Never proposes code on first response to bug reports. Transforms messy complaints into structured issues with acceptance criteria, then change plans, then implementation. |
| **preflight-architecture** | Forces architectural decisions BEFORE coding. Present options, human chooses, integration tests prove the choice. Prevents paint-layering and late rewrites. |
| **thin-slice-mvp** | Forces smallest possible working end-to-end flow first. Hardcode everything, prove value, then expand. Prevents overengineering. |
| **api-first-design** | Define API contracts BEFORE implementation. Prevents frontend/backend misalignment and breaking changes. |
| **database-design** | Query-first database design. Define queries before schema, start minimal, grow incrementally. |

### Debugging & Quality

| Skill | Description |
|-------|-------------|
| **debug-protocol** | Methodical troubleshooting with hypothesis-driven investigation. Binary search approach. LLM must show reasoning at each step. Prevents "try random things" debugging. |
| **proof-of-work-agent** | Trust-verification framework. Forces evidence and receipts before code changes. LLM must prove it analyzed the right code and followed instructions. |
| **webapp-testing** | Test local web applications using Playwright for UI verification and debugging. |

### Context & Recovery

| Skill | Description |
|-------|-------------|
| **interruption-recovery** | Preserves context during hyperfocus sessions. Enables fast resumption after interruptions. Automatic checkpoints for 2-4 hour work windows. |

### Creative & Design (from Anthropic)

| Skill | Description |
|-------|-------------|
| **algorithmic-art** | Create generative art using p5.js with seeded randomness, flow fields, and particle systems. |
| **slack-gif-creator** | Create animated GIFs optimized for Slack's size constraints. |
| **theme-factory** | Style artifacts with 10 pre-set professional themes or generate custom themes. |
| **internal-comms** | Write internal communications like status reports, newsletters, and FAQs. |

---

## Skill Format

Each skill is a folder with a `SKILL.md` file:

```markdown
---
name: my-skill-name
description: When to use this skill and what it does
---

# My Skill Name

[Instructions Claude follows when skill is active]
```

## License

Apache 2.0 - Use and modify freely.
