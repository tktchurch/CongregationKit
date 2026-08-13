import Foundation

/// Whether a follow-up task relates to a seeker or a member.
public enum FollowUpTaskType: String, Codable, Sendable, CaseIterable {
    case seeker = "Seeker"
    case member = "Member"
}

/// Salesforce Task status values, with ``unknown`` for org-specific extras.
public enum FollowUpTaskStatus: String, Codable, Sendable, CaseIterable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
    case waitingOnSomeoneElse = "Waiting on someone else"
    case deferred = "Deferred"
    case open = "Open"
    case unknown

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        self = FollowUpTaskStatus(rawValue: value) ?? .unknown
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self == .unknown ? "" : rawValue)
    }
}

/// Salesforce Task priority.
public enum FollowUpTaskPriority: String, Codable, Sendable, CaseIterable {
    case high = "High"
    case normal = "Normal"
    case low = "Low"
}

/// Lightning-style list view aliases for the ops task queue.
public enum FollowUpTaskView: String, Sendable, CaseIterable {
    case all
    case openSeekers
    case openMembers
    case completed
    case busy
    case notAnswered
    case callBack
    case callLater
    case notReachable
    case switchedOff
    case wrongNumber
    case numberDoesNotExist
    case numberNotInService
}

/// A follow-up task assigned to church ops staff about a seeker or member.
///
/// ## Overview
///
/// Maps to Salesforce `Task` via TKT API v2. This is **not** a congregation member —
/// see ``StaffUser`` for the ops person who owns the task.
///
/// ## Example Usage
///
/// ```swift
/// let page = try await congregation.tasks.fetchAll(
///     query: SyncQuery(pageSize: 25),
///     filters: FollowUpTaskQuery(view: .openSeekers, mine: true, search: "call")
/// )
/// for task in page.records {
///     print(task.subject ?? "", task.ownerName ?? "")
/// }
/// ```
public struct FollowUpTask: Decodable, Identifiable, Sendable, SyncMetadataRepresentable {
    public let id: String?
    public let sync: SyncMetadata?
    public let subject: String?
    public let status: FollowUpTaskStatus?
    public let priority: FollowUpTaskPriority?
    public let type: FollowUpTaskType?
    public let relatedId: String?
    public let relatedName: String?
    public let relatedResource: String?
    public let phone: String?
    public let ownerId: StaffUserID?
    public let ownerName: String?
    public let activityDate: Date?
    public let description: String?
    public let area: String?
    public let location: String?
    public let visiting: String?
    public let remarksFromTheCall: String?
    public let commentsFromTheVisit: String?
    public let statusChangeDate: Date?
    public let assignedDate: Date?
    public let completedDateTime: Date?

    public init(
        id: String? = nil,
        sync: SyncMetadata? = nil,
        subject: String? = nil,
        status: FollowUpTaskStatus? = nil,
        priority: FollowUpTaskPriority? = nil,
        type: FollowUpTaskType? = nil,
        relatedId: String? = nil,
        relatedName: String? = nil,
        relatedResource: String? = nil,
        phone: String? = nil,
        ownerId: StaffUserID? = nil,
        ownerName: String? = nil,
        activityDate: Date? = nil,
        description: String? = nil,
        area: String? = nil,
        location: String? = nil,
        visiting: String? = nil,
        remarksFromTheCall: String? = nil,
        commentsFromTheVisit: String? = nil,
        statusChangeDate: Date? = nil,
        assignedDate: Date? = nil,
        completedDateTime: Date? = nil
    ) {
        self.id = id
        self.sync = sync
        self.subject = subject
        self.status = status
        self.priority = priority
        self.type = type
        self.relatedId = relatedId
        self.relatedName = relatedName
        self.relatedResource = relatedResource
        self.phone = phone
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.activityDate = activityDate
        self.description = description
        self.area = area
        self.location = location
        self.visiting = visiting
        self.remarksFromTheCall = remarksFromTheCall
        self.commentsFromTheVisit = commentsFromTheVisit
        self.statusChangeDate = statusChangeDate
        self.assignedDate = assignedDate
        self.completedDateTime = completedDateTime
    }

    enum CodingKeys: String, CodingKey {
        case id, subject, status, priority, type, relatedId, relatedName, relatedResource
        case phone, ownerId, ownerName, activityDate, description, area, location, visiting
        case remarksFromTheCall, commentsFromTheVisit, statusChangeDate, assignedDate, completedDateTime
        case name, etag, createTime, updateTime
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        subject = try container.decodeIfPresent(String.self, forKey: .subject)
        status = try container.decodeIfPresent(FollowUpTaskStatus.self, forKey: .status)
        priority = try container.decodeIfPresent(FollowUpTaskPriority.self, forKey: .priority)
        type = try container.decodeIfPresent(FollowUpTaskType.self, forKey: .type)
        relatedId = try container.decodeIfPresent(String.self, forKey: .relatedId)
        relatedName = try container.decodeIfPresent(String.self, forKey: .relatedName)
        relatedResource = try container.decodeIfPresent(String.self, forKey: .relatedResource)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        ownerId = (try container.decodeIfPresent(String.self, forKey: .ownerId)).flatMap(StaffUserID.init(rawValue:))
        ownerName = try container.decodeIfPresent(String.self, forKey: .ownerName)
        activityDate = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .activityDate))
        description = try container.decodeIfPresent(String.self, forKey: .description)
        area = try container.decodeIfPresent(String.self, forKey: .area)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        visiting = try container.decodeIfPresent(String.self, forKey: .visiting)
        remarksFromTheCall = try container.decodeIfPresent(String.self, forKey: .remarksFromTheCall)
        commentsFromTheVisit = try container.decodeIfPresent(String.self, forKey: .commentsFromTheVisit)
        statusChangeDate = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .statusChangeDate))
        assignedDate = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .assignedDate))
        completedDateTime = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .completedDateTime))
        sync = SyncMetadata(
            name: try container.decodeIfPresent(String.self, forKey: .name),
            etag: try container.decodeIfPresent(String.self, forKey: .etag),
            createTime: SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .createTime)),
            updateTime: SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .updateTime))
        )
    }
}
