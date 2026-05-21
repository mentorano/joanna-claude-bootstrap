---
name: search-review-matrix
description: Code review of search/parsing/„many input forms" features requires explicit query-input matrix — don't trust verbal „smoke checked X, Y" claims from author. Adversarial input brainstorm + realistic fixture data prevent silent P0 regressions.
metadata:
  type: feedback
---

# PR review for search / parsing / „many input forms" features

**Rule:** When reviewing a feature whose job is to parse / interpret / fuzzy-match user input → always require an explicit query-input matrix before approve. Don't trust verbal „smoke checked numeric / Latin variants" claims without the exact strings.

**Why:** Search/parsing features have combinatorially many edge cases — punctuation-only, empty, very long, unknown scope, ambiguous tokens, impossible identifiers, mixed scripts. Without exhaustive matrix, bugs stay invisible until production / next user QA session. Verbal QA claim „tested numeric intent" usually covers 2-3 cases of 20+ hypothetical. Hit on fuzzy-search calibration follow-up: punctuation-only queries returned score=0 noise; unknown `field:<key>` scopes returned 500; document identifiers like `Д-01-465` and `28-04` produced price/area noise; impossible identifiers like `П-00-999999` returned weak fuzzy nearby matches; informal aliases like `дог.`, `решение`, `No`, `номер` were unrecognized.

**How to apply during review:**

1. **Ask author for exact query strings.** „Paste the точните input strings you tested in PR description." Verbal claims „covered numeric intent" aren't enough.
2. **Adversarial input brainstorm — 5 minutes.** What's the worst thing a real user could type? Cover at minimum:
   - Empty / whitespace only
   - Punctuation only (`@@@###`, `...`, `???`)
   - Very long (>500 chars)
   - All digits
   - All letters
   - Mixed scripts (Cyrillic + Latin, Latin + emoji, etc.)
   - Unicode tricks (zero-width spaces, RTL marks, NFC/NFD variants)
   - Invalid / unknown parameter values (scope, filter values, enum codes)
   - Impossible domain identifiers (numbers way out of valid range)
   - Real-world informal aliases from persona vocabulary (regional / domain shorthand)
3. **Verify realistic fixture data.** Test data in PR must include realistic domain identifiers with the actual patterns the persona will type — not simplistic test data like `entry_number=87`. Without realistic fixtures, intent-detection bugs stay invisible.
4. **Verify portable + non-portable test coverage split.** When project has dialect-portable tests (SQLite) + dialect-specific tests (Postgres): identifier-intent logic should have pure-function unit tests (SQLite-runnable, no DB) PLUS integration tests (Postgres). Environments without postgres otherwise don't catch regressions.
5. **My own e2e tests:** when I write tests after approve — explicit query matrix, not „basic happy path".

**Anti-patterns to avoid:**
- „Looks good, tests pass" approve without challenging input coverage.
- Trust on „live smoke checked X" verbal claim without the exact strings.
- Approve when test fixture data is too simple for real domain.
- Only positive cases in tests — without negative/impossible/edge cases.

Related: [[pre-implement-gates]] — same family of "verify-the-premise" before deep build.
