import Foundation

/// Represents the role a member plays within a family unit.
///
/// This enum defines the various roles that members can have within a family,
/// useful for family ministry planning and household management.
///
/// ## Example Usage
///
/// ```swift
/// let role = FamilyRole.head
/// print(role.displayName) // "Head of Household"
///
/// // Use for family ministry
/// switch role {
/// case .head:
///     print("Primary contact for family")
/// case .spouse:
///     print("Co-head of household")
/// case .child:
///     print("Children's ministry participant")
/// case .dependent:
///     print("Extended family member")
/// case .other:
///     print("Other family member")
/// }
/// ```
public enum FamilyRole: String, Codable, CaseIterable, Sendable {
    case head = "Head"
    case spouse = "Spouse"
    case child = "Child"
    case dependent = "Dependent"
    case other = "Other"

    /// A user-friendly display name for the family role.
    public var displayName: String {
        switch self {
        case .head: return "Head of Household"
        case .spouse: return "Spouse"
        case .child: return "Child"
        case .dependent: return "Dependent"
        case .other: return "Other"
        }
    }

    /// Whether this role typically represents an adult in the family.
    public var isAdultRole: Bool {
        switch self {
        case .head, .spouse: return true
        case .child, .dependent, .other: return false
        }
    }
}
