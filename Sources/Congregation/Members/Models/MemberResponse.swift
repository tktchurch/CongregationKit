import Foundation

/// A response wrapper for member data from Salesforce.
///
/// Supports both paginated and non-paginated responses. The `members` array is always populated from the top-level 'members' key. Pagination metadata is available via the `metadata` property if present.
public struct MemberResponse: Codable, Sendable {
    /// The array of members returned from the API (from the top-level 'members' key).
    public let members: [Member]
    /// Pagination metadata, if present (from top-level keys).
    public let metadata: Metadata?
    /// Optional error flag.
    public let error: Bool?
    /// Optional error message.
    public let message: String?

    /// Metadata for paginated responses.
    public struct Metadata: Codable, Sendable {
        /// The number of items per page.
        public let per: Int?
        /// The total number of items available.
        public let total: Int?
        /// The current page number.
        public let page: Int?
        /// The next page token for cursor-based pagination.
        public let nextPageToken: String?
        /// The previous page token for cursor-based pagination.
        public let previousPageToken: String?
        public init(per: Int?, total: Int?, page: Int?, nextPageToken: String?, previousPageToken: String?) {
            self.per = per
            self.total = total
            self.page = page
            self.nextPageToken = nextPageToken
            self.previousPageToken = previousPageToken
        }
    }

    enum CodingKeys: String, CodingKey {
        case members
        case member
        case error
        case message
        // Pagination keys
        case totalRecords
        case pageSize
        case pageNumber
        case success
        case nextPageToken
        case previousPageToken
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Try to decode 'members' first, then fallback to 'member' (legacy)
        if let members = try? container.decode([Member].self, forKey: .members) {
            self.members = members
        } else {
            do {
                self.members = try container.decode([Member].self, forKey: .members)
            } catch {
                print("[DEBUG] Failed to decode 'members' array: \(error)")
                do {
                    self.members = try container.decode([Member].self, forKey: .member)
                } catch {
                    print("[DEBUG] Failed to decode 'member' array (legacy): \(error)")
                    self.members = []
                }
            }
        }
        // Extract pagination info from top-level keys
        let per = try? container.decodeIfPresent(Int.self, forKey: .pageSize)
        let total = try? container.decodeIfPresent(Int.self, forKey: .totalRecords)
        let page = try? container.decodeIfPresent(Int.self, forKey: .pageNumber)
        let nextPageToken = try? container.decodeIfPresent(String.self, forKey: .nextPageToken)
        let previousPageToken = try? container.decodeIfPresent(String.self, forKey: .previousPageToken)
        if per != nil || total != nil || page != nil || nextPageToken != nil || previousPageToken != nil {
            self.metadata = Metadata(per: per, total: total, page: page, nextPageToken: nextPageToken, previousPageToken: previousPageToken)
        } else {
            self.metadata = nil
        }
        self.error = try? container.decodeIfPresent(Bool.self, forKey: .error)
        self.message = try? container.decodeIfPresent(String.self, forKey: .message)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(members, forKey: .members)
        if let error = error {
            try container.encode(error, forKey: .error)
            try container.encode(false, forKey: .success)
        }
        if let message = message {
            try container.encode(message, forKey: .message)
        }
        if let metadata = metadata {
            if let per = metadata.per { try container.encode(per, forKey: .pageSize) }
            if let total = metadata.total { try container.encode(total, forKey: .totalRecords) }
            if let page = metadata.page { try container.encode(page, forKey: .pageNumber) }
        }
    }

    public init(members: [Member]) {
        self.members = members
        self.metadata = nil
        self.error = nil
        self.message = nil
    }
}

extension MemberResponse {
    // Convenience initializer for paginated response
    public init(members: [Member], per: Int, total: Int, page: Int) {
        self.members = members
        self.metadata = Metadata(per: per, total: total, page: page, nextPageToken: nil, previousPageToken: nil)
        self.error = nil
        self.message = nil
    }

    // Convenience initializer for error response
    public init(errorMessage: String) {
        self.members = []
        self.metadata = nil
        self.error = true
        self.message = errorMessage
    }

    // Helper to check if response is paginated
    public var isPaginated: Bool {
        return metadata != nil
    }

    // Helper to access pagination info safely
    public var paginationInfo: (per: Int, total: Int, page: Int)? {
        guard let metadata = metadata else { return nil }
        return (metadata.per ?? 0, metadata.total ?? 0, metadata.page ?? 0)
    }
}
