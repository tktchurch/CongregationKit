import Foundation

/// A protocol for querying relationship information.
///
/// This protocol provides methods for navigating and querying relationships
/// between members, supporting family tree traversal and relationship discovery.
public protocol RelationshipQueryable {
    /// Get all parents of this member.
    func getParents(from relationships: [MemberRelationship], members: [Member]) -> [Member]

    /// Get all children of this member.
    func getChildren(from relationships: [MemberRelationship], members: [Member]) -> [Member]

    /// Get all siblings of this member.
    func getSiblings(from relationships: [MemberRelationship], members: [Member]) -> [Member]

    /// Get the spouse of this member.
    func getSpouse(from relationships: [MemberRelationship], members: [Member]) -> Member?

    /// Get all relatives of a specific relationship type.
    func getRelatives(
        ofType type: RelationshipType,
        from relationships: [MemberRelationship],
        members: [Member]
    ) -> [Member]
}

/// Default implementation for Member type.
extension RelationshipQueryable where Self == Member {
    public func getParents(from relationships: [MemberRelationship], members: [Member]) -> [Member] {
        guard let myId = self.memberId else { return [] }
        let parentIds = relationships
            .filter { $0.targetMemberId == myId && $0.relationshipType == .parent }
            .map { $0.sourceMemberId }
        return members.filter { member in
            guard let memberId = member.memberId else { return false }
            return parentIds.contains(memberId)
        }
    }

    public func getChildren(from relationships: [MemberRelationship], members: [Member]) -> [Member] {
        guard let myId = self.memberId else { return [] }
        let childIds = relationships
            .filter { $0.sourceMemberId == myId && $0.relationshipType == .parent }
            .map { $0.targetMemberId }
        return members.filter { member in
            guard let memberId = member.memberId else { return false }
            return childIds.contains(memberId)
        }
    }

    public func getSiblings(from relationships: [MemberRelationship], members: [Member]) -> [Member] {
        guard let myId = self.memberId else { return [] }
        let siblingIds = relationships
            .filter {
                ($0.sourceMemberId == myId || $0.targetMemberId == myId)
                    && $0.relationshipType == .sibling
            }
            .flatMap { [$0.sourceMemberId, $0.targetMemberId] }
            .filter { $0 != myId }
        return members.filter { member in
            guard let memberId = member.memberId else { return false }
            return siblingIds.contains(memberId)
        }
    }

    public func getSpouse(from relationships: [MemberRelationship], members: [Member]) -> Member? {
        guard let myId = self.memberId else { return nil }
        let spouseId = relationships
            .first {
                ($0.sourceMemberId == myId || $0.targetMemberId == myId)
                    && $0.relationshipType == .spouse
            }
            .flatMap { rel in
                rel.sourceMemberId == myId ? rel.targetMemberId : rel.sourceMemberId
            }
        guard let id = spouseId else { return nil }
        return members.first { $0.memberId == id }
    }

    public func getRelatives(
        ofType type: RelationshipType,
        from relationships: [MemberRelationship],
        members: [Member]
    ) -> [Member] {
        guard let myId = self.memberId else { return [] }
        let relativeIds = relationships
            .filter {
                ($0.sourceMemberId == myId || $0.targetMemberId == myId)
                    && $0.relationshipType == type
            }
            .flatMap { [$0.sourceMemberId, $0.targetMemberId] }
            .filter { $0 != myId }
        return members.filter { member in
            guard let memberId = member.memberId else { return false }
            return relativeIds.contains(memberId)
        }
    }
}

// Make Member conform to RelationshipQueryable
extension Member: RelationshipQueryable {}
