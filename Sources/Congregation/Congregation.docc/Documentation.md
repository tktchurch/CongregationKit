# ``Congregation``

Core data models and protocols for church member and seeker management, providing type-safe, extensible structures for Salesforce integration.

## Overview

The `Congregation` module contains all the foundational data models, protocols, and enums used by `CongregationKit` for managing church member and seeker data. This module is designed with a protocol-oriented architecture that provides maximum flexibility and type safety.

- **Modular Design:** Data is organized into logical sub-structs for clarity and maintainability
- **Protocol-First:** All major data domains conform to protocols for extensible access
- **Type Safety:** Comprehensive enums and type-safe identifiers prevent runtime errors
- **Church-Specific:** Designed specifically for church management needs with spiritual journey tracking
- **Production Ready:** Robust error handling, date formatting, and data validation

## Architecture

The module is organized into three main areas:

### Members
Complete member data management with modular sub-structs:
- **Core Member Data:** Basic demographics, identifiers, and membership information
- **Contact Information:** Phone, email, address, and communication preferences
- **Employment Information:** Work status, organization, occupation, and sector
- **Marital Information:** Status, spouse details, anniversary tracking, and children
- **Discipleship Information:** Spiritual journey, courses, ministry involvement, and serving

### Seekers
Lead management and follow-up tracking:
- **Seeker Profiles:** Contact information, demographics, and entry tracking
- **Lead Management:** Status tracking and follow-up coordination
- **Campus Integration:** Multi-campus seeker management

### Authentication
Salesforce integration and security:
- **OAuth 2.0 Support:** Secure authentication with Salesforce
- **Credential Management:** Type-safe credential handling
- **Error Handling:** Comprehensive error types with localized descriptions

## Usage Example

```swift
import Congregation

// Create a member with comprehensive information
let member = Member(
    id: "12345",
    memberId: MemberID(validating: "TKT123456"),
    firstName: "John",
    lastName: "Doe",
    gender: .male,
    contactInformation: ContactInformation(
        phoneNumber: "+1234567890",
        email: "john.doe@example.com",
        address: "123 Main St",
        area: "Downtown"
    ),
    employmentInformation: EmploymentInformation(
        employmentStatus: .employed,
        nameOfTheOrganization: "Tech Corp",
        occupation: .it,
        sector: .privateSector,
        occupationSubCategoryRaw: "Software Engineer"
    ),
    maritalInformation: MaritalInformation(
        maritalStatus: .married,
        spouseName: "Jane Doe",
        numberOfChildren: 2
    ),
    discipleshipInformation: DiscipleshipInformation(
        bornAgainDate: "2020-01-15",
        waterBaptism: WaterBaptism(date: "2020-02-20", received: true),
        serving: ServingInformation(
            involved: .volunteers,
            primaryDepartment: .worshipTeam,
            interested: .yes
        )
    )
)

// Access rich date information
if let birthday = member.dateOfBirth {
    print("Age: \(birthday.age)")
    print("Next birthday: \(birthday.daysUntilNextBirthday) days")
}

if let anniversary = member.maritalInformation?.weddingAnniversaryInfo {
    print("Years of marriage: \(anniversary.yearsOfMarriage)")
    print("Next anniversary: \(anniversary.daysUntilNextAnniversary) days")
}
```

## Topics

### Core Member Models
- ``Member``
- ``MemberID``
- ``MemberData``
- ``MemberResponse``

### Contact & Personal Information
- ``ContactInformation``
- ``BirthDateInfo``
- ``Gender``
- ``MemberTitle``
- ``MemberType``
- ``BloodGroup``
- ``PreferredLanguage``

### Employment & Professional
- ``EmploymentInformation``
- ``EmploymentStatus``
- ``Occupation``
- ``OccupationSubCategory``
- ``Sector``

### Family & Relationships
- ``MaritalInformation``
- ``MaritalStatus``
- ``WeddingAnniversaryInfo``

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
- ``SubscriptionStatus``

### Membership & Campus
- ``MemberStatus``
- ``AttendingCampus``
- ``ServiceCampus``
- ``Campus``
- ``AttendingService``
- ``MemberExpand``

### Seeker Management
- ``Seeker``
- ``SeekerResponse``
- ``Lead``
- ``LeadStatus``
- ``TypeOfEntry``

### Authentication
- ``SalesforceCredentials``
- ``SalesforceAuthResponse``
- ``SalesforceAuthError``

### Core Protocols
- ``MemberDataRepresentable``
- ``ContactInformationRepresentable``
- ``EmploymentInformationRepresentable``
- ``MaritalInformationRepresentable``
- ``DiscipleshipInformationRepresentable``
- ``SeekerDataRepresentable``

### Error Handling
- ``MemberError``
- ``SeekerError``

## Key Features

### Rich Date Intelligence
- **BirthDateInfo:** Professional birthday formatting with age calculations
- **WeddingAnniversaryInfo:** Anniversary tracking with years of marriage and next anniversary calculations
- **Multiple Formats:** Short, US, and full date formats for different use cases

### Comprehensive Discipleship Tracking
- **Spiritual Milestones:** Born again date, water baptism, Holy Spirit filling
- **Course Completion:** Prayer course, foundation course, Bible course modules
- **Ministry Involvement:** Serving status, departments, and interest levels
- **Communication Preferences:** YouTube and WhatsApp subscription tracking

### Type-Safe Identifiers
- **MemberID:** Validates TKT prefix and provides normalization
- **Enum-Based Status:** All status fields use enums for compile-time safety
- **Protocol Conformance:** Consistent access patterns across all data models

### Modular Architecture
- **Sub-Structs:** Logical grouping of related data fields
- **Protocol Extensions:** Type-safe access to nested information
- **Backward Compatibility:** Maintains compatibility while adding new features

## Design Principles

### Church-First Design
All models and enums are designed with church-specific needs in mind, including:
- Spiritual journey tracking
- Ministry involvement management
- Multi-campus support
- Discipleship program integration

### Production Readiness
- Comprehensive error handling
- Localized error descriptions
- Concurrency safety with `Sendable`
- Robust date parsing and formatting

### Extensibility
- Protocol-oriented design allows for easy extension
- Modular structure supports adding new data domains
- Type-safe enums prevent runtime errors
- Backward-compatible API evolution 