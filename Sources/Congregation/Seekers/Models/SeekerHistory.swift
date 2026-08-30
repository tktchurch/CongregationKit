import Foundation

/// Visual state of one Salesforce Path chevron for ``LeadStatus``.
public struct LeadStatusPathStep: Codable, Sendable, Equatable, Identifiable {
    public enum State: String, Codable, Sendable {
        case completed
        case current
        case upcoming
    }

    public var id: String { apiValue }
    public let apiValue: String
    public let label: String
    public let state: State

    public init(status: LeadStatus, state: State) {
        self.apiValue = status.rawValue
        self.label = status.displayName
        self.state = state
    }

    public init(apiValue: String, label: String, state: State) {
        self.apiValue = apiValue
        self.label = label
        self.state = state
    }
}

/// One Salesforce field-history row for a seeker (`Lead__History`).
public struct SeekerHistoryEntry: Codable, Sendable, Identifiable, Equatable {
    public let id: String
    public let field: String
    public let oldValue: String?
    public let newValue: String?
    public let oldLabel: String?
    public let newLabel: String?
    public let changedBy: String?
    public let createTime: Date?

    public init(
        id: String,
        field: String,
        oldValue: String? = nil,
        newValue: String? = nil,
        oldLabel: String? = nil,
        newLabel: String? = nil,
        changedBy: String? = nil,
        createTime: Date? = nil
    ) {
        self.id = id
        self.field = field
        self.oldValue = oldValue
        self.newValue = newValue
        self.oldLabel = oldLabel
        self.newLabel = newLabel
        self.changedBy = changedBy
        self.createTime = createTime
    }

    enum CodingKeys: String, CodingKey {
        case id, field, oldValue, newValue, oldLabel, newLabel, changedBy, createTime
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        field = try container.decodeIfPresent(String.self, forKey: .field) ?? ""
        oldValue = try container.decodeIfPresent(String.self, forKey: .oldValue)
        newValue = try container.decodeIfPresent(String.self, forKey: .newValue)
        oldLabel = try container.decodeIfPresent(String.self, forKey: .oldLabel)
        newLabel = try container.decodeIfPresent(String.self, forKey: .newLabel)
        changedBy = try container.decodeIfPresent(String.self, forKey: .changedBy)
        createTime = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .createTime))
    }
}

/// TKT API v2 `GET /seekers/{id}/history` payload: Field History plus Path.
public struct SeekerHistoryPage: Codable, Sendable, Equatable {
    public let items: [SeekerHistoryEntry]
    public let path: [LeadStatusPathStep]
    public let currentStatus: LeadStatus?
    public let nextStatus: LeadStatus?

    public init(
        items: [SeekerHistoryEntry] = [],
        path: [LeadStatusPathStep] = [],
        currentStatus: LeadStatus? = nil,
        nextStatus: LeadStatus? = nil
    ) {
        self.items = items
        self.path = path
        self.currentStatus = currentStatus
        self.nextStatus = nextStatus
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decodeIfPresent([SeekerHistoryEntry].self, forKey: .items) ?? []
        currentStatus = try container.decodeIfPresent(LeadStatus.self, forKey: .currentStatus)
        nextStatus = try container.decodeIfPresent(LeadStatus.self, forKey: .nextStatus)
        let decodedPath = try container.decodeIfPresent([LeadStatusPathStep].self, forKey: .path) ?? []
        path = decodedPath.isEmpty ? LeadStatus.path(current: currentStatus) : decodedPath
    }

    enum CodingKeys: String, CodingKey {
        case items, path, currentStatus, nextStatus
    }

    /// Rebuilds Path from the current status when the server omitted `path`.
    public static func reconstructed(
        currentStatus: LeadStatus?,
        items: [SeekerHistoryEntry] = []
    ) -> SeekerHistoryPage {
        SeekerHistoryPage(
            items: items,
            path: LeadStatus.path(current: currentStatus),
            currentStatus: currentStatus,
            nextStatus: currentStatus?.nextOnPath
        )
    }
}
