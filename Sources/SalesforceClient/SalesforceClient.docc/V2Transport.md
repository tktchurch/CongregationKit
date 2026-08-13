# TKT API v2 Transport

Low-level HTTP access to `/services/apexrest/v2` via ``TktApiV2Client``.

## Overview

``SalesforceClient/v2`` exposes typed list/get/create methods for all v2 collections. It handles:

- Bearer auth headers
- ``If-Match`` / ``Idempotency-Key`` via ``SyncWriteOptions``
- Cursor pagination query params from ``SyncQuery``
- HTTP error mapping to ``SyncError``

```swift
let client = SalesforceClient(httpClient: httpClient)
let auth = try await client.auth.authenticate(credentials: credentials)

let page = try await client.v2.listMembers(
    accessToken: auth.accessToken,
    instanceUrl: auth.instanceUrl,
    query: SyncQuery(pageSize: 50),
    filters: MemberListQuery(campus: .eastCampus)
)
```

Legacy ``SalesforceMemberRoutes`` / ``SalesforceSeekerRoutes`` remain for v1 compatibility but are deprecated.

## Topics

- ``TktApiV2Client``
- ``SalesforceAPIConstants/apiV2Base``
- ``SalesforceAPIHandler/processV2Response(_:as:)``

## See also

- ``DeltaSync`` (Congregation module)
