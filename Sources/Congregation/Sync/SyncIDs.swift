import Foundation

/// A type-safe internal identifier for seekers, with a validated `SKR` prefix.
///
/// Mirrors `MemberID` for members (`TKT######`). All CRM-managed seekers receive an
/// `SKR#####` internal ID; the raw Salesforce record ID (`00Q...`) is stored separately
/// as a plain `String` on the backend `SeekerDocument`.
public struct SeekerID: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    /// Returns `nil` for any string that does not begin with `SKR` (case-insensitive).
    /// Normalises the prefix to uppercase `SKR`.
    public init?(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 3, trimmed.prefix(3).lowercased() == "skr" else { return nil }
        self.rawValue = "SKR" + trimmed.dropFirst(3)
    }

    /// Throws `SeekerError.invalidSeekerID` for non-`SKR` strings.
    public init(validating value: String) throws {
        guard let id = SeekerID(rawValue: value) else {
            throw SeekerError.invalidSeekerID
        }
        self = id
    }
}

/// A type-safe Salesforce User id for church ops staff.
public struct StaffUserID: RawRepresentable, Codable, Hashable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init?(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        self.rawValue = trimmed
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

/// A type-safe identifier for family information records.
public struct FamilyRecordID: RawRepresentable, Codable, Hashable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init?(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        self.rawValue = trimmed
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

/// A type-safe identifier for spiritual information records.
public struct SpiritualRecordID: RawRepresentable, Codable, Hashable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init?(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        self.rawValue = trimmed
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

/// A type-safe identifier for course records.
public struct CourseID: RawRepresentable, Codable, Hashable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init?(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        self.rawValue = trimmed
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

/// A type-safe identifier for follow-up task records.
public struct FollowUpTaskID: RawRepresentable, Codable, Hashable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init?(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        self.rawValue = trimmed
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}
