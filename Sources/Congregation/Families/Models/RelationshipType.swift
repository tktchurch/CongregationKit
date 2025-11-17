import Foundation

/// Represents the type of relationship between two members.
///
/// This enum defines common relationship types found in church communities,
/// including family relationships, spiritual mentoring, and ministry connections.
///
/// ## Overview
///
/// The `RelationshipType` enum supports:
/// - **Family Relationships:** Parent, child, sibling, spouse, etc.
/// - **Extended Family:** Grandparents, in-laws, cousins, etc.
/// - **Spiritual Relationships:** Mentor, discipler, prayer partner, etc.
/// - **Inverse Relationships:** Automatic determination of reverse relationships
///
/// ## Example Usage
///
/// ```swift
/// let type = RelationshipType.parent
/// print(type.displayName) // "Parent"
/// print(type.inverse) // .child
///
/// // Use for ministry planning
/// switch type {
/// case .spouse:
///     print("Couple ministry opportunity")
/// case .parent, .child:
///     print("Family ministry opportunity")
/// case .mentor, .mentee:
///     print("Discipleship ministry opportunity")
/// default:
///     break
/// }
/// ```
public enum RelationshipType: String, Codable, CaseIterable, Sendable {
    // MARK: - Immediate Family
    case spouse = "Spouse"
    case parent = "Parent"
    case child = "Child"
    case sibling = "Sibling"

    // MARK: - Extended Family
    case grandparent = "Grandparent"
    case grandchild = "Grandchild"
    case uncle = "Uncle"
    case aunt = "Aunt"
    case nephew = "Nephew"
    case niece = "Niece"
    case cousin = "Cousin"

    // MARK: - In-Laws
    case fatherInLaw = "Father-in-Law"
    case motherInLaw = "Mother-in-Law"
    case sonInLaw = "Son-in-Law"
    case daughterInLaw = "Daughter-in-Law"
    case brotherInLaw = "Brother-in-Law"
    case sisterInLaw = "Sister-in-Law"

    // MARK: - Guardianship
    case guardian = "Guardian"
    case ward = "Ward"

    // MARK: - Spiritual Relationships
    case mentor = "Mentor"
    case mentee = "Mentee"
    case discipler = "Discipler"
    case disciple = "Disciple"
    case prayerPartner = "Prayer Partner"
    case accountabilityPartner = "Accountability Partner"

    // MARK: - Ministry Relationships
    case lifeGroupLeader = "Life Group Leader"
    case lifeGroupMember = "Life Group Member"
    case ministryLeader = "Ministry Leader"
    case ministryTeamMember = "Ministry Team Member"

    // MARK: - Other
    case other = "Other"

    /// A user-friendly display name for the relationship type.
    public var displayName: String { rawValue }

    /// Returns the inverse relationship type.
    ///
    /// For example, if someone is a "Parent" to another person,
    /// that other person is a "Child" to them.
    public var inverse: RelationshipType {
        switch self {
        case .spouse: return .spouse
        case .parent: return .child
        case .child: return .parent
        case .sibling: return .sibling
        case .grandparent: return .grandchild
        case .grandchild: return .grandparent
        case .uncle: return .nephew // or niece, context-dependent
        case .aunt: return .niece // or nephew, context-dependent
        case .nephew: return .uncle // or aunt, context-dependent
        case .niece: return .aunt // or uncle, context-dependent
        case .cousin: return .cousin
        case .fatherInLaw: return .sonInLaw // or daughterInLaw
        case .motherInLaw: return .daughterInLaw // or sonInLaw
        case .sonInLaw: return .fatherInLaw // or motherInLaw
        case .daughterInLaw: return .motherInLaw // or fatherInLaw
        case .brotherInLaw: return .brotherInLaw // or sisterInLaw
        case .sisterInLaw: return .sisterInLaw // or brotherInLaw
        case .guardian: return .ward
        case .ward: return .guardian
        case .mentor: return .mentee
        case .mentee: return .mentor
        case .discipler: return .disciple
        case .disciple: return .discipler
        case .prayerPartner: return .prayerPartner
        case .accountabilityPartner: return .accountabilityPartner
        case .lifeGroupLeader: return .lifeGroupMember
        case .lifeGroupMember: return .lifeGroupLeader
        case .ministryLeader: return .ministryTeamMember
        case .ministryTeamMember: return .ministryLeader
        case .other: return .other
        }
    }

    /// Returns the category of this relationship type.
    public var category: RelationshipCategory {
        switch self {
        case .spouse:
            return .marriage
        case .parent, .child, .sibling, .grandparent, .grandchild,
             .uncle, .aunt, .nephew, .niece, .cousin,
             .fatherInLaw, .motherInLaw, .sonInLaw, .daughterInLaw,
             .brotherInLaw, .sisterInLaw, .guardian, .ward:
            return .family
        case .mentor, .mentee, .discipler, .disciple,
             .prayerPartner, .accountabilityPartner:
            return .spiritual
        case .lifeGroupLeader, .lifeGroupMember,
             .ministryLeader, .ministryTeamMember:
            return .ministry
        case .other:
            return .other
        }
    }

    /// Whether this relationship type is symmetrical (same inverse as itself).
    public var isSymmetrical: Bool {
        self == inverse
    }
}

/// Categories for grouping relationship types.
public enum RelationshipCategory: String, Codable, CaseIterable, Sendable {
    case family = "Family"
    case marriage = "Marriage"
    case spiritual = "Spiritual"
    case ministry = "Ministry"
    case other = "Other"

    public var displayName: String { rawValue }
}
