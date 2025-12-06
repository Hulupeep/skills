#!/bin/bash
# Install Claude skills for Ubuntu
# Location: ~/.claude/skills/user/

SKILL_DIR="$HOME/.claude/skills/user"

echo "🚀 Installing Claude Skills to $SKILL_DIR"

# Create directory structure
echo "📁 Creating directories..."
mkdir -p "$SKILL_DIR"/{debug-protocol,api-first-design,interruption-recovery,preflight-architecture,database-design,thin-slice-mvp,london-tdd,workflow-orchestration}

# Check if source files exist
if [ ! -f "SKILL-DEBUG-PROTOCOL.md" ]; then
    echo "❌ Error: Skill files not found in current directory"
    echo "💡 Make sure you're in the directory with your SKILL-*.md files"
    exit 1
fi

# Copy skills
echo "📋 Copying skill files..."
cp SKILL-DEBUG-PROTOCOL.md "$SKILL_DIR/debug-protocol/SKILL.md" && echo "  ✅ Debug Protocol"
cp SKILL-API-FIRST-DESIGN.md "$SKILL_DIR/api-first-design/SKILL.md" && echo "  ✅ API-First Design"
cp SKILL-INTERRUPTION-RECOVERY.md "$SKILL_DIR/interruption-recovery/SKILL.md" && echo "  ✅ Interruption Recovery"
cp SKILL-PREFLIGHT-ARCHITECTURE.md "$SKILL_DIR/preflight-architecture/SKILL.md" && echo "  ✅ Pre-Flight Architecture"
cp SKILL-DATABASE-DESIGN-PHILOSOPHY.md "$SKILL_DIR/database-design/SKILL.md" && echo "  ✅ Database Design"
cp SKILL-THIN-SLICE-MVP.md "$SKILL_DIR/thin-slice-mvp/SKILL.md" && echo "  ✅ Thin-Slice MVP"
cp london-tdd-skill-MERGED.md "$SKILL_DIR/london-tdd/SKILL.md" && echo "  ✅ London TDD"

echo ""
echo "✅ Skills installed successfully!"
echo ""
echo "📍 Location: $SKILL_DIR"
echo ""
echo "🔍 Verify installation:"
echo "  ls -la $SKILL_DIR"
echo ""
echo "📚 Available skills:"
ls -1 "$SKILL_DIR" | sed 's/^/  - /'
echo ""
echo "🎯 Next steps:"
echo "  1. Create the workflow orchestrator (see below)"
echo "  2. Restart Claude CLI"
echo "  3. Test with: claude --help"
