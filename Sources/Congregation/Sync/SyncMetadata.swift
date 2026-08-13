import Foundation

/// Metadata present on every TKT API v2 resource (OpenAPI ``SyncMeta``).
///
/// Used for delta sync, optimistic concurrency (`If-Match`), and resource naming.
///
/// ## Overview
///
/// v2 records include a stable resource `name` (for example `members/TKT1234`), an `etag`
/// derived from `SystemModstamp`, and ISO8601 `createTime` / `updateTime` timestamps.
///
/// ## Example Usage
///
/// ```swift
/// let page = try await congregation.members.fetchAll(query: SyncQuery(pageSize: 50))
/// for member in page.records {
///     if let etag = member.sync?.etag {
///         print("Member \(member.memberId?.rawValue ?? "") etag: \(etag)")
///     }
/// }
/// ```
public struct SyncMetadata: Codable, Sendable, Equatable {
    /// Resource name, e.g. `members/TKT1234`.
    public let name: String?
    /// Weak ETag for optimistic concurrency.
    public let etag: String?
    /// Record creation time (UTC).
    public let createTime: Date?
    /// Last modification time (UTC).
    public let updateTime: Date?

    public init(name: String? = nil, etag: String? = nil, createTime: Date? = nil, updateTime: Date? = nil) {
        self.name = name
        self.etag = etag
        self.createTime = createTime
        self.updateTime = updateTime
    }
}

/// Types that carry v2 sync metadata alongside domain fields.
public protocol SyncMetadataRepresentable: Sendable {
    var sync: SyncMetadata? { get }
}

enum SyncDateCoding {
    static func decode(from string: String?) -> Date? {
        guard let string, !string.isEmpty else { return nil }
        if string.count == 10, !string.contains("T") {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter.date(from: string)
        }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: string) { return date }
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: string)
    }
}
