import Foundation

/// Represents a member's membership within a family unit.
///
/// This struct tracks which members belong to which families and their roles
/// within those families, supporting multi-generational household management.
///
/// ## Overview
///
/// The `FamilyMembership` struct provides:
/// - **Family Association:** Links members to family units
/// - **Role Definition:** Specifies the member's role in the family
/// - **Temporal Tracking:** When they joined the family
/// - **Status Management:** Whether membership is active
///
/// ## Example Usage
///
/// ```swift
/// let membership = FamilyMembership(
///     familyId: FamilyID(rawValue: "FAM001")!,
///     memberId: MemberID(rawValue: "TKT1234")!,
///     role: .head,
///     joinDate: Date(),
///     isActive: true
/// )
///
/// print("Role: \(membership.role.displayName)")
/// print("Active: \(membership.isActive)")
/// ```
public struct FamilyMembership: Codable, Equatable, Sendable {
    /// The family this membership belongs to.
    public let familyId: FamilyID

    /// The member who belongs to this family.
    public let memberId: MemberID

    /// The member's role within the family.
    public let role: FamilyRole

    /// When the member joined this family.
    public let joinDate: Date?

    /// When the member left this family (if applicable).
    public let leaveDate: Date?

    /// Whether this membership is currently active.
    public let isActive: Bool

    /// Additional notes about this membership.
    public let notes: String?

    /// Creates a new FamilyMembership instance.
    ///
    /// - Parameters:
    ///   - familyId: The family's ID
    ///   - memberId: The member's ID
    ///   - role: The member's role in the family
    ///   - joinDate: When they joined the family
    ///   - leaveDate: When they left the family (if applicable)
    ///   - isActive: Whether the membership is active
    ///   - notes: Additional notes
    public init(
        familyId: FamilyID,
        memberId: MemberID,
        role: FamilyRole,
        joinDate: Date? = nil,
        leaveDate: Date? = nil,
        isActive: Bool = true,
        notes: String? = nil
    ) {
        self.familyId = familyId
        self.memberId = memberId
        self.role = role
        self.joinDate = joinDate
        self.leaveDate = leaveDate
        self.isActive = isActive
        self.notes = notes
    }

    /// Duration of membership in years.
    public var membershipDurationInYears: Int? {
        guard let join = joinDate else { return nil }
        let end = leaveDate ?? Date()
        let components = Calendar.current.dateComponents([.year], from: join, to: end)
        return components.year
    }
}
