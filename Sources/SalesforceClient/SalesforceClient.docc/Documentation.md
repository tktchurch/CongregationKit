# ``SalesforceClient``

A robust Swift client for Salesforce integration, powering TKT Church and adaptable for any church or organization needing secure, type-safe Salesforce API access.

## Overview

`SalesforceClient` is a modern, async/await-based Swift client for Salesforce, designed for The King's Temple Church (TKT Church) but extensible for any church or organization. It provides modular API routes, secure authentication, and type-safe models for real-world church data.

- **Modular API Routes:** Access authentication and member management via dedicated protocols and route handlers.
- **Type-Safe Models:** All data models are designed for clarity, extensibility, and real-world church needs.
- **Async/Await:** All API calls are async/await and concurrency-safe (`Sendable`).
- **Production-Ready:** Secure, well-documented, and tested for church-scale data.

## Usage Example

```swift
import SalesforceClient
import AsyncHTTPClient

let httpClient = HTTPClient(eventLoopGroupProvider: .shared)
let salesforce = SalesforceClient(httpClient: httpClient)
let credentials = SalesforceCredentials(
    clientId: "your_client_id",
    clientSecret: "your_client_secret",
    username: "your_username",
    password: "your_password"
)
let authResponse = try await salesforce.auth.authenticate(credentials: credentials)
let members = try await salesforce.members.fetchAll(
    accessToken: authResponse.accessToken,
    instanceUrl: authResponse.instanceUrl,
    expanded: [.contactInformation, .employmentInformation]
)
```

## Usage Guidelines & Best Practices

### 1. Authentication Security
- **Never hardcode credentials** in source code. Use environment variables or secure vaults.
- Rotate Salesforce credentials regularly and restrict permissions to the minimum required.
- Use HTTPS for all network communication.

### 2. Data Privacy & Compliance
- **Handle member data as sensitive personal information.**
- Comply with all relevant data protection laws (e.g., GDPR, Indian IT Act, CCPA).
- Do not log or expose personally identifiable information (PII) in logs or error messages.
- Ensure data is encrypted at rest and in transit.
- Provide a way for members to request data deletion or export, as required by law.

### 3. Error Handling
- Use `do-catch` blocks to handle errors from async API calls.
- Inspect error types (e.g., network errors, authentication failures, Salesforce API errors) and respond appropriately.
- Implement retry logic for transient errors, but avoid infinite retries.

### 4. Rate Limits & API Usage
- Be aware of Salesforce API rate limits. Exceeding limits may result in temporary bans.
- Use field expansion to fetch only the data you need, reducing API load.
- Paginate large data sets using the provided pagination parameters.

### 5. Async/Await & Concurrency
- All API calls are `async` and `Sendable` for safe use in concurrent contexts.
- Avoid blocking the main thread in iOS/macOS apps.
- Use structured concurrency (e.g., `Task { ... }`) for parallel operations.

### 6. Responsible Use & Compliance
- Use this SDK only for legitimate church/organizational purposes.
- Do not share access tokens or credentials with unauthorized users.
- Regularly audit access and usage logs for suspicious activity.
- Follow Salesforce's Acceptable Use Policy and your local data protection regulations.

## Key Features
- Modular, protocol-oriented API routes
- Type-safe, extensible models for member and discipleship data
- Field expansion for efficient data access
- Full async/await and concurrency safety
- Designed for TKT Church, but reusable by any church or organization

## Topics
### Creating a Client
- ``SalesforceClient/init(httpClient:)``

### Available Services
- ``SalesforceClient/auth``
- ``SalesforceClient/members``

### Data Models
- ``Member``
- ``DiscipleshipInformation``
- ``EmploymentInformation``
- ``ContactInformation``

### Protocols
- ``SalesforceAuthRoutes``
- ``SalesforceMemberRoutes``

## Dedication
This client is dedicated to The King's Temple Church (TKT Church), Hyderabad, India and is open for use by any church or organization seeking to modernize their congregation management with Salesforce.