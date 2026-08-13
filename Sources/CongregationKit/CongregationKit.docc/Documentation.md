# ``CongregationKit``

A high-level Swift SDK for TKT Church and other churches to integrate with Salesforce and manage congregation data, designed for clarity, extensibility, and real-world church needs.

## Overview

`CongregationKit` provides a modern, async/await-based interface for accessing and managing church member, seeker, and file data via Salesforce. It is dedicated to The King's Temple Church (TKT Church), but is also modular and extensible for use by other churches or organizations seeking robust, type-safe data models and protocols.

- **Modular Models:** Member, seeker, and file data are split into sub-structs for clarity and extensibility.
- **Protocols:** All major data domains conform to protocols for type-safe, extensible access.
- **Field Expansion:** Field expansion lets you fetch only the data you need, improving performance and clarity (for members).
- **File Management:** Secure file download capabilities with proper metadata extraction.
- **Async/Await:** All API calls are async/await and concurrency-safe (`Sendable`).
- **Cross-Platform:** Works on macOS and iOS, and is ready for both server-side (Vapor/Hummingbird) and app use.
- **Production-Ready:** Secure, well-documented, and tested for real-world church data.
- **Rich Date Handling:** Professional date formatting for birthdays and anniversaries with age calculations.
- **Comprehensive Discipleship Tracking:** Complete spiritual journey tracking with modular sub-structs.

## Usage Example

```swift
// v2 (preferred): cursor pagination + field selection
var query = SyncQuery(pageSize: 50, fields: ["memberId", "firstName", "campus"])
let page = try await congregation.members.fetchAll(
    query: query,
    filters: MemberListQuery(campus: .eastCampus, status: .regular)
)

// Ops work queue
let tasks = try await congregation.tasks.fetchAll(
    query: SyncQuery(pageSize: 25),
    filters: FollowUpTaskQuery(view: .openSeekers, mine: true)
)
```

## DocC Articles

- ``GettingStarted``
- ``MigratingFromV1``
- ``OpsWorkQueue``

## Topics

### Creating a Client

### Core Functionality
- Modular, extensible models for member, seeker, and file data
- Field expansion for efficient member data access
- Secure file download with metadata extraction
- Protocol-oriented design for maximum flexibility
- Full async/await and concurrency safety
- Designed for TKT Church, but reusable by any church or organization

### Rich Data Models
- **Member Management:** Complete member profiles with contact, employment, marital, and discipleship information
- **Seeker Tracking:** Lead management and follow-up tracking
- **File Management:** Secure file download with proper content type and filename extraction
- **Date Intelligence:** Professional birthday and anniversary formatting with age calculations
- **Spiritual Journey:** Comprehensive discipleship tracking including baptism, courses, and ministry involvement

### Authentication & Security
- Secure Salesforce OAuth 2.0 integration
- Type-safe credential management
- Error handling with localized descriptions
- Rate limiting support
- Secure file handling with proper content validation

### Available Services
- ``CongregationKit/members``
- ``CongregationKit/seekers``
- ``CongregationKit/files``
- ``CongregationKit/tasks``
- ``CongregationKit/users``
- ``CongregationKit/courses``
- ``CongregationKit/familyRecords``
- ``CongregationKit/spiritualRecords``

## Key Features
- ``Member``
- ``Seeker``
- ``MemberID``
- ``FileDownloadResponse``

### Contact & Personal Information
- ``ContactInformation``
- ``BirthDateInfo``
- ``WeddingAnniversaryInfo``

### Employment & Professional
- ``EmploymentInformation``
- ``EmploymentStatus``
- ``Occupation``
- ``Sector``

### Family & Relationships
- ``MaritalInformation``
- ``MaritalStatus``

### Spiritual Development
- ``DiscipleshipInformation``
- ``WaterBaptism``
- ``PrayerCourse``
- ``FoundationCourse``
- ``ServingInformation``
- ``MinistryInvolvement``
- ``PrimaryDepartment``
- ``InterestedToServe``
- ``BibleCourse``
- ``MissionaryType``

### Communication & Subscriptions
- ``SubscriptionStatus``

### Demographics & Classification
- ``Gender``
- ``MemberTitle``
- ``MemberType``
- ``BloodGroup``
- ``PreferredLanguage``
- ``MemberStatus``
- ``AttendingCampus``
- ``ServiceCampus``
- ``Campus``
- ``AttendingService``

### Protocols
- ``CongregationKitProtocol``
- ``MemberDataRepresentable``
- ``ContactInformationRepresentable``
- ``EmploymentInformationRepresentable``
- ``MaritalInformationRepresentable``
- ``DiscipleshipInformationRepresentable``
- ``SeekerDataRepresentable``

### Handlers
- ``MembersHandler``
- ``SeekersHandler``
- ``FilesHandler``
- ``SalesforceMembersHandler``
- ``SalesforceSeekersHandler``
- ``SalesforceFilesHandler``

### Authentication
- ``SalesforceCredentials``
- ``SalesforceAuthResponse``
- ``SalesforceAuthError``

### Errors
- ``MemberError``
- ``SeekerError``
- ``FileDownloadError``

### Utilities
- ``MemberExpand``
- ``MemberResponse``
- ``SeekerResponse``

## Dedication

This SDK is dedicated to The King's Temple Church (TKT Church), Hyderabad, India and is open for use by any church or organization seeking to modernize their congregation management with Salesforce.