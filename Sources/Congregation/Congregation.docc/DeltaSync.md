# Delta Sync

Use ``SyncMetadata``, ``SyncQuery``, and ``SyncPage`` for cursor pagination and incremental pulls.

## Overview

Every v2 resource includes sync fields decoded into ``SyncMetadata`` on models conforming to ``SyncMetadataRepresentable``.

```swift
var query = SyncQuery(
    pageSize: 100,
    updatedAfter: lastSuccessfulSync
)

repeat {
    let page = try await congregation.members.fetchAll(query: query, filters: nil)
    for member in page.records {
        if let etag = member.sync?.etag {
            store(member, etag: etag)
        }
    }
    query.pageToken = page.nextPageToken
} while query.pageToken != nil
```

### Optimistic writes

Pass ``SyncWriteOptions`` with `ifMatch` (etag) and optional `idempotencyKey` for mutating v2 calls.

```swift
try await congregation.tasks.complete(
    id: taskId,
    options: SyncWriteOptions(ifMatch: task.sync?.etag, idempotencyKey: UUID().uuidString)
)
```

## Topics

- ``SyncQuery``
- ``SyncPage``
- ``SyncMetadata``
- ``SyncWriteOptions``
- ``SyncError``

## See also

- ``MigratingFromV1``
