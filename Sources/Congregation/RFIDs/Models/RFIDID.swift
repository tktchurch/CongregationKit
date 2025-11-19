import Foundation

/// A type-safe identifier for RFID records that validates and normalizes RFID IDs.
///
/// `RFIDID` provides compile-time safety and runtime validation for RFID identifiers,
/// ensuring they are non-empty and properly formatted.
///
/// ## Overview
///
/// This type enforces RFID ID format requirements:
/// - **Non-Empty:** IDs must contain at least one character
/// - **Normalized:** IDs are trimmed of whitespace
/// - **Immutable:** Once created, the ID cannot be changed
///
/// ## Example Usage
///
/// ```swift
/// // Create an RFID ID
/// if let rfidId = RFIDID(rawValue: "RFID001") {
///     print("Valid RFID ID: \(rfidId.rawValue)")
/// }
///
/// // Invalid ID (empty string)
/// let invalidId = RFIDID(rawValue: "") // Returns nil
/// ```
public struct RFIDID: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    /// Creates a new RFIDID from a raw string value.
    ///
    /// - Parameter rawValue: The raw string identifier
    /// - Returns: An RFIDID if the string is non-empty, nil otherwise
    public init?(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        self.rawValue = trimmed
    }
}

extension RFIDID: CustomStringConvertible {
    public var description: String { rawValue }
}

extension RFIDID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let id = RFIDID(rawValue: value) else {
            fatalError("Invalid RFIDID string literal: '\(value)'")
        }
        self = id
    }
}
