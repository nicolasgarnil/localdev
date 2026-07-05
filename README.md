# localdev

Personal local development configuration, versioned so it can be reproduced on any machine.

## Contents

- `.claude/statusline-command.sh` - Claude Code status line script; prints the model name and total token usage (e.g. `Opus 4.8 · 10.2k`).
- `install.sh` - symlinks the versioned config files into their expected locations under `$HOME`; idempotent, safe to re-run.
- `.gitconfig` - Git configuration.

## Setup on a new machine

```bash
git clone git@github.com:nicolasgarnil/localdev.git
cd localdev
./install.sh
```

`install.sh` creates symlinks (not copies), so editing a file in this repo takes effect immediately and stays under version control.

### Claude Code status line

`install.sh` links `.claude/statusline-command.sh` to `~/.claude/statusline-command.sh`.
Point Claude Code at it by adding the following to `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "bash ~/.claude/statusline-command.sh"
}
```
