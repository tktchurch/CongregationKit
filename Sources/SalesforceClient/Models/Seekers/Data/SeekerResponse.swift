import Foundation

/// A response wrapper for seeker data from the API.
///
/// Supports both paginated and non-paginated responses. The `seekers` array is always populated from the top-level 'seekers' key. Pagination metadata is available via the `metadata` property if present.
public struct SeekerResponse: Codable, Sendable {
    /// The array of seekers returned from the API (from the top-level 'seekers' key).
    public let seekers: [Seeker]
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
        case seekers
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
        // Only decode 'seekers' array
        self.seekers = (try? container.decode([Seeker].self, forKey: .seekers)) ?? []
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

    public init(seekers: [Seeker]) {
        self.seekers = seekers
        self.metadata = nil
        self.error = nil
        self.message = nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(seekers, forKey: .seekers)
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
            if let nextPageToken = metadata.nextPageToken { try container.encode(nextPageToken, forKey: .nextPageToken) }
            if let previousPageToken = metadata.previousPageToken { try container.encode(previousPageToken, forKey: .previousPageToken) }
        }
    }
}

extension SeekerResponse {
    // Convenience initializer for paginated response
    public init(seekers: [Seeker], per: Int, total: Int, page: Int) {
        self.seekers = seekers
        self.metadata = Metadata(per: per, total: total, page: page, nextPageToken: nil, previousPageToken: nil)
        self.error = nil
        self.message = nil
    }

    // Convenience initializer for error response
    public init(errorMessage: String) {
        self.seekers = []
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

/// Errors specific to seeker operations
public enum SeekerError: Error, LocalizedError, Sendable {
    case seekerNotFound
    case invalidSeekerData
    case fetchFailed(Error)
    case invalidIdentifier

    public var errorDescription: String? {
        switch self {
        case .seekerNotFound:
            return "Seeker not found"
        case .invalidSeekerData:
            return "Invalid seeker data received"
        case .fetchFailed(let error):
            return "Failed to fetch seeker data: \(error.localizedDescription)"
        case .invalidIdentifier:
            return "Identifier must be a valid leadId or phone number"
        }
    }
}
