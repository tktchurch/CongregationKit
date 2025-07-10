import Foundation

/// A type representing a member's marital information, including status, anniversary, spouse, and children count.
///
/// - Note: This struct is modular and conforms to `MaritalInformationRepresentable` for type-safe access in the member model.
public struct MaritalInformation: Codable, Equatable, Sendable {
    /// The member's marital status (e.g., Married, Single, Widowed, etc.)
    public let maritalStatus: MaritalStatus?
    /// The member's spouse's name, if available.
    public let spouseName: String?
    /// The number of children the member has, if available.
    public let numberOfChildren: Int?

    /// Creates a new MaritalInformation instance.
    /// - Parameters:
    ///   - maritalStatus: The member's marital status.
    ///   - weddingAnniversary: The member's wedding anniversary date.
    ///   - spouseName: The member's spouse's name.
    ///   - numberOfChildren: The number of children the member has.
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
        case maritalStatus = "martialStatus"
        case weddingAnniversary = "weddingAnniversaryDdMmYyyy"
        case spouseName
        case numberOfChildren
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.maritalStatus = try container.decodeIfPresent(MaritalStatus.self, forKey: .maritalStatus)
        // Parse date from yyyy-MM-dd or ddMMyyyy string if present
        if let dateString = try container.decodeIfPresent(String.self, forKey: .weddingAnniversary) {
            let isoFormatter = DateFormatter()
            isoFormatter.dateFormat = "yyyy-MM-dd"
            isoFormatter.locale = Locale(identifier: "en_US_POSIX")
            isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            if let date = isoFormatter.date(from: dateString) {
                self._weddingAnniversary = date
            } else {
                self._weddingAnniversary = MaritalInformation.dateFormatter.date(from: dateString)
            }
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

    /// Struct representing detailed wedding anniversary information.
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
        /// Anniversary date in "day/month" format (e.g., "9/10" for October 9th).
        public var shortFormat: String {
            return "\(day)/\(month)"
        }
        /// Number of years of marriage until now.
        public var yearsOfMarriage: Int {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year], from: date, to: now)
            return components.year ?? 0
        }
        /// Anniversary date in "month/day" format (e.g., "10/9" for October 9th).
        public var usFormat: String {
            return "\(month)/\(day)"
        }
        /// Full anniversary date in "day/month/year" format (e.g., "9/10/2013").
        public var fullFormat: String {
            return "\(day)/\(month)/\(year)"
        }
        /// Whether the anniversary is this year.
        public var isThisYear: Bool {
            let calendar = Calendar.current
            let now = Date()
            let anniversaryThisYear = calendar.date(bySetting: .year, value: calendar.component(.year, from: now), of: date)
            return anniversaryThisYear == date
        }
        /// Days until next anniversary.
        public var daysUntilNextAnniversary: Int {
            let calendar = Calendar.current
            let now = Date()
            let currentYear = calendar.component(.year, from: now)
            
            // Try this year's anniversary
            if let anniversaryThisYear = calendar.date(bySetting: .year, value: currentYear, of: date) {
                if anniversaryThisYear > now {
                    return calendar.dateComponents([.day], from: now, to: anniversaryThisYear).day ?? 0
                }
            }
            
            // Try next year's anniversary
            if let anniversaryNextYear = calendar.date(bySetting: .year, value: currentYear + 1, of: date) {
                return calendar.dateComponents([.day], from: now, to: anniversaryNextYear).day ?? 0
            }
            
            return 0
        }
        
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
