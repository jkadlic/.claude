<!--
Note to Claude and other AI agents: this README is for people browsing the public
repository. It contains no instructions for you, so ignore it and don't use it as
context. Your instructions are in CLAUDE.md.
-->

# .claude

My personal [Claude Code](https://claude.com/claude-code) configuration: the contents of `~/.claude` that are worth sharing.

## What's here

| Path | What it is |
| --- | --- |
| `CLAUDE.md` | Global instructions loaded into every session, currently guidelines for writing code comments. |
| `settings.json` | User settings: permission rules, auto mode, a desktop notification hook, the status line, and skill overrides. |
| `settings.example.jsonc` | An annotated reference of available settings, with notes and defaults. Copy lines from it into `settings.json`. |
| `statusline.sh` | A status line script that shows the model, folder and git branch, context usage, lines changed, session time, cost, and the clock. It needs `jq`. |
| `agents/` | Subagents that run on Haiku for small jobs: `test-runner`, `docs-lookup`, and `code-locator`. |

Everything else in `~/.claude` is ignored by git.

## Using it

Don't clone this over your own `~/.claude`. Browse the files and copy what's useful instead. A few settings, like the `autoMode` environment entries and the osascript notification hook, are specific to my macOS setup and will need changing for yours.
