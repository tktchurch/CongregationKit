import Foundation

/// Represents a church seeker from Salesforce
public struct Seeker: SeekerDataRepresentable, Equatable, Sendable {
    /// The unique identifier for the seeker.
    public let id: String?
    /// The lead information for the seeker, if available.
    public let lead: Lead?
    /// The seeker's full name, if available.
    public let fullName: String?
    /// The seeker's email address, if available.
    public let email: String?
    /// The seeker's phone number, if available.
    public let phone: String?
    /// The seeker's date of birth, if available.
    public let dateOfBirth: Date?
    /// The seeker's age group (derived or provided).
    public let ageGroup: String?
    /// The seeker's area or locality, if available.
    public let area: String?
    /// The type of entry for the seeker (e.g., Salvation, New Visitor).
    public let typeOfEntry: TypeOfEntry?
    /// The seeker's marital status, if available.
    public let maritalStatus: MaritalStatus?
    /// The date the seeker was created, if available.
    public let createdDate: Date?

    /// Creates a new Seeker instance.
    /// - Parameters:
    ///   - id: The unique identifier for the seeker.
    ///   - lead: The lead information for the seeker, if available.
    ///   - fullName: The seeker's full name, if available.
    ///   - email: The seeker's email address, if available.
    ///   - phone: The seeker's phone number, if available.
    ///   - dateOfBirth: The seeker's date of birth, if available.
    ///   - ageGroup: The seeker's age group (derived or provided).
    ///   - area: The seeker's area or locality, if available.
    ///   - typeOfEntry: The type of entry for the seeker (e.g., Salvation, New Visitor).
    ///   - maritalStatus: The seeker's marital status, if available.
    ///   - createdDate: The date the seeker was created, if available.
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
    public var age: Int? {
        guard let dob = dateOfBirth else { return nil }
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
        return ageComponents.year
    }

    /// Equatable conformance for Seeker.
    public static func == (lhs: Seeker, rhs: Seeker) -> Bool {
        return lhs.id == rhs.id && lhs.lead == rhs.lead && lhs.fullName == rhs.fullName && lhs.email == rhs.email && lhs.phone == rhs.phone
            && lhs.dateOfBirth == rhs.dateOfBirth && lhs.ageGroup == rhs.ageGroup && lhs.area == rhs.area
            && lhs.typeOfEntry == rhs.typeOfEntry && lhs.maritalStatus == rhs.maritalStatus && lhs.createdDate == rhs.createdDate
    }
}

extension Seeker: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let lead: Lead? = {
            let id = try? container.decodeIfPresent(String.self, forKey: .id)
            let status: LeadStatus? = {
                if let rawValue = try? container.decodeIfPresent(String.self, forKey: .leadStatus),
                    let value = LeadStatus(rawValue: rawValue)
                {
                    return value
                }
                return nil
            }()
            if id != nil || status != nil {
                return Lead(id: id, status: status)
            }
            return nil
        }()

        let id = try container.decodeIfPresent(String.self, forKey: .id)
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
