import Foundation

/// Lifecycle status of a Care Group.
public enum CareGroupStatus: String, Codable, CaseIterable, Sendable {
    case active
    case multiplying
    case paused
    case archived

    public var displayName: String {
        switch self {
        case .active: return "Active"
        case .multiplying: return "Multiplying"
        case .paused: return "Paused"
        case .archived: return "Archived"
        }
    }
}

/// Leadership and hosting roles within a Care Group.
public enum CareGroupRole: String, Codable, CaseIterable, Sendable {
    case coordinator
    case coCoordinator
    case host
    case backupHost

    public var displayName: String {
        switch self {
        case .coordinator: return "Coordinator"
        case .coCoordinator: return "Co-Coordinator"
        case .host: return "Host Home"
        case .backupHost: return "Backup Host"
        }
    }
}

/// Participation status for a Care Group roster entry.
public enum CareGroupMembershipStatus: String, Codable, CaseIterable, Sendable {
    case active
    case inactive
    case transferred
}

/// A neighborhood Care Group gathering in a host home under an ``Area`` and ``District``.
public struct CareGroup: Codable, Hashable, Sendable, Identifiable {
    public let id: String
    public let careGroupCode: CareGroupID
    public let name: String
    public let areaId: String
    public let districtCode: String?
    public let hostDigipin: DIGIPINCode?
    public let status: CareGroupStatus
    public let meetingDay: String?
    public let meetingTime: String?
    public let preferredLanguage: String?

    public init(
        id: String,
        careGroupCode: CareGroupID,
        name: String,
        areaId: String,
        districtCode: String? = nil,
        hostDigipin: DIGIPINCode? = nil,
        status: CareGroupStatus = .active,
        meetingDay: String? = nil,
        meetingTime: String? = nil,
        preferredLanguage: String? = nil
    ) {
        self.id = id
        self.careGroupCode = careGroupCode
        self.name = name
        self.areaId = areaId
        self.districtCode = districtCode
        self.hostDigipin = hostDigipin
        self.status = status
        self.meetingDay = meetingDay
        self.meetingTime = meetingTime
        self.preferredLanguage = preferredLanguage
    }
}

/// An effective-dated Coordinator or Host assignment on a ``CareGroup``.
public struct CareGroupLeader: Codable, Hashable, Sendable, Identifiable {
    public let id: String
    public let careGroupId: String
    public let memberId: MemberID
    public let role: CareGroupRole
    public let isPrimary: Bool
    public let hostDigipin: DIGIPINCode?
    public let startDate: Date
    public let endDate: Date?

    public init(
        id: String,
        careGroupId: String,
        memberId: MemberID,
        role: CareGroupRole,
        isPrimary: Bool = false,
        hostDigipin: DIGIPINCode? = nil,
        startDate: Date,
        endDate: Date? = nil
    ) {
        self.id = id
        self.careGroupId = careGroupId
        self.memberId = memberId
        self.role = role
        self.isPrimary = isPrimary
        self.hostDigipin = hostDigipin
        self.startDate = startDate
        self.endDate = endDate
    }
}

/// A Care Group roster entry enforcing XOR between a registered Member and a Seeker.
public struct CareGroupParticipant: Codable, Hashable, Sendable, Identifiable {
    public let id: String
    public let careGroupId: String
    public let participant: ParticipantReference
    public let priorSeekerId: String?
    public let status: CareGroupMembershipStatus
    public let joinedAt: Date
    public let leftAt: Date?

    public init(
        id: String,
        careGroupId: String,
        participant: ParticipantReference,
        priorSeekerId: String? = nil,
        status: CareGroupMembershipStatus = .active,
        joinedAt: Date,
        leftAt: Date? = nil
    ) {
        self.id = id
        self.careGroupId = careGroupId
        self.participant = participant
        self.priorSeekerId = priorSeekerId
        self.status = status
        self.joinedAt = joinedAt
        self.leftAt = leftAt
    }
}
