import Foundation

/// A protocol for types that can represent family membership information.
///
/// This protocol provides a standardized interface for accessing family-related
/// data, ensuring consistency across different models.
public protocol FamilyRepresentable {
    /// The family ID this member belongs to, if any.
    var familyId: FamilyID? { get }

    /// The member's role within their family.
    var familyRole: FamilyRole? { get }

    /// All relationships this member has with other members.
    var relationships: [MemberRelationship]? { get }
}
