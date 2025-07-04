import Foundation

/// Response wrapper for member data from Salesforce, supporting both paginated and non-paginated responses
public struct MemberResponse: Codable, Sendable {
    /// Array of members returned from the API
    public let members: [Member]
    /// Optional data container for paginated responses
    public let data: DataContainer?
    /// Optional error flag
    public let error: Bool?
    /// Optional error message
    public let message: String?

    public struct DataContainer: Codable, Sendable {
        public let items: [Member]
        public let metadata: Metadata
    }

    public struct Metadata: Codable, Sendable {
        public let per: Int
        public let total: Int
        public let page: Int
    }

    // Success initializer for non-paginated response
    public init(members: [Member]) {
        self.members = members
        self.data = nil
        self.error = nil
        self.message = nil
    }

    enum CodingKeys: String, CodingKey {
        case members = "member" // Legacy key
        case data
        case error
        case message
        // Salesforce API keys for paginated response
        case items = "members"
        case totalRecords
        case pageSize
        case pageNumber
        case success
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Check for error response
        if let success = try? container.decodeIfPresent(Bool.self, forKey: .success), success == false {
            self.members = []
            self.data = nil
            self.error = true
            self.message = try? container.decodeIfPresent(String.self, forKey: .message)
            return
        }
        self.error = nil
        self.message = nil // <-- Only set message for error, not for success
        // Try decoding paginated response (flat Salesforce API format)
        if let members = try? container.decodeIfPresent([Member].self, forKey: .items) {
            let per = (try? container.decodeIfPresent(Int.self, forKey: .pageSize)) ?? members.count
            let total = (try? container.decodeIfPresent(Int.self, forKey: .totalRecords)) ?? members.count
            let page = (try? container.decodeIfPresent(Int.self, forKey: .pageNumber)) ?? 1
            self.members = members
            self.data = DataContainer(items: members, metadata: Metadata(per: per, total: total, page: page))
        }
        // Fall back to legacy non-paginated response ("member")
        else if let members = try? container.decodeIfPresent([Member].self, forKey: .members) {
            self.members = members
            self.data = nil
        } else {
            self.members = []
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
            try container.encode(members, forKey: .members)
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

extension MemberResponse {
    // Convenience initializer for paginated response
    public init(members: [Member], per: Int, total: Int, page: Int) {
        self.members = members
        self.data = DataContainer(items: members, metadata: Metadata(per: per, total: total, page: page))
        self.error = nil
        self.message = nil
    }

    // Convenience initializer for error response
    public init(errorMessage: String) {
        self.members = []
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