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
public struct Seeker: SeekerDataRepresentable, Equatable, Sendable {
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

    /// The date the seeker was created, if available.
    ///
    /// Used for follow-up timing, lead aging analysis, and
    /// ministry effectiveness tracking.
    public let createdDate: Date?

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
        createdDate: Date? = nil
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
        self.createdDate = createdDate
    }

    /// Coding keys for mapping API fields to struct properties.
    ///
    /// These keys handle the mapping between Salesforce API field names
    /// and the struct properties, including fallback options for data consistency.
    enum CodingKeys: String, CodingKey {
        case id
        case leadId = "leadIdText"
        case fullName = "fullName"
        case nameLocal = "nameLocal"
        case email = "email"
        case emailAlt = "emailAlt"
        case phone = "contactNumberMobile"
        case dateOfBirth
        case ageGroup = "age"
        case area
        case leadStatus
        case typeOfEntry
        case maritalStatus
        case createdDate
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
        // Lead id from leadIdText
        let leadId = try container.decodeIfPresent(String.self, forKey: .leadId)
        let leadStatus: LeadStatus? = {
            if let rawValue = try? container.decodeIfPresent(String.self, forKey: .leadStatus),
                let value = LeadStatus(rawValue: rawValue)
            {
                return value
            }
            return nil
        }()
        let lead: Lead? = {
            if leadId != nil || leadStatus != nil {
                return Lead(id: leadId, status: leadStatus)
            }
            return nil
        }()
        // Prefer nameLocal, fallback to fullName
        let fullName =
            (try? container.decodeIfPresent(String.self, forKey: .nameLocal))
            ?? (try? container.decodeIfPresent(String.self, forKey: .fullName))
        // Prefer emailAlt, fallback to email
        let email =
            (try? container.decodeIfPresent(String.self, forKey: .emailAlt))
            ?? (try? container.decodeIfPresent(String.self, forKey: .email))
        let phone = try container.decodeIfPresent(String.self, forKey: .phone)
        let ageGroup = try container.decodeIfPresent(String.self, forKey: .ageGroup)
        let dateOfBirth: Date? = {
            if let dateString = try? container.decodeIfPresent(String.self, forKey: .dateOfBirth) {
                let formatter = ISO8601DateFormatter()
                return formatter.date(from: dateString)
            }
            return nil
        }()
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

        let createdDate: Date? = {
            if let dateString = try? container.decodeIfPresent(String.self, forKey: .createdDate) {
                let formatter = ISO8601DateFormatter()
                return formatter.date(from: dateString)
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
            createdDate: createdDate
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(lead?.id, forKey: .id)
        try container.encodeIfPresent(lead?.status, forKey: .leadStatus)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(dateOfBirth, forKey: .dateOfBirth)
        try container.encodeIfPresent(ageGroup, forKey: .ageGroup)
        try container.encodeIfPresent(area, forKey: .area)
        try container.encodeIfPresent(typeOfEntry, forKey: .typeOfEntry)
        try container.encodeIfPresent(maritalStatus, forKey: .maritalStatus)
        try container.encodeIfPresent(createdDate, forKey: .createdDate)
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

/// Represents the status of a lead (e.g., Attempted, Follow-up, Converted).
public enum LeadStatus: String, Codable, CaseIterable, Sendable {
    /// The lead was attempted.
    case attempted = "Attempted"
    /// The lead is in follow-up.
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
    /// Unknown lead status.
    case unknown

    /// User-friendly display name for the lead status.
    public var displayName: String {
        switch self {
        case .attempted: return "Attempted"
        case .followUp: return "Follow-up"
        case .secondFollowUp: return "2nd Follow up"
        case .thirdFollowUp: return "3rd Follow up"
        case .fourthFollowUp: return "4th Follow up"
        case .lost: return "Lost"
        case .converted: return "Converted"
        case .doNotContact: return "Do not contact"
        case .unknown: return "Unknown"
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
        case .unknown: return "?"
        }
    }

    /// Creates a new instance from a decoder.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        switch value {
        case "Attempted": self = .attempted
        case "Follow-up": self = .followUp
        case "2nd Follow up": self = .secondFollowUp
        case "3rd Follow up": self = .thirdFollowUp
        case "4th Follow up": self = .fourthFollowUp
        case "Lost": self = .lost
        case "Converted": self = .converted
        case "Do not contact": self = .doNotContact
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
