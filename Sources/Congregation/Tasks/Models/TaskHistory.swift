import Foundation

/// `GET /tasks/{id}/history` payload — Salesforce Chatter feed-tracked changes
/// for a Task. Feed tracking is forward-only, so `items` is empty until tracking
/// has been enabled on the org and a tracked field has changed since.
///
/// Entries reuse ``SeekerHistoryEntry`` so a single history renderer can serve
/// both seekers and tasks.
public struct TaskHistoryPage: Codable, Sendable, Equatable {
    public let items: [SeekerHistoryEntry]

    public init(items: [SeekerHistoryEntry] = []) {
        self.items = items
    }

    enum CodingKeys: String, CodingKey { case items }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decodeIfPresent([SeekerHistoryEntry].self, forKey: .items) ?? []
    }
}
