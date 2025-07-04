# CongregationKit
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftktchurch%2FCongregationKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/tktchurch/CongregationKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftktchurch%2FCongregationKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/tktchurch/CongregationKit)

> **A Swift SDK for working with Salesforce church data, made for The King's Temple Church (TKT Church).**

CongregationKit is a Swift package that helps you connect your app or server to Salesforce and work with church member data. It is designed for The King's Temple Church (TKT Church), but others can use it as a reference.

## What does it do?

- Lets you log in to Salesforce using your username and password
- Lets you fetch and work with church member data from Salesforce
- Lets you choose which parts of member data you want (like contact info, employment, marital, or discipleship info)
- Works with async/await in Swift
- Can be used on macOS or iOS, and with server frameworks like Vapor

## Installation

### Swift Package Manager

Add CongregationKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/tktchurch/CongregationKit.git", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version you want

## Quick Start

### 1. Set up your Salesforce credentials

```swift
import CongregationKit

let credentials = SalesforceCredentials(
    clientId: "your_client_id",
    clientSecret: "your_client_secret",
    username: "your_salesforce_username",
    password: "your_salesforce_password"
)
```

### 2. Create the client

```swift
import AsyncHTTPClient

let httpClient = HTTPClient.shared
let congregation = try await CongregationKit(httpClient: httpClient, credentials: credentials)
```

### 3. Fetch members (choose what info you want)

```swift
import SalesforceClient // for MemberExpand

let expanded: [MemberExpand] = [
    .contactInformation,
    .employmentInformation,
    .maritalInformation,
    .discipleshipInformation
]
let response = try await congregation.salesforceClient.members.fetchAll(
    accessToken: congregation.salesforceClient.auth.accessToken,
    instanceUrl: congregation.salesforceClient.auth.instanceUrl,
    pageNumber: 1,
    pageSize: 50,
    expanded: expanded
)
for member in response.members {
    print(member.memberName)
    print(member.contactInformation?.email)
    print(member.employmentInformation?.occupation)
    print(member.maritalInformation?.maritalStatus)
    print(member.discipleshipInformation?.waterBaptism?.date)
}
```

### 4. Fetch a specific member

```swift
let member = try await congregation.salesforceClient.members.fetch(
    memberId: someMemberID,
    accessToken: congregation.salesforceClient.auth.accessToken,
    instanceUrl: congregation.salesforceClient.auth.instanceUrl,
    expanded: [.discipleshipInformation, .contactInformation]
)
if let discipleship = member.discipleshipInformation {
    print(discipleship.waterBaptism?.date)
}
```

## What is field expansion?

When you fetch members, you can choose which parts of their data you want by passing an array of `MemberExpand` values. If you don't ask for a part, it will be `nil` in the result. This makes things faster and keeps your app simple.

| Expansion                | Property on Member           |
|--------------------------|-----------------------------|
| `.contactInformation`    | `member.contactInformation` |
| `.employmentInformation` | `member.employmentInformation` |
| `.maritalInformation`    | `member.maritalInformation` |
| `.discipleshipInformation` | `member.discipleshipInformation` |

## Error Handling

- `SalesforceAuthError` (login or network problems)
- `MemberError` (not found, invalid data, etc.)

## Requirements

- Swift 6.0+
- macOS 14.0+ / iOS 15.0+
- Xcode 15.0+

## License

MIT License. See [LICENSE](LICENSE) for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## Support

For support and questions, please open an issue on GitHub or contact the development team. 