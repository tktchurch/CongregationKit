# Getting Started with TKT API v2

Learn how to authenticate and fetch congregation data using the v2-first ``CongregationKit`` handlers.

## Overview

New integrations should use **TKT API v2** (`/services/apexrest/v2/*`) via ``SyncQuery`` and ``SyncPage``.
Legacy v1 list endpoints remain as deprecated compatibility shims.

```swift
import AsyncHTTPClient
import CongregationKit

let httpClient = HTTPClient(eventLoopGroupProvider: .shared)
let credentials = SalesforceCredentials(
    clientId: ProcessInfo.processInfo.environment["SF_CLIENT_ID"]!,
    clientSecret: ProcessInfo.processInfo.environment["SF_CLIENT_SECRET"]!,
    username: ProcessInfo.processInfo.environment["SF_USERNAME"]!,
    password: ProcessInfo.processInfo.environment["SF_PASSWORD"]!
)

let congregation = try await CongregationKit(httpClient: httpClient, credentials: credentials)

var query = SyncQuery(pageSize: 50, fields: ["memberId", "firstName", "lastName", "campus"])
let page = try await congregation.members.fetchAll(
    query: query,
    filters: MemberListQuery(campus: .eastCampus, search: "Sample")
)
for member in page.records {
    print(member.memberId?.rawValue ?? "", member.firstName ?? "")
}
query.pageToken = page.nextPageToken
```

## Topics

### Authentication
- ``CongregationKit/init(httpClient:credentials:)``
- ``SalesforceCredentials``

### v2 handlers
- ``CongregationKit/members``
- ``CongregationKit/seekers``
- ``CongregationKit/tasks``
- ``CongregationKit/users``
- ``CongregationKit/courses``
- ``CongregationKit/familyRecords``
- ``CongregationKit/spiritualRecords``

### See also
- ``DeltaSync``
- ``MigratingFromV1``
