import Foundation

/// A comprehensive representation of family information with computed statistics and insights.
///
/// The `FamilyInfo` struct provides rich family data including member lists, relationships,
/// demographic statistics, and ministry planning insights.
///
/// ## Overview
///
/// This struct offers comprehensive family intelligence:
/// - **Family Composition:** Members and their roles
/// - **Relationship Mapping:** All relationships within the family
/// - **Demographics:** Age ranges, family size, adult/child counts
/// - **Ministry Insights:** Family needs and ministry opportunities
///
/// ## Example Usage
///
/// ```swift
/// let familyInfo = FamilyInfo(
///     family: family,
///     members: [parent1, parent2, child1, child2],
///     memberships: memberships,
///     relationships: relationships
/// )
///
/// print("Family size: \(familyInfo.familySize)")
/// print("Adults: \(familyInfo.adultCount)")
/// print("Children: \(familyInfo.childCount)")
/// print("Has minors: \(familyInfo.hasMinors)")
///
/// if let avgAge = familyInfo.averageAge {
///     print("Average age: \(avgAge)")
/// }
/// ```
public struct FamilyInfo: Codable, Sendable {
    /// The family unit.
    public let family: Family

    /// All members belonging to this family.
    public let members: [Member]

    /// Family membership records for each member.
    public let memberships: [FamilyMembership]

    /// Relationships between family members.
    public let relationships: [MemberRelationship]

    /// Creates a new FamilyInfo instance.
    ///
    /// - Parameters:
    ///   - family: The family unit
    ///   - members: All members in the family
    ///   - memberships: Membership records
    ///   - relationships: Relationships between members
    public init(
        family: Family,
        members: [Member],
        memberships: [FamilyMembership],
        relationships: [MemberRelationship]
    ) {
        self.family = family
        self.members = members
        self.memberships = memberships
        self.relationships = relationships
    }

    // MARK: - Computed Properties

    /// Total number of members in the family.
    public var familySize: Int { members.count }

    /// Number of adults (18+) in the family.
    public var adultCount: Int {
        members.filter { member in
            guard let birthInfo = member.dateOfBirth else { return true }  // Assume adult if unknown
            return birthInfo.age >= 18
        }.count
    }

    /// Number of children (under 18) in the family.
    public var childCount: Int {
        members.filter { member in
            guard let birthInfo = member.dateOfBirth else { return false }
            return birthInfo.age < 18
        }.count
    }

    /// Whether the family has any minors (under 18).
    public var hasMinors: Bool { childCount > 0 }

    /// The head of the family member, if found.
    public var headOfHousehold: Member? {
        guard let headId = family.headOfFamily else { return nil }
        return members.first { $0.memberId == headId }
    }

    /// The spouse of the head of household, if found.
    public var spouseOfHead: Member? {
        guard let headId = family.headOfFamily else { return nil }
        let spouseRelationship = relationships.first { rel in
            rel.sourceMemberId == headId && rel.relationshipType == .spouse
        }
        guard let spouseId = spouseRelationship?.targetMemberId else { return nil }
        return members.first { $0.memberId == spouseId }
    }

    /// All children in the family (by membership role).
    public var children: [Member] {
        let childMemberIds = memberships.filter { $0.role == .child }.map { $0.memberId }
        return members.filter { member in
            guard let memberId = member.memberId else { return false }
            return childMemberIds.contains(memberId)
        }
    }

    /// All adults in the family (by age).
    public var adults: [Member] {
        members.filter { member in
            guard let birthInfo = member.dateOfBirth else { return true }
            return birthInfo.age >= 18
        }
    }

    /// Average age of all family members with known birth dates.
    public var averageAge: Double? {
        let ages = members.compactMap { $0.dateOfBirth?.age }
        guard !ages.isEmpty else { return nil }
        return Double(ages.reduce(0, +)) / Double(ages.count)
    }

    /// Age range of the family (youngest to oldest).
    public var ageRange: ClosedRange<Int>? {
        let ages = members.compactMap { $0.dateOfBirth?.age }
        guard let minAge = ages.min(), let maxAge = ages.max() else { return nil }
        return minAge...maxAge
    }

    /// All unique relationship types within this family.
    public var relationshipTypes: Set<RelationshipType> {
        Set(relationships.map { $0.relationshipType })
    }

    /// Members grouped by their family role.
    public var membersByRole: [FamilyRole: [Member]] {
        var result: [FamilyRole: [Member]] = [:]
        for membership in memberships {
            let member = members.first { $0.memberId == membership.memberId }
            if let member = member {
                result[membership.role, default: []].append(member)
            }
        }
        return result
    }

    /// Total number of active relationships.
    public var activeRelationshipCount: Int {
        relationships.filter { $0.isActive }.count
    }

    /// Whether this is a single-parent family.
    public var isSingleParentFamily: Bool {
        let headExists = headOfHousehold != nil
        let spouseExists = spouseOfHead != nil
        let hasChildren = childCount > 0
        return headExists && !spouseExists && hasChildren
    }

    /// Whether this is a multi-generational family.
    public var isMultiGenerational: Bool {
        let hasGrandparentRelationship = relationships.contains {
            $0.relationshipType == .grandparent || $0.relationshipType == .grandchild
        }
        return hasGrandparentRelationship
    }
}
