import Foundation

/// Represents a church seeker from Salesforce with comprehensive contact, demographic, and lead management information.
///
/// The `Seeker` struct is the central data model for church seeker management, providing a complete
/// representation of individuals who are exploring faith or considering church involvement. It supports
/// lead tracking, follow-up coordination, and demographic analysis for effective outreach.
///
/// ## Overview
///
/// This struct consolidates seeker information from Salesforce into logical categories:
/// - **Core Identity:** Basic demographics, identifiers, and contact information
/// - **Lead Management:** Lead status, entry type, and follow-up tracking
/// - **Demographics:** Age, marital status, and geographic information
/// - **Contact Data:** Phone, email, and communication preferences
/// - **Entry Tracking:** Type of entry and creation date for follow-up planning
///
/// ## Key Features
///
/// - **Lead Integration:** Complete lead management with status tracking
/// - **Age Calculation:** Automatic age calculation from date of birth
/// - **Age Group Classification:** Demographic grouping for ministry planning
/// - **Church-Specific Design:** Built for seeker ministry and follow-up coordination
/// - **Protocol Conformance:** Implements `SeekerDataRepresentable` for type-safe access
/// - **Flexible Contact Handling:** Multiple contact methods and preferences
///
/// ## Example Usage
///
/// ```swift
/// // Create a seeker with comprehensive information
/// let seeker = Seeker(
///     id: "12345",
///     lead: Lead(id: "LEAD001", status: .attempted),
///     fullName: "John Doe",
///     email: "john.doe@example.com",
///     phone: "+1234567890",
///     dateOfBirth: Date(), // Example date
///     area: "Downtown",
///     typeOfEntry: .newVisitor,
///     maritalStatus: .single
/// )
///
/// // Access lead information
/// if let lead = seeker.lead {
///     print("Lead ID: \(lead.id ?? "Unknown")")
///     print("Lead status: \(lead.status?.displayName ?? "Unknown")")
/// }
///
/// // Access demographic information
/// if let age = seeker.age {
///     print("Age: \(age)")
/// }
///
/// if let ageGroup = seeker.ageGroup {
///     print("Age group: \(ageGroup)")
/// }
///
/// // Use for ministry planning
/// if let entryType = seeker.typeOfEntry {
///     switch entryType {
///     case .newVisitor:
///         print("New visitor - send welcome package")
///     case .salvation:
///         print("Salvation decision - immediate follow-up needed")
///     default:
///         print("Other entry type")
///     }
/// }
///
/// // Check contact information
/// if let email = seeker.email {
///     print("Email: \(email)")
/// }
///
/// if let phone = seeker.phone {
///     print("Phone: \(phone)")
/// }
/// ```
///
/// ## Topics
///
/// ### Core Identity
/// - ``id`` - The unique identifier for the seeker
/// - ``fullName`` - The seeker's full name
///
/// ### Lead Management
/// - ``lead`` - The lead information for the seeker
///
/// ### Contact Information
/// - ``email`` - The seeker's email address
/// - ``phone`` - The seeker's phone number
///
/// ### Demographics
/// - ``dateOfBirth`` - The seeker's date of birth
/// - ``age`` - The seeker's calculated age
/// - ``ageGroup`` - The seeker's age group classification
/// - ``maritalStatus`` - The seeker's marital status
///
/// ### Geographic Information
/// - ``area`` - The seeker's area or locality
///
/// ### Entry Information
/// - ``typeOfEntry`` - The type of entry for the seeker
/// - ``createdDate`` - The date the seeker was created
///
/// ## Church-Specific Features
///
/// ### Lead Management
/// - **Lead Tracking:** Complete lead status and ID management
/// - **Follow-up Coordination:** Entry type and creation date for follow-up planning
/// - **Status Monitoring:** Lead status tracking for outreach effectiveness
/// - **Contact History:** Multiple contact methods for reliable outreach
///
/// ### Demographic Analysis
/// - **Age Group Classification:** Automatic age group assignment for ministry planning
/// - **Marital Status:** Relationship status for appropriate ministry approaches
/// - **Geographic Data:** Area information for regional ministry coordination
/// - **Entry Type Analysis:** Understanding how seekers enter the church
///
/// ### Ministry Planning
/// - **New Visitor Ministry:** Special handling for first-time visitors
/// - **Salvation Follow-up:** Immediate follow-up for salvation decisions
/// - **Age-Specific Ministry:** Age group-based ministry placement
/// - **Geographic Ministry:** Area-based ministry coordination
///
/// ## Integration with CongregationKit
///
/// ```swift
/// // Fetch seekers with filtering
/// let seekers = try await congregation.seekers.fetchAll(
///     pageNumber: 1,
///     pageSize: 50,
///     campus: .eastCampus,
///     leadStatus: .attempted
/// )
///
/// // Process seekers for ministry
/// for seeker in seekers.data {
///     if let ageGroup = seeker.ageGroup {
///         switch ageGroup {
///         case "18-25":
///             print("Young adult ministry opportunity")
///         case "26-35":
///             print("Young professional ministry opportunity")
///         default:
///             print("Other age group ministry")
///         }
///     }
/// }
/// ```
///
/// ## Data Validation
///
/// - **Optional Fields:** All fields are optional to handle incomplete data gracefully
/// - **Age Calculation:** Automatic age calculation with birthday consideration
/// - **Age Group Classification:** Intelligent age group assignment
/// - **Lead Validation:** Lead status and ID validation
/// - **Contact Validation:** Multiple contact method support
///
/// ## Performance Considerations
///
/// - **Efficient Age Calculation:** Computed property for age with birthday consideration
/// - **Memory Efficient:** Minimal storage overhead for seeker information
/// - **Concurrency Safe:** All properties are `Sendable` for async operations
/// - **Serialization Ready:** Full `Codable` support for API integration
///
/// ## Best Practices
///
/// ### Seeker Ministry Applications
/// - **Immediate Follow-up:** Use entry type to prioritize follow-up actions
/// - **Age-Appropriate Ministry:** Use age group for ministry placement
/// - **Geographic Coordination:** Use area data for regional ministry planning
/// - **Contact Strategy:** Use multiple contact methods for reliable outreach
///
/// ### Data Entry
/// - **Complete Information:** Provide as much information as possible for effective ministry
/// - **Accurate Dates:** Use correct birth dates for accurate age calculations
/// - **Lead Status Updates:** Keep lead status current for follow-up planning
/// - **Contact Verification:** Verify contact information for reliable outreach
///
/// ## Age Group Classification
///
/// The system automatically classifies seekers into age groups:
/// - **0-17:** Children and youth
/// - **18-25:** Young adults
/// - **26-35:** Young professionals
/// - **36-45:** Middle adults
/// - **46-55:** Mature adults
/// - **56+:** Senior adults
///
/// This classification helps with ministry planning and demographic analysis.
public struct Seeker: SeekerDataRepresentable, Equatable, Sendable, SyncMetadataRepresentable {
    /// The unique identifier for the seeker.
    ///
    /// This is the primary identifier for the seeker in the system,
    /// used for data management and API operations.
    public let id: String?

    /// The lead information for the seeker, if available.
    ///
    /// Contains lead ID and status information for lead management
    /// and follow-up coordination.
    public let lead: Lead?

    /// The seeker's full name, if available.
    ///
    /// Used for personal communication and ministry planning.
    /// May be in local language or English depending on the data source.
    public let fullName: String?

    /// The seeker's email address, if available.
    ///
    /// Primary digital communication method for follow-up,
    /// newsletters, and event invitations.
    public let email: String?

    /// The seeker's phone number, if available.
    ///
    /// Primary phone contact for follow-up calls, SMS messages,
    /// and urgent communications.
    public let phone: String?

    /// The seeker's date of birth, if available.
    ///
    /// Used for age calculation, demographic analysis, and
    /// age-appropriate ministry planning.
    public let dateOfBirth: Date?

    /// The seeker's age group (derived or provided).
    ///
    /// Automatically calculated from date of birth or provided directly.
    /// Used for demographic analysis and ministry placement.
    public let ageGroup: String?

    /// The seeker's area or locality, if available.
    ///
    /// Geographic information used for regional ministry planning,
    /// event coordination, and pastoral visits.
    public let area: String?

    /// The type of entry for the seeker (e.g., Salvation, New Visitor).
    ///
    /// Indicates how the seeker entered the church system, which
    /// determines appropriate follow-up actions and ministry approaches.
    public let typeOfEntry: TypeOfEntry?

    /// The seeker's marital status, if available.
    ///
    /// Used for appropriate ministry approaches and demographic analysis.
    /// Important for family ministry and pastoral care planning.
    public let maritalStatus: MaritalStatus?

    /// The seeker's preferred language, if available.
    ///
    /// Used for appropriate ministry approaches and communication.
    /// Important for language-specific ministry and outreach.
    public let preferredLanguage: PreferredLanguage?

    /// The reason why the seeker was lost, if available.
    ///
    /// Used for tracking why seekers became inactive and
    /// for improving follow-up strategies.
    public let lostReason: LostReason?

    /// The date the seeker was created, if available.
    ///
    /// Used for follow-up timing, lead aging analysis, and
    /// ministry effectiveness tracking.
    public let createdDate: Date?

    /// Last modification time from v2 sync metadata.
    public let lastModifiedDate: Date?

    /// v2 sync metadata (etag, resource name, timestamps).
    public let sync: SyncMetadata?

    /// Raw Salesforce external seeker ID from v2 (`seekerId` / `Seeker_ID__c`).
    /// This is the Salesforce record identifier. The CRM-internal `SKR#####` identifier
    /// is stored separately on the backend as `internalId`.
    public let seekerId: String?

    /// Family name (v2 `familyName`).
    public let familyName: String?

    /// Gender (v2 `gender`).
    public let gender: Gender?

    /// Preferred campus (v2 `preferredCampus`).
    public let preferredCampus: Campus?

    /// Priority (v2 `priority`).
    public let priority: SeekerPriority?

    /// Call status (v2 `callStatus`).
    public let callStatus: CallStatus?

    /// First visited date (v2 `firstVisitedDate`).
    public let firstVisitedDate: Date?

    /// Current address (v2 `currentAddress`).
    public let currentAddress: String?

    /// Comments (v2 `comments`).
    public let comments: String?

    /// Assigned owner staff user ID (v2 `ownerId`).
    public let ownerId: StaffUserID?

    /// Campus label from Salesforce when it is not a legacy `Campus` enum value
    /// (for example `Central - Secunderabad`).
    public let campusLabel: String?

    /// Lead source from Salesforce v2 `leadSource` (`Lead_source__c`).
    public let leadSource: String?

    /// Raw `leadStatus` string from Salesforce before enum parsing (preserves legacy values).
    public let leadStatusRaw: String?

    /// Creates a new Seeker instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the seeker
    ///   - lead: The lead information for the seeker, if available
    ///   - fullName: The seeker's full name, if available
    ///   - email: The seeker's email address, if available
    ///   - phone: The seeker's phone number, if available
    ///   - dateOfBirth: The seeker's date of birth, if available
    ///   - ageGroup: The seeker's age group (derived or provided)
    ///   - area: The seeker's area or locality, if available
    ///   - typeOfEntry: The type of entry for the seeker (e.g., Salvation, New Visitor)
    ///   - maritalStatus: The seeker's marital status, if available
    ///   - preferredLanguage: The seeker's preferred language, if available
    ///   - lostReason: The reason why the seeker was lost, if available
    ///   - createdDate: The date the seeker was created, if available
    public init(
        id: String? = nil,
        lead: Lead? = nil,
        fullName: String? = nil,
        email: String? = nil,
        phone: String? = nil,
        dateOfBirth: Date? = nil,
        ageGroup: String? = nil,
        area: String? = nil,
        typeOfEntry: TypeOfEntry? = nil,
        maritalStatus: MaritalStatus? = nil,
        preferredLanguage: PreferredLanguage? = nil,
        lostReason: LostReason? = nil,
        createdDate: Date? = nil,
        lastModifiedDate: Date? = nil,
        sync: SyncMetadata? = nil,
        seekerId: String? = nil,
        familyName: String? = nil,
        gender: Gender? = nil,
        preferredCampus: Campus? = nil,
        priority: SeekerPriority? = nil,
        callStatus: CallStatus? = nil,
        firstVisitedDate: Date? = nil,
        currentAddress: String? = nil,
        comments: String? = nil,
        ownerId: StaffUserID? = nil,
        campusLabel: String? = nil,
        leadSource: String? = nil,
        leadStatusRaw: String? = nil
    ) {
        self.id = id
        self.lead = lead
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.dateOfBirth = dateOfBirth
        // Compute ageGroup from dateOfBirth if available, otherwise use provided ageGroup
        if let dob = dateOfBirth {
            let calendar = Calendar.current
            let now = Date()
            let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
            if let age = ageComponents.year {
                switch age {
                case 0..<18: self.ageGroup = "0-17"
                case 18..<26: self.ageGroup = "18-25"
                case 26..<36: self.ageGroup = "26-35"
                case 36..<46: self.ageGroup = "36-45"
                case 46..<56: self.ageGroup = "46-55"
                default: self.ageGroup = "56+"
                }
            } else {
                self.ageGroup = ageGroup
            }
        } else {
            self.ageGroup = ageGroup
        }
        self.area = area
        self.typeOfEntry = typeOfEntry
        self.maritalStatus = maritalStatus
        self.preferredLanguage = preferredLanguage
        self.lostReason = lostReason
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate
        self.sync = sync
        self.seekerId = seekerId
        self.familyName = familyName
        self.gender = gender
        self.preferredCampus = preferredCampus
        self.priority = priority
        self.callStatus = callStatus
        self.firstVisitedDate = firstVisitedDate
        self.currentAddress = currentAddress
        self.comments = comments
        self.ownerId = ownerId
        self.campusLabel = campusLabel
        self.leadSource = leadSource
        self.leadStatusRaw = leadStatusRaw
    }

    /// Coding keys for mapping API fields to struct properties.
    ///
    /// These keys handle the mapping between Salesforce API field names
    /// and the struct properties, including fallback options for data consistency.
    enum CodingKeys: String, CodingKey {
        case id
        case seekerId
        case leadId = "leadIdText"
        case leadIdV2 = "leadId"
        case fullName = "fullName"
        case nameLocal = "nameLocal"
        case name
        case familyName
        case email = "email"
        case emailAlt = "emailAlt"
        case phone = "contactNumberMobile"
        case phoneV2 = "phone"
        case dateOfBirth
        case ageGroup = "age"
        case area
        case leadStatus
        case leadSource
        case typeOfEntry
        case maritalStatus
        case preferredLanguage
        case createdDate
        case createTime
        case updateTime
        case lostReason = "lostReason"
        case gender, preferredCampus, campus, priority, callStatus, firstVisitedDate, currentAddress, comments, ownerId
        case etag
    }

    /// The seeker's age, calculated from dateOfBirth if available.
    ///
    /// This computed property provides the current age of the seeker,
    /// taking into account whether they have had their birthday this year.
    /// Returns `nil` if date of birth is not available.
    public var age: Int? {
        guard let dob = dateOfBirth else { return nil }
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
        return ageComponents.year
    }

    /// Equatable conformance for Seeker.
    ///
    /// Two seekers are considered equal if they have the same core identifying
    /// information (id, lead, fullName, email, phone, dateOfBirth, ageGroup, area,
    /// typeOfEntry, maritalStatus, and createdDate).
    public static func == (lhs: Seeker, rhs: Seeker) -> Bool {
        return lhs.id == rhs.id && lhs.lead == rhs.lead && lhs.fullName == rhs.fullName && lhs.email == rhs.email && lhs.phone == rhs.phone
            && lhs.dateOfBirth == rhs.dateOfBirth && lhs.ageGroup == rhs.ageGroup && lhs.area == rhs.area
            && lhs.typeOfEntry == rhs.typeOfEntry && lhs.maritalStatus == rhs.maritalStatus && lhs.createdDate == rhs.createdDate
    }
}

extension Seeker: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Top-level seeker id
        let id = try container.decodeIfPresent(String.self, forKey: .id)
        let seekerId = try container.decodeIfPresent(String.self, forKey: .seekerId)
        // Lead id from v1 leadIdText or v2 leadId
        let leadId =
            try container.decodeIfPresent(String.self, forKey: .leadId)
            ?? container.decodeIfPresent(String.self, forKey: .leadIdV2)
        let leadStatusRaw = try container.decodeIfPresent(String.self, forKey: .leadStatus)
        let leadStatus: LeadStatus? = {
            guard let rawValue = leadStatusRaw else { return nil }
            let parsed = LeadStatus.parse(rawValue)
            if parsed == .unknown, rawValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return nil
            }
            return parsed
        }()
        let leadSource = try container.decodeIfPresent(String.self, forKey: .leadSource)
        let lead: Lead? = {
            if leadId != nil || leadStatus != nil {
                return Lead(id: leadId, status: leadStatus)
            }
            return nil
        }()
        // Prefer v2 name, then nameLocal, then fullName
        let displayName = try container.decodeIfPresent(String.self, forKey: .name)
        let fullName =
            (displayName?.contains("/") == false ? displayName : nil)
            ?? (try? container.decodeIfPresent(String.self, forKey: .nameLocal))
            ?? (try? container.decodeIfPresent(String.self, forKey: .fullName))
        // Prefer emailAlt, fallback to email
        let email =
            (try? container.decodeIfPresent(String.self, forKey: .emailAlt))
            ?? (try? container.decodeIfPresent(String.self, forKey: .email))
        let phone =
            try container.decodeIfPresent(String.self, forKey: .phoneV2)
            ?? container.decodeIfPresent(String.self, forKey: .phone)
        let ageGroup = try container.decodeIfPresent(String.self, forKey: .ageGroup)
        let dateOfBirth = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .dateOfBirth))
        let area = try container.decodeIfPresent(String.self, forKey: .area)

        let typeOfEntry: TypeOfEntry? = {
            if let rawValue = try? container.decodeIfPresent(String.self, forKey: .typeOfEntry),
                let value = TypeOfEntry(rawValue: rawValue)
            {
                return value
            }
            return nil
        }()

        let maritalStatus: MaritalStatus? = {
            if let rawValue = try? container.decodeIfPresent(String.self, forKey: .maritalStatus),
                let value = MaritalStatus(rawValue: rawValue)
            {
                return value
            }
            return nil
        }()

        let createTimeString = try container.decodeIfPresent(String.self, forKey: .createTime)
        let updateTimeString = try container.decodeIfPresent(String.self, forKey: .updateTime)
        let createdDate: Date? = {
            if let parsed = SyncDateCoding.decode(from: createTimeString) { return parsed }
            if let dateString = try? container.decodeIfPresent(String.self, forKey: .createdDate) {
                return SyncDateCoding.decode(from: dateString)
            }
            return nil
        }()
        let lastModifiedDate = SyncDateCoding.decode(from: updateTimeString)
        let sync = SyncMetadata(
            name: displayName?.contains("/") == true ? displayName : nil,
            etag: try container.decodeIfPresent(String.self, forKey: .etag),
            createTime: SyncDateCoding.decode(from: createTimeString),
            updateTime: SyncDateCoding.decode(from: updateTimeString)
        )
        let familyName = try container.decodeIfPresent(String.self, forKey: .familyName)
        let gender = try? container.decodeIfPresent(Gender.self, forKey: .gender)
        let preferredCampus = try? container.decodeIfPresent(Campus.self, forKey: .preferredCampus)
        let campusLabel =
            (try? container.decodeIfPresent(String.self, forKey: .campus))
            ?? (preferredCampus == nil ? (try? container.decodeIfPresent(String.self, forKey: .preferredCampus)) : nil)
        let priority = try? container.decodeIfPresent(SeekerPriority.self, forKey: .priority)
        let callStatus = try? container.decodeIfPresent(CallStatus.self, forKey: .callStatus)
        let firstVisitedDate = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .firstVisitedDate))
        let currentAddress = try container.decodeIfPresent(String.self, forKey: .currentAddress)
        let comments = try container.decodeIfPresent(String.self, forKey: .comments)
        let ownerId = (try container.decodeIfPresent(String.self, forKey: .ownerId)).flatMap(StaffUserID.init(rawValue:))

        let preferredLanguage: PreferredLanguage? = {
            if let rawValue = try? container.decodeIfPresent(String.self, forKey: .preferredLanguage),
                let value = PreferredLanguage(rawValue: rawValue)
            {
                return value
            }
            return nil
        }()

        let lostReason: LostReason? = {
            if let rawValue = try? container.decodeIfPresent(String.self, forKey: .lostReason),
                let value = LostReason(rawValue: rawValue)
            {
                return value
            }
            return nil
        }()

        self.init(
            id: id,
            lead: lead,
            fullName: fullName,
            email: email,
            phone: phone,
            dateOfBirth: dateOfBirth,
            ageGroup: ageGroup,
            area: area,
            typeOfEntry: typeOfEntry,
            maritalStatus: maritalStatus,
            preferredLanguage: preferredLanguage,
            lostReason: lostReason,
            createdDate: createdDate,
            lastModifiedDate: lastModifiedDate,
            sync: sync,
            seekerId: seekerId,
            familyName: familyName,
            gender: gender,
            preferredCampus: preferredCampus,
            priority: priority,
            callStatus: callStatus,
            firstVisitedDate: firstVisitedDate,
            currentAddress: currentAddress,
            comments: comments,
            ownerId: ownerId,
            campusLabel: campusLabel,
            leadSource: leadSource,
            leadStatusRaw: leadStatusRaw
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(lead?.id, forKey: .id)
        try container.encodeIfPresent(leadStatusRaw ?? lead?.status?.rawValue, forKey: .leadStatus)
        try container.encodeIfPresent(leadSource, forKey: .leadSource)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(dateOfBirth, forKey: .dateOfBirth)
        try container.encodeIfPresent(ageGroup, forKey: .ageGroup)
        try container.encodeIfPresent(area, forKey: .area)
        try container.encodeIfPresent(typeOfEntry, forKey: .typeOfEntry)
        try container.encodeIfPresent(maritalStatus, forKey: .maritalStatus)
        try container.encodeIfPresent(preferredLanguage, forKey: .preferredLanguage)
        try container.encodeIfPresent(createdDate, forKey: .createdDate)
        try container.encodeIfPresent(lostReason, forKey: .lostReason)
    }
}

/// Seeker follow-up priority from Salesforce `Lead__c.Priority__c`.
public enum SeekerPriority: String, Codable, Sendable, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

/// Call outcome from Salesforce `Lead__c.Call_Status__c`.
public enum CallStatus: String, Codable, Sendable, CaseIterable {
    case completed = "Completed"
    case notAnswered = "Not Answered"
    case switchedOff = "Switched Off"
    case wrongNumber = "Wrong Number"
    case callLater = "Call Later"
    case numberNotInService = "Number not in service"
    case busy = "Busy"
    case notReachable = "Not reachable"
    case numberDoesNotExist = "Number does not exist"
    case callBack = "Call back"
    case unknown

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        self = CallStatus(rawValue: value) ?? .unknown
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self == .unknown ? "" : rawValue)
    }
}

/// Represents the type of entry for a seeker (e.g., Salvation, New Visitor).
public enum TypeOfEntry: String, Codable, CaseIterable, Sendable {
    /// The seeker is coming back.
    case comingBack = "COMING BACK"
    /// The seeker is a salvation entry.
    case salvation = "SALVATION"
    /// The seeker is a new visitor.
    case newVisitor = "NEW VISITOR"
    /// The seeker is a new visitor with salvation.
    case newVisitorSalvation = "NEW VISITOR SALVATION"
    /// Unknown type of entry.
    case unknown

    /// User-friendly display name for the type of entry.
    public var displayName: String {
        switch self {
        case .comingBack: return "Coming Back"
        case .salvation: return "Salvation"
        case .newVisitor: return "New Visitor"
        case .newVisitorSalvation: return "New Visitor Salvation"
        case .unknown: return "Unknown"
        }
    }

    /// Short display string for the type of entry.
    public var shortDisplay: String {
        switch self {
        case .comingBack: return "Back"
        case .salvation: return "Salvation"
        case .newVisitor: return "Visitor"
        case .newVisitorSalvation: return "Visitor+Salvation"
        case .unknown: return "?"
        }
    }

    /// Creates a new instance from a decoder.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        switch value.uppercased() {
        case "COMING BACK": self = .comingBack
        case "SALVATION": self = .salvation
        case "NEW VISITOR": self = .newVisitor
        case "NEW VISITOR SALVATION": self = .newVisitorSalvation
        case "": self = .unknown
        default: self = .unknown
        }
    }

    /// Encodes this value into the given encoder.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self == .unknown ? "" : rawValue)
    }
}

/// Represents a lead associated with a seeker.
public struct Lead: Codable, Sendable, Equatable {
    /// The unique identifier for the lead.
    public let id: String?
    /// The status of the lead, if available.
    public let status: LeadStatus?

    /// Creates a new Lead instance.
    /// - Parameters:
    ///   - id: The unique identifier for the lead.
    ///   - status: The status of the lead, if available.
    public init(id: String? = nil, status: LeadStatus? = nil) {
        self.id = id
        self.status = status
    }

    /// Coding keys for mapping API fields to struct properties.
    enum CodingKeys: String, CodingKey {
        case id
        case status = "leadStatus"
    }
}

/// Extension to provide seeker-specific validation for MaritalStatus
extension MaritalStatus {
    /// Returns true if this marital status is valid for Salesforce seeker creation.
    ///
    /// Valid values for seekers: Married, Separated, Widowed, Unmarried, Engaged
    ///
    /// **Important:** Do NOT use `.single` for seekers - use `.unmarried` instead.
    /// The `.single` value will cause Salesforce API errors when creating seekers.
    public var isValidForSeeker: Bool {
        switch self {
        case .married, .separated, .widowed, .unmarried, .engaged:
            return true
        case .single, .divorced, .notApplicable, .other:
            return false
        }
    }

    /// Returns a seeker-friendly marital status, converting `.single` to `.unmarried` automatically.
    ///
    /// Use this property when creating seekers to ensure compatibility with Salesforce picklist values.
    ///
    /// **Warning:** Using `.single` directly for seeker creation will fail. Always use this property
    /// or explicitly use `.unmarried` instead of `.single`.
    public var seekerCompatible: MaritalStatus {
        switch self {
        case .single:
            return .unmarried
        default:
            return self
        }
    }
}

/// Represents the status of a lead (e.g., Attempted, Follow-up, Converted).
///
/// Salesforce `Lead__c.Lead_status__c` API names are the raw values. The Path
/// assistant uses picklist **labels** (`Follow-up` displays as `1st Follow up`).
public enum LeadStatus: String, Codable, CaseIterable, Sendable {
    /// The lead was attempted.
    case attempted = "Attempted"
    /// The lead is in first follow-up (`Follow-up` API name, `1st Follow up` label).
    case followUp = "Follow-up"
    /// The lead is in second follow-up.
    case secondFollowUp = "2nd Follow up"
    /// The lead is in third follow-up.
    case thirdFollowUp = "3rd Follow up"
    /// The lead is in fourth follow-up.
    case fourthFollowUp = "4th Follow up"
    /// The lead is lost.
    case lost = "Lost"
    /// The lead is converted.
    case converted = "Converted"
    /// The lead should not be contacted.
    case doNotContact = "Do not contact"
    /// The lead is repeated.
    case repeated = "Repeated"
    /// Unknown lead status.
    case unknown

    /// Active Salesforce Path stages, in picklist order.
    public static let pathOrder: [LeadStatus] = [
        .attempted, .followUp, .secondFollowUp, .thirdFollowUp, .fourthFollowUp,
        .repeated, .lost, .converted,
    ]

    /// Parses Salesforce API names and Path labels (`1st Follow up` → ``followUp``).
    public static func parse(_ raw: String?) -> LeadStatus {
        let value = raw?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        switch value {
        case "Attempted": return .attempted
        case "Follow-up", "Follow up", "1st Follow up", "1st Follow-up": return .followUp
        case "2nd Follow up", "2nd Follow-up": return .secondFollowUp
        case "3rd Follow up", "3rd Follow-up": return .thirdFollowUp
        case "4th Follow up", "4th Follow-up": return .fourthFollowUp
        case "Lost": return .lost
        case "Converted": return .converted
        case "Do not contact", "Do Not Contact": return .doNotContact
        case "Repeated": return .repeated
        case "": return .unknown
        default: return LeadStatus(rawValue: value) ?? .unknown
        }
    }

    /// Salesforce Path / picklist label. Always prefer this over ``rawValue`` in UI.
    public var displayName: String {
        switch self {
        case .attempted: return "Attempted"
        case .followUp: return "1st Follow up"
        case .secondFollowUp: return "2nd Follow up"
        case .thirdFollowUp: return "3rd Follow up"
        case .fourthFollowUp: return "4th Follow up"
        case .lost: return "Lost"
        case .converted: return "Converted"
        case .doNotContact: return "Do not contact"
        case .repeated: return "Repeated"
        case .unknown: return "Unknown"
        }
    }

    /// Whether this status is a Path terminal (`Lost` still has `Converted` after it).
    public var isPathComplete: Bool {
        self == .converted || self == .unknown
    }

    /// Next Path stage after marking the current status complete, if any.
    public var nextOnPath: LeadStatus? {
        guard let index = Self.pathOrder.firstIndex(of: self), index + 1 < Self.pathOrder.count else {
            return nil
        }
        return Self.pathOrder[index + 1]
    }

    /// Salesforce-style Path steps for this current status, with labels always present.
    public static func path(current: LeadStatus?) -> [LeadStatusPathStep] {
        let currentStatus = current ?? .unknown
        let currentIndex = pathOrder.firstIndex(of: currentStatus)
        return pathOrder.map { stage in
            let state: LeadStatusPathStep.State
            if let currentIndex, let stageIndex = pathOrder.firstIndex(of: stage) {
                if stageIndex < currentIndex {
                    state = .completed
                } else if stageIndex == currentIndex {
                    state = .current
                } else {
                    state = .upcoming
                }
            } else if currentStatus == .doNotContact {
                state = .upcoming
            } else {
                state = .upcoming
            }
            return LeadStatusPathStep(status: stage, state: state)
        }
    }

    /// Short display string for the lead status.
    public var shortDisplay: String {
        switch self {
        case .attempted: return "Attempted"
        case .followUp: return "Follow-up"
        case .secondFollowUp: return "2nd FU"
        case .thirdFollowUp: return "3rd FU"
        case .fourthFollowUp: return "4th FU"
        case .lost: return "Lost"
        case .converted: return "Converted"
        case .doNotContact: return "DNC"
        case .repeated: return "Repeated"
        case .unknown: return "?"
        }
    }

    /// Creates a new instance from a decoder.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = LeadStatus.parse(try container.decode(String.self))
    }

    /// Encodes this value into the given encoder.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self == .unknown ? "" : rawValue)
    }
}

/// Represents the reason why a lead was lost.
public enum LostReason: String, Codable, CaseIterable, Sendable {
    /// The seeker was only interested in events.
    case onlyForEvents = "Only for events"
    /// The seeker came only once.
    case cameOnlyOnce = "Came only once"
    /// The seeker committed to another church.
    case committedToOtherChurch = "Committed to Other Church"
    /// The seeker should not be contacted.
    case doNotContact = "Do Not Contact"
    /// The seeker's phone number is wrong.
    case wrongNumber = "Wrong Number"
    /// The seeker doesn't receive incoming calls.
    case noIncomingCalls = "No Incoming Calls"
    /// The seeker has relocated.
    case relocated = "Relocated"
    /// Unknown lost reason.
    case unknown

    /// User-friendly display name for the lost reason.
    public var displayName: String {
        switch self {
        case .onlyForEvents: return "Only for events"
        case .cameOnlyOnce: return "Came only once"
        case .committedToOtherChurch: return "Committed to Other Church"
        case .doNotContact: return "Do Not Contact"
        case .wrongNumber: return "Wrong Number"
        case .noIncomingCalls: return "No Incoming Calls"
        case .relocated: return "Relocated"
        case .unknown: return "Unknown"
        }
    }

    /// Creates a new instance from a decoder.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        switch value {
        case "Only for events": self = .onlyForEvents
        case "Came only once": self = .cameOnlyOnce
        case "Committed to Other Church": self = .committedToOtherChurch
        case "Do Not Contact": self = .doNotContact
        case "Wrong Number": self = .wrongNumber
        case "No Incoming Calls": self = .noIncomingCalls
        case "Relocated": self = .relocated
        case "": self = .unknown
        default: self = .unknown
        }
    }

    /// Encodes this value into the given encoder.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self == .unknown ? "" : rawValue)
    }
}
