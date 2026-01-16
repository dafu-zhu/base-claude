# Installation

## Global (all projects)

```bash
git clone https://github.com/dafu-zhu/base-claude.git ~/base-claude && \
cp -r ~/base-claude/.claude/* ~/.claude/ && echo "Done. Restart Claude Code."
```

## Project (single repo)

```bash
git clone https://github.com/dafu-zhu/base-claude.git .base-claude && \
cp -r .base-claude/.claude . && echo "Done. Restart Claude Code."
```

## Verify

```bash
ls ~/.claude/commands/  # Global
ls .claude/commands/    # Project
```

## Update

```bash
cd ~/base-claude && git pull && cp -r .claude/* ~/.claude/   # Global
cd .base-claude && git pull && cp -r .claude ../             # Project
```

## Uninstall

```bash
rm -rf ~/.claude/{agents,commands,skills,templates,examples,rules,CLAUDE.md}  # Global
rm -rf .claude .base-claude                                                    # Project
```
