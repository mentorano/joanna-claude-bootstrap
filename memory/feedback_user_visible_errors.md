---
name: user-visible-errors
description: Every async user-triggered mutation MUST have explicit try/catch with user-visible feedback (toast/banner/inline error). Never silent fail to console.
metadata:
  type: feedback
---

**Rule:** Every async user-triggered mutation has explicit `try/catch` that surfaces the error to the user via toast, banner, or inline UI. Network errors, 4xx, 5xx — all must produce visible feedback. Silent console-only errors are forbidden.

**Why:** When a user clicks a button and nothing happens, they don't know:
- Did the action succeed silently?
- Is the page still loading?
- Did it fail and they should retry?

Without feedback, the user re-clicks (creates dupes), refreshes (loses state), or gives up. The cost of an unhandled error reaching the console is repeated user frustration — far worse than a slightly clunky error toast.

Hit multiple times in this project: 422 validation errors on add-row, 409 conflicts on unhide — both visible only in console, user just saw nothing happen.

**How to apply:**

For every component-level mutation handler:

```ts
const handleAction = async (...) => {
  try {
    await mutation.mutateAsync(payload);
    toast.show("Success message", "success");
    // navigate / close / reset state
  } catch (err) {
    toast.show(
      extractFriendlyError(err, "Default error message"),
      "error",
    );
  }
};
```

**Where to wire:**

- Component-level handlers (not just the mutation hook itself)
- InlineEditField `onSave` — if it can fail, surface or rethrow with a useful message
- Form submission handlers
- Drag-drop reorder handlers
- Any place `mutation.mutateAsync()` is called

**Error message extraction helper:**

Build a shared util like `extractFriendlyError(err, fallback)` that handles all the common formats:
- Domain error: `response.data.detail` is a string → use it
- Pydantic validation: `response.data.detail` is array of `{loc, msg, type}` → format as "Field „X": message"
- Network/timeout: fall back to `err.message` or generic
- Unknown: use the provided fallback

Without this, axios surfaces unhelpful "Request failed with status code 422" — useless to user.

**Don't trust mutation `onError` alone:**

React Query mutation has an `onError` callback at the hook level. That's fine for telemetry/logging, but NOT a substitute for component-level handling. Reasons:
- Component knows the user's context (which button clicked, what to navigate to on success)
- Component can decide what UI surface to use (toast vs inline error vs banner)
- Hook-level error handlers can't `navigate()` or `setState()` cleanly

So: hook returns a mutation, component handlers wrap it with try/catch + toast.

**Anti-patterns:**

- `await mutation.mutateAsync(...)` without try/catch — promise rejection propagates to console only.
- `mutation.mutate(...)` fire-and-forget — no way to know if it succeeded; UX entirely state-driven by cache invalidation.
- Generic `toast.show(err.message, "error")` — surfaces "Request failed with status code 422" to user, which is not human-friendly.

**Pair with:** [[cross-impact-reasoning]] — when a backend constraint changes, the UI error path MUST surface the new conflict messages. [[smoke-test-downstream]] — mutation smoke must verify the error UI fires, not just the happy path.
