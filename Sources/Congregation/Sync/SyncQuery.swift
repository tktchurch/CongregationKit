import Foundation

/// Common list/query parameters for v2 sync APIs.
///
/// ## Overview
///
/// ``SyncQuery`` is framework-agnostic: any backend (Salesforce v2 today, others later)
/// can interpret these parameters for pagination, field selection, and delta pulls.
///
/// ## Example Usage
///
/// ```swift
/// let query = SyncQuery(
///     pageSize: 50,
///     fields: ["memberId", "firstName", "lastName", "campus"],
///     updatedAfter: lastSyncDate
/// )
/// let page = try await congregation.members.fetchAll(
///     query: query,
///     filters: MemberListQuery(campus: .eastCampus, search: "Sample")
/// )
/// ```
public struct SyncQuery: Sendable, Equatable {
    public var pageSize: Int?
    public var pageToken: String?
    public var fields: [String]?
    public var orderBy: String?
    public var updatedAfter: Date?
    public var updatedBefore: Date?

    public init(
        pageSize: Int? = nil,
        pageToken: String? = nil,
        fields: [String]? = nil,
        orderBy: String? = nil,
        updatedAfter: Date? = nil,
        updatedBefore: Date? = nil
    ) {
        self.pageSize = pageSize
        self.pageToken = pageToken
        self.fields = fields
        self.orderBy = orderBy
        self.updatedAfter = updatedAfter
        self.updatedBefore = updatedBefore
    }

    /// Converts this query into URL query parameters (ISO8601 dates, comma-separated fields).
    public func asQueryParameters(extra: [String: String] = [:]) -> [String: String] {
        var params = extra
        if let pageSize { params["pageSize"] = String(pageSize) }
        if let pageToken { params["pageToken"] = pageToken }
        if let fields, !fields.isEmpty { params["fields"] = fields.joined(separator: ",") }
        if let orderBy { params["orderBy"] = orderBy }
        if let updatedAfter { params["updatedAfter"] = Self.iso8601String(updatedAfter) }
        if let updatedBefore { params["updatedBefore"] = Self.iso8601String(updatedBefore) }
        return params
    }

    private static func iso8601String(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
}

/// Optional filters when listing members via v2.
public struct MemberListQuery: Sendable, Equatable {
    public var campus: Campus?
    public var status: MemberStatus?
    public var lifeGroup: String?
    public var search: String?

    public init(campus: Campus? = nil, status: MemberStatus? = nil, lifeGroup: String? = nil, search: String? = nil) {
        self.campus = campus
        self.status = status
        self.lifeGroup = lifeGroup
        self.search = search
    }

    public func asQueryParameters() -> [String: String] {
        var params: [String: String] = [:]
        if let campus { params["campus"] = campus.rawValue }
        if let status { params["status"] = status.rawValue }
        if let lifeGroup { params["lifeGroup"] = lifeGroup }
        if let search { params["q"] = search }
        return params
    }
}

/// Optional filters when listing seekers via v2.
public struct SeekerListQuery: Sendable, Equatable {
    public var campus: Campus?
    public var leadStatus: LeadStatus?
    public var callStatus: CallStatus?
    public var ownerId: StaffUserID?
    public var search: String?

    public init(
        campus: Campus? = nil,
        leadStatus: LeadStatus? = nil,
        callStatus: CallStatus? = nil,
        ownerId: StaffUserID? = nil,
        search: String? = nil
    ) {
        self.campus = campus
        self.leadStatus = leadStatus
        self.callStatus = callStatus
        self.ownerId = ownerId
        self.search = search
    }

    public func asQueryParameters() -> [String: String] {
        var params: [String: String] = [:]
        if let campus { params["campus"] = campus.rawValue }
        if let leadStatus { params["leadStatus"] = leadStatus.rawValue }
        if let callStatus { params["callStatus"] = callStatus.rawValue }
        if let ownerId { params["ownerId"] = ownerId.rawValue }
        if let search { params["q"] = search }
        return params
    }
}

/// Filters for listing follow-up tasks (ops work queue).
public struct FollowUpTaskQuery: Sendable, Equatable {
    public var view: FollowUpTaskView?
    public var mine: Bool?
    public var status: FollowUpTaskStatus?
    public var type: FollowUpTaskType?
    public var ownerId: StaffUserID?
    public var relatedId: String?
    public var subject: String?
    public var priority: FollowUpTaskPriority?
    public var activityDateFrom: String?
    public var activityDateTo: String?
    public var search: String?

    public init(
        view: FollowUpTaskView? = nil,
        mine: Bool? = nil,
        status: FollowUpTaskStatus? = nil,
        type: FollowUpTaskType? = nil,
        ownerId: StaffUserID? = nil,
        relatedId: String? = nil,
        subject: String? = nil,
        priority: FollowUpTaskPriority? = nil,
        activityDateFrom: String? = nil,
        activityDateTo: String? = nil,
        search: String? = nil
    ) {
        self.view = view
        self.mine = mine
        self.status = status
        self.type = type
        self.ownerId = ownerId
        self.relatedId = relatedId
        self.subject = subject
        self.priority = priority
        self.activityDateFrom = activityDateFrom
        self.activityDateTo = activityDateTo
        self.search = search
    }

    public func asQueryParameters() -> [String: String] {
        var params: [String: String] = [:]
        if let view { params["view"] = view.rawValue }
        if let mine, mine { params["mine"] = "true" }
        if let status { params["status"] = status.rawValue }
        if let type { params["type"] = type.rawValue }
        if let ownerId { params["ownerId"] = ownerId.rawValue }
        if let relatedId { params["relatedId"] = relatedId }
        if let subject { params["subject"] = subject }
        if let priority { params["priority"] = priority.rawValue }
        if let activityDateFrom { params["activityDateFrom"] = activityDateFrom }
        if let activityDateTo { params["activityDateTo"] = activityDateTo }
        if let search { params["q"] = search }
        return params
    }
}

/// Filters when listing church ops staff users.
public struct StaffUserListQuery: Sendable, Equatable {
    public var group: StaffUserGroup?
    public var search: String?

    public init(group: StaffUserGroup? = nil, search: String? = nil) {
        self.group = group
        self.search = search
    }

    public func asQueryParameters() -> [String: String] {
        var params: [String: String] = [:]
        if let group { params["group"] = group.rawValue }
        if let search { params["q"] = search }
        return params
    }
}

/// Write options for v2 mutating requests.
public struct SyncWriteOptions: Sendable, Equatable {
    public var ifMatch: String?
    public var idempotencyKey: String?
    public var updateMask: [String]?

    public init(ifMatch: String? = nil, idempotencyKey: String? = nil, updateMask: [String]? = nil) {
        self.ifMatch = ifMatch
        self.idempotencyKey = idempotencyKey
        self.updateMask = updateMask
    }
}
