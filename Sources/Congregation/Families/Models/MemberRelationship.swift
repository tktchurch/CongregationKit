import Foundation

/// Represents a relationship between two church members.
///
/// This struct captures the connection between members, including the type of relationship,
/// temporal information, and additional metadata for pastoral care and ministry planning.
///
/// ## Overview
///
/// The `MemberRelationship` struct provides:
/// - **Bidirectional Linking:** Source and target member IDs
/// - **Typed Relationships:** Categorized relationship types
/// - **Temporal Tracking:** Start and end dates for relationship lifecycle
/// - **Priority Designation:** Primary relationship flag
/// - **Additional Context:** Notes for special circumstances
///
/// ## Example Usage
///
/// ```swift
/// // Create a parent-child relationship
/// let relationship = MemberRelationship(
///     id: RelationshipID(rawValue: "REL001")!,
///     sourceMemberId: MemberID(rawValue: "TKT1234")!,
///     targetMemberId: MemberID(rawValue: "TKT5678")!,
///     relationshipType: .parent,
///     startDate: Date(),
///     isPrimary: true,
///     notes: "Biological parent"
/// )
///
/// print("Type: \(relationship.relationshipType.displayName)")
/// print("Inverse: \(relationship.relationshipType.inverse.displayName)")
/// ```
///
/// ## Relationship Direction
///
/// The relationship is directional from source to target. For example:
/// - Source: Parent (TKT1234)
/// - Target: Child (TKT5678)
/// - Type: .parent means TKT1234 is the parent OF TKT5678
///
/// To get the inverse relationship (TKT5678 is child OF TKT1234),
/// use the `inverse` computed property.
public struct MemberRelationship: Codable, Equatable, Sendable {
    /// Unique identifier for this relationship.
    public let id: RelationshipID

    /// The member ID of the source (from) member.
    public let sourceMemberId: MemberID

    /// The member ID of the target (to) member.
    public let targetMemberId: MemberID

    /// The type of relationship from source to target.
    public let relationshipType: RelationshipType

    /// When this relationship started.
    public let startDate: Date?

    /// When this relationship ended (e.g., divorce, death).
    public let endDate: Date?

    /// Whether this is the primary relationship of its type.
    ///
    /// For example, if a child has multiple guardians, one might be designated as primary.
    public let isPrimary: Bool

    /// Additional notes about this relationship.
    public let notes: String?

    /// Creates a new MemberRelationship instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the relationship
    ///   - sourceMemberId: The source member's ID
    ///   - targetMemberId: The target member's ID
    ///   - relationshipType: The type of relationship
    ///   - startDate: When the relationship started
    ///   - endDate: When the relationship ended (if applicable)
    ///   - isPrimary: Whether this is the primary relationship
    ///   - notes: Additional notes
    public init(
        id: RelationshipID,
        sourceMemberId: MemberID,
        targetMemberId: MemberID,
        relationshipType: RelationshipType,
        startDate: Date? = nil,
        endDate: Date? = nil,
        isPrimary: Bool = false,
        notes: String? = nil
    ) {
        self.id = id
        self.sourceMemberId = sourceMemberId
        self.targetMemberId = targetMemberId
        self.relationshipType = relationshipType
        self.startDate = startDate
        self.endDate = endDate
        self.isPrimary = isPrimary
        self.notes = notes
    }

    /// Returns the inverse relationship (swapping source and target with inverse type).
    ///
    /// This is useful for creating bidirectional relationships automatically.
    ///
    /// - Parameter newId: A new ID for the inverse relationship
    /// - Returns: A new MemberRelationship with swapped members and inverse type
    public func inverse(withId newId: RelationshipID) -> MemberRelationship {
        MemberRelationship(
            id: newId,
            sourceMemberId: targetMemberId,
            targetMemberId: sourceMemberId,
            relationshipType: relationshipType.inverse,
            startDate: startDate,
            endDate: endDate,
            isPrimary: isPrimary,
            notes: notes
        )
    }

    /// Whether this relationship is currently active (no end date).
    public var isActive: Bool {
        endDate == nil
    }

    /// Duration of the relationship in years, if start date is available.
    public var durationInYears: Int? {
        guard let start = startDate else { return nil }
        let end = endDate ?? Date()
        let components = Calendar.current.dateComponents([.year], from: start, to: end)
        return components.year
    }
}
