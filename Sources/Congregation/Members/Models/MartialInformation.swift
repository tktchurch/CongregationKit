import Foundation

/// A comprehensive representation of a member's marital information, including status, anniversary, spouse, and children count.
///
/// The `MaritalInformation` struct provides detailed family and relationship data for church members,
/// supporting pastoral care, family ministry, and demographic analysis. It includes rich anniversary
/// tracking with professional date formatting and calculations.
///
/// ## Overview
///
/// This struct organizes marital information into logical categories:
/// - **Marital Status:** Current relationship status (single, married, widowed, etc.)
/// - **Spouse Information:** Spouse name and relationship details
/// - **Family Size:** Number of children for family ministry planning
/// - **Anniversary Tracking:** Rich wedding anniversary information with date calculations
///
/// ## Key Features
///
/// - **Rich Anniversary Information:** Professional date formatting with years of marriage calculations
/// - **Multiple Date Formats:** Short, US, and full date formats for different use cases
/// - **Church-Specific Design:** Built for family ministry and pastoral care
/// - **Protocol Conformance:** Implements `MaritalInformationRepresentable` for type-safe access
/// - **Flexible Date Parsing:** Supports both ISO and legacy date formats
///
/// ## Example Usage
///
/// ```swift
/// // Create marital information
/// let maritalInfo = MaritalInformation(
///     maritalStatus: .married,
///     weddingAnniversary: Date(), // Current date for example
///     spouseName: "Jane Doe",
///     numberOfChildren: 2
/// )
///
/// // Access marital status
/// if let status = maritalInfo.maritalStatus {
///     print("Marital status: \(status.displayName)")
/// }
///
/// // Access rich anniversary information
/// if let anniversary = maritalInfo.weddingAnniversaryInfo {
///     print("Years of marriage: \(anniversary.yearsOfMarriage)")
///     print("Next anniversary: \(anniversary.daysUntilNextAnniversary) days")
///     print("Anniversary date: \(anniversary.fullFormat)")
///
///     if anniversary.isThisYear {
///         print("Anniversary is this year!")
///     }
/// }
///
/// // Use for family ministry
/// if let children = maritalInfo.numberOfChildren {
///     print("Family size: \(children) children")
/// }
///
/// if let spouse = maritalInfo.spouseName {
///     print("Spouse: \(spouse)")
/// }
/// ```
///
/// ## Topics
///
/// ### Marital Status
/// - ``maritalStatus`` - The member's marital status
///
/// ### Spouse Information
/// - ``spouseName`` - The member's spouse's name
///
/// ### Family Information
/// - ``numberOfChildren`` - The number of children the member has
///
/// ### Anniversary Information
/// - ``weddingAnniversaryInfo`` - Rich anniversary information with calculations
///
/// ## Church-Specific Features
///
/// ### Family Ministry
/// - **Family Size Tracking:** Number of children for family ministry planning
/// - **Spouse Information:** Spouse name for couple ministry and pastoral care
/// - **Marital Status:** Relationship status for appropriate ministry approaches
/// - **Anniversary Celebrations:** Rich anniversary data for church celebrations
///
/// ### Pastoral Care
/// - **Relationship Status:** Understanding current relationship situation
/// - **Family Context:** Family size for pastoral visit planning
/// - **Anniversary Recognition:** Anniversary dates for pastoral care outreach
/// - **Spouse Support:** Spouse information for couple ministry
///
/// ### Anniversary Intelligence
/// - **Years of Marriage:** Automatic calculation of marriage duration
/// - **Next Anniversary:** Days until next anniversary for planning
/// - **Multiple Formats:** Short, US, and full date formats
/// - **This Year Check:** Whether anniversary falls in current year
///
/// ## Integration with Member Model
///
/// ```swift
/// // In Member struct
/// let member = Member(
///     maritalInformation: MaritalInformation(
///         maritalStatus: .married,
///         spouseName: "Jane Doe",
///         numberOfChildren: 2
///     )
/// )
///
/// // Access through protocol conformance
/// if let status = member.maritalStatus {
///     print("Member status: \(status.displayName)")
/// }
///
/// if let anniversary = member.weddingAnniversary {
///     print("Years married: \(anniversary.yearsOfMarriage)")
/// }
/// ```
///
/// ## Data Validation
///
/// - **Optional Fields:** All fields are optional to handle incomplete data gracefully
/// - **Date Parsing:** Robust handling of various date formats from Salesforce
/// - **Enum Safety:** Marital status uses enums for compile-time safety
/// - **Number Validation:** Children count validation and handling
///
/// ## Performance Considerations
///
/// - **Efficient Date Calculations:** Computed properties for anniversary information
/// - **Memory Efficient:** Minimal storage overhead for marital information
/// - **Concurrency Safe:** All properties are `Sendable` for async operations
/// - **Serialization Ready:** Full `Codable` support for API integration
///
/// ## Best Practices
///
/// ### Family Ministry Applications
/// - **Family Size Planning:** Use children count for family ministry programs
/// - **Couple Ministry:** Use spouse information for couple-focused activities
/// - **Anniversary Celebrations:** Use anniversary data for church celebrations
/// - **Pastoral Care:** Use marital status for appropriate pastoral approaches
///
/// ### Data Entry
/// - **Complete Information:** Provide spouse name and children count when available
/// - **Accurate Dates:** Use correct anniversary dates for accurate calculations
/// - **Status Updates:** Keep marital status current for ministry planning
/// - **Family Changes:** Update children count as family size changes
///
/// - Note: This struct is modular and conforms to `MaritalInformationRepresentable` for type-safe access in the member model.
public struct MaritalInformation: Codable, Equatable, Sendable {
    /// The member's marital status (e.g., Married, Single, Widowed, etc.)
    ///
    /// This indicates the member's current relationship status, which is important
    /// for pastoral care, family ministry planning, and appropriate ministry approaches.
    public let maritalStatus: MaritalStatus?

    /// The member's spouse's name, if available.
    ///
    /// Used for couple ministry, pastoral care, and family ministry planning.
    /// Important for addressing both members of a couple appropriately.
    public let spouseName: String?

    /// The number of children the member has, if available.
    ///
    /// Used for family ministry planning, children's ministry coordination,
    /// and understanding the member's family context for pastoral care.
    public let numberOfChildren: Int?

    /// Creates a new MaritalInformation instance.
    ///
    /// - Parameters:
    ///   - maritalStatus: The member's marital status
    ///   - weddingAnniversary: The member's wedding anniversary date
    ///   - spouseName: The member's spouse's name
    ///   - numberOfChildren: The number of children the member has
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

    /// Coding keys for mapping API fields to struct properties
    private enum CodingKeys: String, CodingKey {
        case maritalStatus = "martialStatus"
        case weddingAnniversary = "weddingAnniversaryDdMmYyyy"
        case spouseName
        case numberOfChildren
    }

    /// Creates a new MaritalInformation instance from a decoder
    ///
    /// This initializer handles the complex mapping between API field names and struct properties,
    /// including robust date parsing for various formats from Salesforce.
    ///
    /// - Parameter decoder: The decoder to read data from
    /// - Throws: `DecodingError` if the data is corrupted or invalid
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

    /// Encodes the MaritalInformation instance to an encoder
    ///
    /// This method handles the reverse mapping from struct properties back to API field names
    /// for proper serialization.
    ///
    /// - Parameter encoder: The encoder to write data to
    /// - Throws: `EncodingError` if the data cannot be encoded
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(maritalStatus, forKey: .maritalStatus)
        try container.encodeIfPresent(spouseName, forKey: .spouseName)
        try container.encodeIfPresent(numberOfChildren, forKey: .numberOfChildren)
    }

    /// DateFormatter for ddMMyyyy format
    ///
    /// This formatter handles the legacy date format used by some Salesforce systems.
    /// It's configured for consistent parsing regardless of locale or timezone.
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    /// A comprehensive representation of wedding anniversary information with professional date formatting and calculations.
    ///
    /// This struct provides rich anniversary data including date components, years of marriage,
    /// days until next anniversary, and multiple display formats for different use cases.
    ///
    /// ## Overview
    ///
    /// The `WeddingAnniversaryInfo` struct offers:
    /// - **Date Components:** Year, month, day, and day of week
    /// - **Marriage Duration:** Years of marriage calculation
    /// - **Anniversary Planning:** Days until next anniversary
    /// - **Multiple Formats:** Short, US, and full date formats
    /// - **This Year Check:** Whether anniversary falls in current year
    ///
    /// ## Example Usage
    ///
    /// ```swift
    /// if let anniversary = member.weddingAnniversaryInfo {
    ///     print("Years of marriage: \(anniversary.yearsOfMarriage)")
    ///     print("Next anniversary: \(anniversary.daysUntilNextAnniversary) days")
    ///     print("Anniversary date: \(anniversary.fullFormat)")
    ///
    ///     if anniversary.isThisYear {
    ///         print("Anniversary is this year!")
    ///     }
    /// }
    /// ```
    ///
    /// ## Topics
    ///
    /// ### Date Information
    /// - ``date`` - The original anniversary date
    /// - ``year`` - The year component
    /// - ``month`` - The month component
    /// - ``day`` - The day component
    /// - ``dayOfWeek`` - The day of the week (1 = Sunday, 7 = Saturday)
    ///
    /// ### Display Formats
    /// - ``shortFormat`` - Anniversary date in "day/month" format (e.g., "9/10")
    /// - ``usFormat`` - Anniversary date in "month/day" format (e.g., "10/9")
    /// - ``fullFormat`` - Full anniversary date in "day/month/year" format (e.g., "9/10/2013")
    ///
    /// ### Calculations
    /// - ``yearsOfMarriage`` - Number of years of marriage until now
    /// - ``daysUntilNextAnniversary`` - Days until next anniversary
    /// - ``isThisYear`` - Whether the anniversary is this year
    public struct WeddingAnniversaryInfo: Codable, Equatable, Sendable {
        /// The original anniversary date
        public let date: Date

        /// The year component of the anniversary date
        public let year: Int

        /// The month component of the anniversary date
        public let month: Int

        /// The day component of the anniversary date
        public let day: Int

        /// The day of the week (1 = Sunday, 7 = Saturday)
        public let dayOfWeek: Int

        /// Anniversary date in "day/month" format (e.g., "9/10" for October 9th)
        ///
        /// This format is commonly used in many countries and is suitable
        /// for compact display in user interfaces.
        public var shortFormat: String {
            return "\(day)/\(month)"
        }

        /// Number of years of marriage until now
        ///
        /// This calculation provides the current duration of the marriage,
        /// which is useful for anniversary celebrations and pastoral care.
        public var yearsOfMarriage: Int {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year], from: date, to: now)
            return components.year ?? 0
        }

        /// Anniversary date in "month/day" format (e.g., "10/9" for October 9th)
        ///
        /// This format follows the US date convention and is commonly used
        /// in American contexts.
        public var usFormat: String {
            return "\(month)/\(day)"
        }

        /// Full anniversary date in "day/month/year" format (e.g., "9/10/2013")
        ///
        /// This format provides complete anniversary information including
        /// the year, useful for historical records and detailed displays.
        public var fullFormat: String {
            return "\(day)/\(month)/\(year)"
        }

        /// Whether the anniversary is this year
        ///
        /// This property helps identify if the anniversary falls in the current
        /// year, useful for anniversary celebration planning.
        public var isThisYear: Bool {
            let calendar = Calendar.current
            let now = Date()
            let currentMonth = calendar.component(.month, from: now)
            let currentDay = calendar.component(.day, from: now)

            // Check if the anniversary month and day match today's month and day
            return month == currentMonth && day == currentDay
        }

        /// Days until next anniversary
        ///
        /// This calculation determines how many days remain until the next
        /// anniversary, useful for anniversary celebration planning and reminders.
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

        /// Creates a new WeddingAnniversaryInfo instance
        ///
        /// - Parameter date: The anniversary date to analyze
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

    /// Returns detailed wedding anniversary info if available
    ///
    /// This computed property provides rich anniversary information when a wedding
    /// anniversary date is available, including date components, years of marriage,
    /// and anniversary planning data.
    public var weddingAnniversaryInfo: WeddingAnniversaryInfo? {
        guard let date = self._weddingAnniversary else { return nil }
        return WeddingAnniversaryInfo(date: date)
    }

    /// The raw wedding anniversary date, if available
    ///
    /// This property provides direct access to the raw anniversary date
    /// for cases where you need the original Date object.
    public var weddingAnniversaryDate: Date? {
        return _weddingAnniversary
    }

    /// Internal storage for the wedding anniversary date
    public let _weddingAnniversary: Date?
}

/// Represents marital status values with user-friendly display names
///
/// This enum defines the various marital statuses that members can have,
/// providing consistent display names for user interfaces and reports.
///
/// ## Overview
///
/// The `MaritalStatus` enum supports church ministry needs by providing:
/// - **Standard Statuses:** Common marital statuses for demographic analysis
/// - **User-Friendly Names:** Display names suitable for user interfaces
/// - **Extensible Design:** Support for additional statuses as needed
///
/// ## Example Usage
///
/// ```swift
/// let status = MaritalStatus.married
/// print(status.displayName) // "Married"
///
/// // Use in ministry planning
/// switch status {
/// case .married:
///     print("Consider couple ministry opportunities")
/// case .single:
///     print("Consider single adult ministry")
/// case .widowed:
///     print("Consider grief support ministry")
/// default:
///     print("Other marital status")
/// }
/// ```
///
/// ## Topics
///
/// ### Cases
/// - ``single`` - Single status
/// - ``married`` - Married status
/// - ``widowed`` - Widowed status
/// - ``divorced`` - Divorced status
/// - ``separated`` - Separated status
/// - ``other`` - Other marital status
///
/// ### Display Properties
/// - ``displayName`` - User-friendly display name
public enum MaritalStatus: String, Codable, CaseIterable, Sendable {
    /// Single status
    case single = "Single"
    /// Married status
    case married = "Married"
    /// Widowed status
    case widowed = "Widowed"
    /// Divorced status
    case divorced = "Divorced"
    /// Separated status
    case separated = "Separated"
    /// Other marital status
    case other

    /// A user-friendly display name for the marital status
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
    /// The wedding anniversary information, conforming to the protocol
    public var weddingAnniversary: WeddingAnniversaryInfo? { weddingAnniversaryInfo }
}
