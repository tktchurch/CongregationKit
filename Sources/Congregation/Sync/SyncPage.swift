import Foundation

/// A paginated list of sync records from any backend implementing the sync protocols.
///
/// ## Overview
///
/// v2 list responses use cursor pagination via `nextPageToken` / `prevPageToken` and
/// report `totalSize` for the filtered result set.
///
/// ## Example Usage
///
/// ```swift
/// var query = SyncQuery(pageSize: 100)
/// repeat {
///     let page = try await congregation.members.fetchAll(query: query)
///     process(page.records)
///     query.pageToken = page.nextPageToken
/// } while query.pageToken != nil
/// ```
public struct SyncPage<Record: Sendable>: Sendable {
    public let records: [Record]
    public let nextPageToken: String?
    public let prevPageToken: String?
    public let totalSize: Int?

    public init(
        records: [Record],
        nextPageToken: String? = nil,
        prevPageToken: String? = nil,
        totalSize: Int? = nil
    ) {
        self.records = records
        self.nextPageToken = nextPageToken
        self.prevPageToken = prevPageToken
        self.totalSize = totalSize
    }
}

/// Bridges v2 ``SyncPage`` to legacy ``MemberResponse`` wrappers.
extension MemberResponse {
    @available(*, deprecated, message: "Use SyncPage<Member> from the v2 members handler.")
    public init(from syncPage: SyncPage<Member>) {
        self.init(
            members: syncPage.records,
            metadata: Metadata(
                per: nil,
                total: syncPage.totalSize,
                page: nil,
                nextPageToken: syncPage.nextPageToken,
                previousPageToken: syncPage.prevPageToken
            )
        )
    }
}

/// Bridges v2 ``SyncPage`` to legacy ``SeekerResponse`` wrappers.
extension SeekerResponse {
    @available(*, deprecated, message: "Use SyncPage<Seeker> from the v2 seekers handler.")
    public init(from syncPage: SyncPage<Seeker>) {
        self.init(
            seekers: syncPage.records,
            metadata: Metadata(
                per: nil,
                total: syncPage.totalSize,
                page: nil,
                nextPageToken: syncPage.nextPageToken,
                previousPageToken: syncPage.prevPageToken
            )
        )
    }
}
