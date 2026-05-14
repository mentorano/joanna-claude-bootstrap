---
name: For browser smoke tests, prefer Claude in Chrome (visible) over headless agent-browser
description: When running end-to-end browser smoke tests at chunk-end, drive Joanna's real Chrome via Claude_in_Chrome MCP so she can watch the flow live. Agent-browser headless only for cases where visibility adds no value.
type: feedback
originSessionId: 04db2d29-3609-4234-acfb-c62225e8e046
---
For end-to-end browser smoke tests, **default to `Claude_in_Chrome` MCP**, not the headless `agent-browser` MCP. Joanna watches the flow happen in her own Chrome — sees clicks land, forms fill, pages navigate.

**When to use Claude in Chrome (default):**
- Chunk-end smoke verification
- Anything Joanna may want to watch
- Visual debugging when a page is misbehaving
- Demo prep / dry runs

**When agent-browser headless is acceptable:**
- Batch verification with no user value in watching (e.g. parametric sweep across many URLs)
- Background runs where Joanna isn't actively watching
- Fallback if Chrome plugin isn't connected — verify with `mcp__Claude_in_Chrome__list_connected_browsers`

**Why:** Joanna comes from Vercel-style projects where she opens the preview URL in her own browser and clicks around. "I can see what's happening" is part of her trust mechanism — without it, smoke tests feel like a black box and headless screenshots after-the-fact don't replace watching live. Stated explicitly 2026-05-13.

**How to apply:**
1. Before running browser smoke, call `mcp__Claude_in_Chrome__list_connected_browsers` to verify the plugin is connected.
2. If connected → use Claude in Chrome end-to-end.
3. If not connected → fall back to agent-browser, surface to Joanna that Chrome plugin needs setup.
4. Either way: take screenshots at key states (after form submit, page change, error state) so the chat record has visual evidence, not just claims.
