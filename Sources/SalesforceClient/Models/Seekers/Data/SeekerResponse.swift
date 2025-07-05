import Foundation

/// Response wrapper for seeker data from API, supporting both paginated and non-paginated responses
public struct SeekerResponse: Codable, Sendable {
    /// Array of seekers returned from the API
    public let seekers: [Seeker]
    /// Optional data container for paginated responses
    public let data: DataContainer?
    /// Optional error flag
    public let error: Bool?
    /// Optional error message
    public let message: String?

    public struct DataContainer: Codable, Sendable {
        public let items: [Seeker]
        public let metadata: Metadata
    }

    public struct Metadata: Codable, Sendable {
        public let per: Int
        public let total: Int
        public let page: Int
    }

    // Success initializer for non-paginated response
    public init(seekers: [Seeker]) {
        self.seekers = seekers
        self.data = nil
        self.error = nil
        self.message = nil
    }

    enum CodingKeys: String, CodingKey {
        case seekers = "seeker" // Legacy key
        case data
        case error
        case message
        // API keys for paginated response
        case items = "seekers"
        case totalRecords
        case pageSize
        case pageNumber
        case success
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Check for error response
        if let success = try? container.decodeIfPresent(Bool.self, forKey: .success), success == false {
            self.seekers = []
            self.data = nil
            self.error = true
            self.message = try? container.decodeIfPresent(String.self, forKey: .message)
            return
        }
        self.error = nil
        self.message = nil
        // Try decoding paginated response
        if let seekers = try? container.decodeIfPresent([Seeker].self, forKey: .items) {
            let per = (try? container.decodeIfPresent(Int.self, forKey: .pageSize)) ?? seekers.count
            let total = (try? container.decodeIfPresent(Int.self, forKey: .totalRecords)) ?? seekers.count
            let page = (try? container.decodeIfPresent(Int.self, forKey: .pageNumber)) ?? 1
            self.seekers = seekers
            self.data = DataContainer(items: seekers, metadata: Metadata(per: per, total: total, page: page))
        }
        // Fall back to legacy non-paginated response ("seeker")
        else if let seekers = try? container.decodeIfPresent([Seeker].self, forKey: .seekers) {
            self.seekers = seekers
            self.data = nil
        } else {
            self.seekers = []
            self.data = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // Encode paginated response
        if let data = data {
            try container.encode(data, forKey: .data)
        }
        // Encode non-paginated response
        else {
            try container.encode(seekers, forKey: .seekers)
        }
        if let error = error {
            try container.encode(error, forKey: .error)
            try container.encode(false, forKey: .success)
        }
        if let message = message {
            try container.encode(message, forKey: .message)
        }
    }
}

extension SeekerResponse {
    // Convenience initializer for paginated response
    public init(seekers: [Seeker], per: Int, total: Int, page: Int) {
        self.seekers = seekers
        self.data = DataContainer(items: seekers, metadata: Metadata(per: per, total: total, page: page))
        self.error = nil
        self.message = nil
    }

    // Convenience initializer for error response
    public init(errorMessage: String) {
        self.seekers = []
        self.data = nil
        self.error = true
        self.message = errorMessage
    }

    // Helper to check if response is paginated
    public var isPaginated: Bool {
        return data != nil
    }

    // Helper to access pagination info safely
    public var paginationInfo: (per: Int, total: Int, page: Int)? {
        guard let data = data else { return nil }
        return (data.metadata.per, data.metadata.total, data.metadata.page)
    }
}