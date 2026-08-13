# AI & Automated Agent Policy

This document outlines our policy on AI-assisted contributions and automated agents interacting with this project.

## Issues

### Security Issues

Security vulnerabilities (especially anything touching Salesforce credentials, access tokens, or member/congregation data) must be reported by humans through a private channel — do not open a public issue. Automated scanning tools may identify potential issues, but all security reports must be reviewed, verified, and submitted by a human. Automated or AI-generated security reports will be closed without action.

### General Issues

Issues must reflect genuine, human-identified bugs or feature requests. We will close issues that appear to be generated entirely by an automated agent without meaningful human review. Low-effort, bot-generated issues waste maintainer time and will not be tolerated.

## Pull Requests

We welcome AI-assisted contributions under the following conditions:

- **A human must author and submit the PR.** Using AI tools (Copilot, Claude, Cursor, etc.) to help write or refine code is fine, but a human must understand, review, and take responsibility for every change in the PR.
- **Fully automated PRs will be closed.** If a PR appears to have been generated and submitted by an agent with no meaningful human involvement, we will close it.
- **Contributors must be able to discuss their changes.** Maintainers may ask questions about implementation choices during review, including why a change was made a particular way with respect to the `Congregation` → `SalesforceClient` → `CongregationKit` layering. You should be able to explain and defend your approach.
- **AI-generated code must meet the same standards as any other contribution.** It must build cleanly (`swift build`), pass `swift format lint --strict --recursive .`, not trigger unintended public API changes (see `api-check.yml`), include tests where appropriate, and follow the conventions described in `CLAUDE.md`.
- **No real Salesforce credentials, tokens, or member data in commits, PR descriptions, or test fixtures.** Ever, AI-assisted or not.

## Commit Attribution

Do not attribute commits or PRs to an AI tool or agent as author or co-author. A human contributor is the author of record for every commit.

## How We Identify Automated Contributions

We look for patterns such as:

- Generic or templated issue descriptions with no project-specific context
- PRs submitted moments after an issue is opened
- Inability to respond to review feedback in a meaningful way
- Bulk submissions across multiple issues in a short timeframe
- Commit messages or PR descriptions that read like raw LLM output
- Public API changes or Salesforce endpoint/schema changes with no explanation of why they're needed

Maintainers reserve the right to close any issue or PR that we believe violates this policy. These decisions are made at our discretion and are final.

## Why This Policy Exists

CongregationKit handles real church member data. Open source thrives on human collaboration, and this project additionally carries a responsibility to the congregation whose data flows through it. Automated noise — whether from bots filing low-quality issues or agents submitting unreviewed code — drains maintainer energy, and unreviewed AI-generated changes to a data-handling library carry real risk. This policy exists to protect contributor experience, maintain code quality and data safety, and keep CongregationKit a welcoming place for people who want to learn and contribute.
