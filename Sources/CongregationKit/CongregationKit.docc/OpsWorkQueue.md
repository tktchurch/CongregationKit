# Ops Work Queue

Use ``FollowUpTask`` and ``StaffUser`` for church operations follow-up — not congregation members.

## Overview

Salesforce `Task` records map to ``FollowUpTask``. Salesforce `User` records map to ``StaffUser`` (ops staff who own tasks).

```swift
let page = try await congregation.tasks.fetchAll(
    query: SyncQuery(pageSize: 25),
    filters: FollowUpTaskQuery(view: .openSeekers, mine: true)
)

for task in page.records {
    print(task.subject ?? "", task.ownerName ?? "")
}

let me = try await congregation.users.fetchMe(query: nil)
```

### Task actions

```swift
let completed = try await congregation.tasks.complete(
    id: FollowUpTaskID(rawValue: taskId)!,
    options: SyncWriteOptions(ifMatch: task.sync?.etag)
)
```

## Topics

- ``FollowUpTask``
- ``FollowUpTaskQuery``
- ``StaffUser``
- ``TasksHandler``
- ``UsersHandler``

## See also

- ``PeopleTypes``
