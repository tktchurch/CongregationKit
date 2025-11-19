import Foundation

/// A type-safe identifier for member relationships that validates and normalizes relationship IDs.
///
/// `RelationshipID` provides compile-time safety and runtime validation for relationship identifiers,
/// ensuring they are non-empty and properly formatted.
///
/// ## Overview
///
/// This type enforces relationship ID format requirements:
/// - **Non-Empty:** IDs must contain at least one character
/// - **Normalized:** IDs are trimmed of whitespace
/// - **Immutable:** Once created, the ID cannot be changed
///
/// ## Example Usage
///
/// ```swift
/// // Create a relationship ID
/// if let relationshipId = RelationshipID(rawValue: "REL001") {
///     print("Valid relationship ID: \(relationshipId.rawValue)")
/// }
///
/// // Invalid ID (empty string)
/// let invalidId = RelationshipID(rawValue: "") // Returns nil
/// ```
public struct RelationshipID: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    /// Creates a new RelationshipID from a raw string value.
    ///
    /// - Parameter rawValue: The raw string identifier
    /// - Returns: A RelationshipID if the string is non-empty, nil otherwise
    public init?(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        self.rawValue = trimmed
    }
}

extension RelationshipID: CustomStringConvertible {
    public var description: String { rawValue }
}

extension RelationshipID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let id = RelationshipID(rawValue: value) else {
            fatalError("Invalid RelationshipID string literal: '\(value)'")
        }
        self = id
    }
}
