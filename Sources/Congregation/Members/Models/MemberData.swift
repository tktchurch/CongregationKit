import Foundation

/// Represents the title of a member (e.g., Dr, Mr, Mrs, etc.) as defined in Salesforce.
public enum MemberTitle: String, Codable, CaseIterable, Sendable {
    case dr = "Dr. (Doctor)"
    case mr = "Mr."
    case mrs = "Mrs."
    case ms = "Ms."
    case prof = "Prof. (Professor)"
    case rev = "Rev. (Reverend)"
    case ps = "Ps. (Pastor)"

    /// A user-friendly display name for the title.
    public var displayName: String {
        switch self {
        case .dr: return "Dr. (Doctor)"
        case .mr: return "Mr."
        case .mrs: return "Mrs."
        case .ms: return "Ms."
        case .prof: return "Prof. (Professor)"
        case .rev: return "Rev. (Reverend)"
        case .ps: return "Ps. (Pastor)"
        }
    }

    /// Returns a short display format (e.g., Dr, Mr, Mrs, etc.)
    public var shortDisplay: String {
        switch self {
        case .dr: return "Dr"
        case .mr: return "Mr"
        case .mrs: return "Mrs"
        case .ms: return "Ms"
        case .prof: return "Prof"
        case .rev: return "Rev"
        case .ps: return "Ps"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        switch value {
        case "Dr. (Doctor)": self = .dr
        case "Mr.": self = .mr
        case "Mrs.": self = .mrs
        case "Ms.": self = .ms
        case "Prof. (Professor)": self = .prof
        case "Rev. (Reverend)": self = .rev
        case "Ps. (Pastor)": self = .ps
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown MemberTitle value: \(value)")
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

/// Represents the type of a member (e.g., TKT, EFAM, SPM, etc.) as defined in Salesforce.
public enum MemberType: String, Codable, CaseIterable, Sendable {
    case tkt = "TKT"
    case efam = "EFAM"
    case spm = "SPM"
    case iocVillages = "IOC (Villages)"
    case conferenceEventsOnly = "Conference & Events only"
    case tktTeenXYouth = "TKT TeenXYouth"
    case kingsKid = "Kings Kid"
    case uae = "UAE"

    /// A user-friendly display name for the member type.
    public var displayName: String { self.rawValue }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        switch value {
        case "TKT": self = .tkt
        case "EFAM": self = .efam
        case "SPM": self = .spm
        case "IOC (Villages)": self = .iocVillages
        case "Conference & Events only": self = .conferenceEventsOnly
        case "TKT TeenXYouth": self = .tktTeenXYouth
        case "Kings Kid": self = .kingsKid
        case "UAE": self = .uae
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown MemberType value: \(value)")
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

/// Represents the blood group of a member as defined in Salesforce.
public enum BloodGroup: String, Codable, CaseIterable, Sendable {
    case a = "A"
    case aPositive = "A Positive"
    case aNegative = "A Negative"
    case b = "B"
    case bPositive = "B Positive"
    case bNegative = "B Negative"
    case o = "O"
    case oPositive = "O Positive"
    case oNegative = "O Negative"
    case ab = "AB"
    case abPositive = "AB Positive"
    case abNegative = "AB Negative"
    case notSure = "Not sure"

    /// A user-friendly display name for the blood group.
    public var displayName: String { self.rawValue }

    /// Returns the short display format (e.g., O+, AB-, etc.)
    public var shortDisplay: String {
        switch self {
        case .a: return "A"
        case .aPositive: return "A+"
        case .aNegative: return "A-"
        case .b: return "B"
        case .bPositive: return "B+"
        case .bNegative: return "B-"
        case .o: return "O"
        case .oPositive: return "O+"
        case .oNegative: return "O-"
        case .ab: return "AB"
        case .abPositive: return "AB+"
        case .abNegative: return "AB-"
        case .notSure: return "Not sure"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        switch value {
        case "A": self = .a
        case "A Positive": self = .aPositive
        case "A Negative": self = .aNegative
        case "B": self = .b
        case "B Positive": self = .bPositive
        case "B Negative": self = .bNegative
        case "O": self = .o
        case "O Positive": self = .oPositive
        case "O Negative": self = .oNegative
        case "AB": self = .ab
        case "AB Positive": self = .abPositive
        case "AB Negative": self = .abNegative
        case "Not sure": self = .notSure
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown BloodGroup value: \(value)")
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

/// Represents the preferred language(s) of a member as defined in Salesforce.
public enum PreferredLanguage: String, Codable, CaseIterable, Sendable {
    case english = "English"
    case telugu = "Telugu"
    case hindi = "Hindi"

    /// A user-friendly display name for the language.
    public var displayName: String { self.rawValue }

    /// Returns a short display format (e.g., EN, TE, HI)
    public var shortDisplay: String {
        switch self {
        case .english: return "EN"
        case .telugu: return "TE"
        case .hindi: return "HI"
        }
    }

    /// Returns the international (ISO 639-1) code for the language
    public var internationalFormat: String {
        switch self {
        case .english: return "en"
        case .telugu: return "te"
        case .hindi: return "hi"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        switch value {
        case "English": self = .english
        case "Telugu": self = .telugu
        case "Hindi": self = .hindi
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown PreferredLanguage value: \(value)")
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

/// Represents the campus a member is attending as defined in Salesforce.
public enum AttendingCampus: String, Codable, CaseIterable, Sendable {
    case eastLBNagar = "East - LB Nagar"
    case westKukatpally = "West -Kukatpally"
    case westHiTechCity = "West - HiTech City"
    case centralSecunderabad = "Central - Secunderabad"

    /// A user-friendly display name for the campus.
    public var displayName: String {
        switch self {
        case .westKukatpally:
            return "West - Kukatpally"
        default:
            return self.rawValue
        }
    }

    /// Custom decoding to normalize input values from API.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value.trimmingCharacters(in: .whitespacesAndNewlines) {
        case "West -Kukatpally", "West - Kukatpally":
            self = .westKukatpally
        case "East - LB Nagar":
            self = .eastLBNagar
        case "West - HiTech City":
            self = .westHiTechCity
        case "Central - Secunderabad":
            self = .centralSecunderabad
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown AttendingCampus value: \(value)")
        }
    }

    /// Custom encoding to use the normalized value.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

/// Represents the status of a member (e.g., Regular, Inactive) as defined in Salesforce.
public enum MemberStatus: String, Codable, CaseIterable, Sendable {
    case regular = "Regular"
    case irregular = "Irregular"
    case relocated = "Relocated"
    case longTimeAbsentee = "Long Time Absentee"
    case doNotCall = "Do not call"
    case leftTheChurch = "Left the church"
    case promotedToGlory = "Promoted to Glory"
    case active = "Active"
    case doNotContact = "Do not contact"
    case inActive = "InActive"
    case inactiveDNC = "Inactive (DNC)"

    /// A user-friendly display name for the member status.
    public var displayName: String { self.rawValue }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        switch value {
        case "Regular": self = .regular
        case "Irregular": self = .irregular
        case "Relocated": self = .relocated
        case "Long Time Absentee": self = .longTimeAbsentee
        case "Do not call": self = .doNotCall
        case "Left the church": self = .leftTheChurch
        case "Promoted to Glory": self = .promotedToGlory
        case "Active": self = .active
        case "Do not contact": self = .doNotContact
        case "InActive": self = .inActive
        case "Inactive (DNC)": self = .inactiveDNC
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown MemberStatus value: \(value)")
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

/// Represents the campus a member is associated with as defined in Salesforce.
public enum Campus: String, Codable, CaseIterable, Sendable {
    case eastCampus = "East Campus"
    case westCampus = "West Campus"
    case campusOne = "Campus One"
    case campusTwo = "Campus Two"
    case campusThree = "Campus Three"
    case campusFour = "Campus Four"
    case teenXYouth = "Teen X Youth"
    case hiTechCity = "Hitech City"

    /// A user-friendly display name for the campus.
    public var displayName: String { self.rawValue }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        // Normalize inputs by converting to lowercase and removing all spaces
        let normalizedValue = value.lowercased().replacingOccurrences(of: " ", with: "")
        switch normalizedValue {
        case "eastcampus":
            self = .eastCampus
        case "westcampus":
            self = .westCampus
        case "campusone":
            self = .campusOne
        case "campustwo":
            self = .campusTwo
        case "campusthree":
            self = .campusThree
        case "campusfour":
            self = .campusFour
        case "teenxyouth":
            self = .teenXYouth
        case "hitechcity":
            self = .hiTechCity
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown Campus value: \(value)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

/// Represents the service a member is attending as defined in Salesforce.
public enum AttendingService: String, Codable, CaseIterable, Sendable {
    case online = "Online"
    case firstService = "1st Service"
    case secondService = "2nd Service"
    case fridayNightService = "Friday Night Service"
    case sundayEveningService = "Sunday evening service"
    case fridaySundayFirstService = "Friday & Sunday 1st service"
    case fridaySundaySecondService = "Friday & Sunday 2nd service"
    case fridaySundayEvening = "Friday & Sunday evening"
    case fridayWestCampus = "Friday & West Campus"
    case onlyConferencesEvent = "Only conferences/event"
    case westSunService = "West Sun Service"
    case allServicesCentral = "All Services - Central"

    /// A user-friendly display name for the service.
    public var displayName: String {
        switch self {
        case .sundayEveningService:
            return "Sunday Evening Service"
        default:
            return self.rawValue
        }
    }

    /// Returns a short display format for the service (e.g., Online, 1st, 2nd, Fri Night, etc.)
    public var shortDisplay: String {
        switch self {
        case .online: return "Online"
        case .firstService: return "1st"
        case .secondService: return "2nd"
        case .fridayNightService: return "Fri Night"
        case .sundayEveningService: return "Sun Eve"
        case .fridaySundayFirstService: return "Fri+Sun 1st"
        case .fridaySundaySecondService: return "Fri+Sun 2nd"
        case .fridaySundayEvening: return "Fri+Sun Eve"
        case .fridayWestCampus: return "Fri+West"
        case .onlyConferencesEvent: return "Conf/Event"
        case .westSunService: return "West Sun"
        case .allServicesCentral: return "All Central"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        switch value {
        case "Online": self = .online
        case "1st Service": self = .firstService
        case "2nd Service": self = .secondService
        case "Friday Night Service": self = .fridayNightService
        case "Sunday evening service", "Sunday Evening Service": self = .sundayEveningService
        case "Friday & Sunday 1st service": self = .fridaySundayFirstService
        case "Friday & Sunday 2nd service": self = .fridaySundaySecondService
        case "Friday & Sunday evening": self = .fridaySundayEvening
        case "Friday & West Campus": self = .fridayWestCampus
        case "Only conferences/event": self = .onlyConferencesEvent
        case "West Sun Service": self = .westSunService
        case "All Services - Central": self = .allServicesCentral
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown AttendingService value: \(value)")
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

/// Main struct for member data, representing all Salesforce member fields in a type-safe way.
public struct MemberData: MemberDataRepresentable {
    /// The member's date of birth, if available.
    public let dateOfBirth: Date?
    /// The member's title (e.g., Mr, Mrs, Dr), if available.
    public let title: MemberTitle?
    /// The member's type (e.g., TKT, EFAM), if available.
    public let memberType: MemberType?
    /// The member's blood group, if available.
    public let bloodGroup: BloodGroup?
    /// The member's preferred languages, if available.
    public let preferredLanguages: [PreferredLanguage]?
    /// The campus the member is attending, if available.
    public let attendingCampus: AttendingCampus?
    /// Whether the member is part of a life group.
    public let partOfLifeGroup: Bool?
    /// The member's status (e.g., Regular, Inactive), if available.
    public let status: MemberStatus?
    /// The campus the member is associated with, if available.
    public let campus: Campus?
    /// Whether the member is part of SPM.
    public let spm: Bool?
    /// The service the member is attending, if available.
    public let attendingService: AttendingService?

    public init(
        dateOfBirth: Date? = nil,
        title: MemberTitle? = nil,
        memberType: MemberType? = nil,
        bloodGroup: BloodGroup? = nil,
        preferredLanguages: [PreferredLanguage]? = nil,
        attendingCampus: AttendingCampus? = nil,
        partOfLifeGroup: Bool? = nil,
        status: MemberStatus? = nil,
        campus: Campus? = nil,
        spm: Bool? = nil,
        attendingService: AttendingService? = nil
    ) {
        self.dateOfBirth = dateOfBirth
        self.title = title
        self.memberType = memberType
        self.bloodGroup = bloodGroup
        self.preferredLanguages = preferredLanguages
        self.attendingCampus = attendingCampus
        self.partOfLifeGroup = partOfLifeGroup
        self.status = status
        self.campus = campus
        self.spm = spm
        self.attendingService = attendingService
    }
}
