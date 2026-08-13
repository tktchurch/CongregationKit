# Migrating from v1 to v2

Move from legacy Apex list endpoints to the TKT API v2 sync model.

## Overview

| v1 (deprecated) | v2 (preferred) |
|---|---|
| ``MembersHandler/fetchAll(pageNumber:pageSize:)`` | ``MembersHandler/fetchAll(query:filters:)`` |
| ``MemberResponse`` pagination | ``SyncPage`` cursor tokens |
| Client-side ``MemberExpand`` filtering | Server ``fields`` query param via ``SyncQuery`` |
| Household ``Family`` / ``RFID`` (Congregation domain) | Unchanged — v2 transport adds ``FamilyRecord`` + ``cardIssued`` snapshot, it does not replace them |

### Members

```swift
// Before (v1-style)
let response = try await congregation.members.fetchAll(pageNumber: 1, pageSize: 50)

// After (v2)
let page = try await congregation.members.fetchAll(
    query: SyncQuery(pageSize: 50),
    filters: MemberListQuery(campus: .eastCampus)
)
```

Bridge legacy wrappers with ``MemberResponse/init(from:)`` when needed during migration.

``Family`` / ``RFID`` remain Congregation domain types. v2 adds ``FamilyRecord`` (person/dependent row) whose ``cardIssued`` is a boolean snapshot only — not a replacement for RFID lifecycle.

`GET /v2/members/{id}` returns the full pastoral field set (marital, employment, discipleship, photo). List stays lean. Embed siblings with ``MemberExpand/family`` (and `spiritualRecords`, `courses`, `tasks`):

```swift
let member = try await congregation.members.fetch(
    id: memberId,
    query: nil,
    expand: [.family, .courses]
)
```

### Seekers

```swift
let page = try await congregation.seekers.fetchAll(
    query: SyncQuery(pageSize: 25),
    filters: SeekerListQuery(leadStatus: .attempted)
)
```

## See also

- ``GettingStarted``
- ``DeltaSync``
- ``FamilyRecord``
- ``Family``
- ``RFID``
