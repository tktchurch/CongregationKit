import Foundation
/**
 A type representing a member's marital information, including status, anniversary, spouse, and children count.

 - Note: This struct is modular and conforms to `MaritalInformationRepresentable` for type-safe access in the member model.
 */
public struct MaritalInformation: Codable, Equatable, Sendable {
    /// The member's marital status (e.g., Married, Single, Widowed, etc.)
    public let maritalStatus: MaritalStatus?
    /// The member's spouse's name, if available.
    public let spouseName: String?
    /// The number of children the member has, if available.
    public let numberOfChildren: Int?

    /**
     Creates a new MaritalInformation instance.
     - Parameters:
        - maritalStatus: The member's marital status.
        - weddingAnniversary: The member's wedding anniversary date.
        - spouseName: The member's spouse's name.
        - numberOfChildren: The number of children the member has.
     */
    public init(
        maritalStatus: MaritalStatus? = nil,
        weddingAnniversary: Date? = nil,
        spouseName: String? = nil,
        numberOfChildren: Int? = nil
    ) {
        self.maritalStatus = maritalStatus
        self._weddingAnniversary = weddingAnniversary
        self.spouseName = spouseName
        self.numberOfChildren = numberOfChildren
    }

    enum CodingKeys: String, CodingKey {
        case maritalStatus
        case weddingAnniversary = "weddingAnniversaryDdMmYyyy"
        case spouseName
        case numberOfChildren
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.maritalStatus = try container.decodeIfPresent(MaritalStatus.self, forKey: .maritalStatus)
        // Parse date from ddMMyyyy string if present
        if let dateString = try container.decodeIfPresent(String.self, forKey: .weddingAnniversary) {
            self._weddingAnniversary = MaritalInformation.dateFormatter.date(from: dateString)
        } else {
            self._weddingAnniversary = nil
        }
        self.spouseName = try container.decodeIfPresent(String.self, forKey: .spouseName)
        self.numberOfChildren = try container.decodeIfPresent(Int.self, forKey: .numberOfChildren)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(maritalStatus, forKey: .maritalStatus)
        if let date = _weddingAnniversary {
            let dateString = MaritalInformation.dateFormatter.string(from: date)
            try container.encode(dateString, forKey: .weddingAnniversary)
        }
        try container.encodeIfPresent(spouseName, forKey: .spouseName)
        try container.encodeIfPresent(numberOfChildren, forKey: .numberOfChildren)
    }

    /// DateFormatter for ddMMyyyy format
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    /**
     Struct representing detailed wedding anniversary information.
     */
    public struct WeddingAnniversaryInfo: Codable, Equatable, Sendable {
        /// The original anniversary date.
        public let date: Date
        /// The year component.
        public let year: Int
        /// The month component.
        public let month: Int
        /// The day component.
        public let day: Int
        /// The day of the week (1 = Sunday, 7 = Saturday).
        public let dayOfWeek: Int
        public init(date: Date) {
            self.date = date
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
            self.year = components.year ?? 0
            self.month = components.month ?? 0
            self.day = components.day ?? 0
            self.dayOfWeek = components.weekday ?? 0
        }
    }
    /// Returns detailed wedding anniversary info if available.
    public var weddingAnniversaryInfo: WeddingAnniversaryInfo? {
        guard let date = self._weddingAnniversary else { return nil }
        return WeddingAnniversaryInfo(date: date)
    }

    // Internal storage for the wedding anniversary date
    private let _weddingAnniversary: Date?
}

/// Enum for marital status values, extensible for future API changes.
public enum MaritalStatus: String, Codable, CaseIterable, Sendable {
    case single = "Single"
    case married = "Married"
    case widowed = "Widowed"
    case divorced = "Divorced"
    case separated = "Separated"
    case other

    /// User-friendly display name
    public var displayName: String {
        switch self {
        case .single: return "Single"
        case .married: return "Married"
        case .widowed: return "Widowed"
        case .divorced: return "Divorced"
        case .separated: return "Separated"
        case .other: return "Other"
        }
    }
}

// Conformance to MaritalInformationRepresentable
extension MaritalInformation: MaritalInformationRepresentable {
    public var weddingAnniversary: WeddingAnniversaryInfo? { weddingAnniversaryInfo }
} 