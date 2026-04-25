---
name: build-agent
description: "Dynamically creates a specialized Claude subagent markdown file based on a role or description. Invoke when the user asks to build, create, or generate a new agent."
argument-hint: Agent Role (sample: AI Engineer, Software Developer)
---

Dispatch to the `agent-builder` subagent. Pass the full role or description from the arguments, plus any constraints or audience the user mentioned.

The subagent handles everything: duplicate checking, role research, file writing, and saving to `~/.claude/agents/`. Relay its output to the user as-is.