import Foundation

/// Response wrapper for family data from the API.
///
/// This struct provides a standardized response format for family-related
/// API calls, including pagination metadata and status information.
public struct FamilyResponse: Codable, Equatable, Sendable {
    /// List of families returned.
    public let families: [Family]

    /// Response message from the server.
    public let message: String?

    /// Pagination and metadata information.
    public let metadata: FamilyResponseMetadata?

    /// Creates a new FamilyResponse instance.
    ///
    /// - Parameters:
    ///   - families: Array of families
    ///   - message: Response message
    ///   - metadata: Pagination metadata
    public init(
        families: [Family],
        message: String? = nil,
        metadata: FamilyResponseMetadata? = nil
    ) {
        self.families = families
        self.message = message
        self.metadata = metadata
    }
}

/// Metadata for family response pagination.
public struct FamilyResponseMetadata: Codable, Equatable, Sendable {
    /// Total number of families available.
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

    /// Creates a new FamilyResponseMetadata instance.
    ///
    /// - Parameters:
    ///   - total: Total number of families
    ///   - page: Current page number
    ///   - pageSize: Number of items per page
    public init(total: Int, page: Int, pageSize: Int) {
        self.total = total
        self.page = page
        self.pageSize = pageSize
    }
}
