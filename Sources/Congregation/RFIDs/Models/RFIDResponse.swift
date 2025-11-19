import Foundation

/// Response wrapper for RFID data from the API.
///
/// This struct provides a standardized response format for RFID-related
/// API calls, including pagination metadata and status information.
public struct RFIDResponse: Codable, Equatable, Sendable {
    /// List of RFIDs returned.
    public let rfids: [RFID]

    /// Response message from the server.
    public let message: String?

    /// Pagination and metadata information.
    public let metadata: RFIDResponseMetadata?

    /// Creates a new RFIDResponse instance.
    ///
    /// - Parameters:
    ///   - rfids: Array of RFIDs
    ///   - message: Response message
    ///   - metadata: Pagination metadata
    public init(
        rfids: [RFID],
        message: String? = nil,
        metadata: RFIDResponseMetadata? = nil
    ) {
        self.rfids = rfids
        self.message = message
        self.metadata = metadata
    }
}

/// Metadata for RFID response pagination.
public struct RFIDResponseMetadata: Codable, Equatable, Sendable {
    /// Total number of RFIDs available.
    public let total: Int

    /// Current page number.
    public let page: Int

    /// Number of items per page.
    public let pageSize: Int

    /// Total number of pages.
    public var totalPages: Int {
        guard pageSize > 0 else { return 0 }
        return (total + pageSize - 1) / pageSize
    }

    /// Whether there is a next page.
    public var hasNextPage: Bool {
        page < totalPages
    }

    /// Whether there is a previous page.
    public var hasPreviousPage: Bool {
        page > 1
    }

    /// Creates a new RFIDResponseMetadata instance.
    ///
    /// - Parameters:
    ///   - total: Total number of RFIDs
    ///   - page: Current page number
    ///   - pageSize: Number of items per page
    public init(total: Int, page: Int, pageSize: Int) {
        self.total = total
        self.page = page
        self.pageSize = pageSize
    }
}
