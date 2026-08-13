import Foundation

/// A household unit in the congregation domain (framework-agnostic).
///
/// Distinct from ``FamilyRecord``, which is a Salesforce v2 person/dependent row
/// from `/families`. Use ``Family`` / ``FamilyTree`` / ``FamiliesHandler`` for
/// household identity and relationships. Salesforce v2 does not implement this handler.
///
/// A family groups related members together, providing a household-level view
/// for ministry planning, pastoral care, and demographic analysis.
///
/// ## Overview
///
/// The `Family` struct provides:
/// - **Family Identity:** Unique ID and family name
/// - **Household Information:** Address and contact details
/// - **Leadership:** Head of family designation
/// - **Timestamps:** Creation and modification tracking
///
/// ## Example Usage
///
/// ```swift
/// let family = Family(
///     id: FamilyID(rawValue: "FAM001")!,
///     familyName: "Smith Family",
///     headOfFamily: MemberID(rawValue: "TKT1234")!,
///     address: "123 Main Street",
///     homePhone: "555-0123"
/// )
///
/// print("Family: \(family.familyName ?? "Unknown")")
/// print("Address: \(family.address ?? "Not provided")")
/// ```
public struct Family: Codable, Equatable, Sendable {
    /// Unique identifier for this family unit.
    public let id: FamilyID

    /// The family name (e.g., "Smith Family", "Johnson Household").
    public let familyName: String?

    /// Date when this family record was created.
    public let createdDate: Date?

    /// Date when this family record was last modified.
    public let lastModifiedDate: Date?

    /// The member ID of the head of this family.
    public let headOfFamily: MemberID?

    /// The primary address for this family.
    public let address: String?

    /// The home phone number for this family.
    public let homePhone: String?

    /// Optional notes about this family.
    public let notes: String?

    /// Creates a new Family instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the family
    ///   - familyName: The family name
    ///   - createdDate: Date when the record was created
    ///   - lastModifiedDate: Date when the record was last modified
    ///   - headOfFamily: Member ID of the head of family
    ///   - address: Primary address for the family
    ///   - homePhone: Home phone number
    ///   - notes: Optional notes about the family
    public init(
        id: FamilyID,
        familyName: String? = nil,
        createdDate: Date? = nil,
        lastModifiedDate: Date? = nil,
        headOfFamily: MemberID? = nil,
        address: String? = nil,
        homePhone: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.familyName = familyName
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate
        self.headOfFamily = headOfFamily
        self.address = address
        self.homePhone = homePhone
        self.notes = notes
    }
}
