import Foundation

/// A type-safe identifier for family units that validates and normalizes family IDs.
///
/// `FamilyID` provides compile-time safety and runtime validation for family identifiers,
/// ensuring they are non-empty and properly formatted.
///
/// ## Overview
///
/// This type enforces family ID format requirements:
/// - **Non-Empty:** IDs must contain at least one character
/// - **Normalized:** IDs are trimmed of whitespace
/// - **Immutable:** Once created, the ID cannot be changed
///
/// ## Example Usage
///
/// ```swift
/// // Create a family ID
/// if let familyId = FamilyID(rawValue: "FAM001") {
///     print("Valid family ID: \(familyId.rawValue)")
/// }
///
/// // Invalid ID (empty string)
/// let invalidId = FamilyID(rawValue: "") // Returns nil
/// ```
public struct FamilyID: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    /// Creates a new FamilyID from a raw string value.
    ///
    /// - Parameter rawValue: The raw string identifier
    /// - Returns: A FamilyID if the string is non-empty, nil otherwise
    public init?(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        self.rawValue = trimmed
    }
}

extension FamilyID: CustomStringConvertible {
    public var description: String { rawValue }
}

extension FamilyID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let id = FamilyID(rawValue: value) else {
            fatalError("Invalid FamilyID string literal: '\(value)'")
        }
        self = id
    }
}
