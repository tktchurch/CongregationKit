import Foundation

/// A type-safe identifier for seekers (`Seeker_ID__c` external id).
public struct SeekerID: RawRepresentable, Codable, Hashable, Sendable, ExpressibleByStringLiteral {
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
