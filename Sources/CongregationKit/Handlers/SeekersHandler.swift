import Foundation
import SalesforceClient

/// Protocol for handling seeker operations
///
/// Provides methods to fetch all seekers or a specific seeker by identifier, with support for pagination and filtering.
public protocol SeekersHandler: Sendable {
    /// Fetches all seekers with pagination and optional filters
    /// - Parameters:
    ///   - pageNumber: The page number to fetch (optional, default 1)
    ///   - pageSize: The page size to fetch (optional, default 50)
    ///   - seekerId: Filter by seeker ID (optional)
    ///   - name: Filter by name (optional)
    ///   - campus: Filter by campus (optional, type-safe)
    ///   - leadStatus: Filter by lead status (optional, type-safe)
    ///   - email: Filter by email (optional)
    ///   - leadId: Filter by lead ID (optional)
    ///   - contactNumber: Filter by contact number (optional)
    /// - Returns: SeekerResponse containing seekers and pagination info
    /// - Throws: `SeekerError` if operation fails
    func fetchAll(
        pageNumber: Int?,
        pageSize: Int?,
        seekerId: String?,
        name: String?,
        campus: Campus?,
        leadStatus: LeadStatus?,
        email: String?,
        leadId: String?,
        contactNumber: String?
    ) async throws -> SeekerResponse

    /// Fetches a specific seeker by identifier (leadId or phone, case-insensitive)
    /// - Parameters:
    ///   - identifier: The identifier to fetch (leadId or phone)
    /// - Returns: The seeker if found
    /// - Throws: `SeekerError` if operation fails
    func fetch(identifier: String) async throws -> Seeker

    /// Fetches all seekers (non-paginated)
    /// - Returns: Array of seekers
    /// - Throws: `SeekerError` if operation fails
    func fetchAll() async throws -> [Seeker]
}

/// Default implementation of SeekersHandler for Salesforce
///
/// Handles all seeker-related operations using the Salesforce API.
public struct SalesforceSeekersHandler: SeekersHandler {
    private let salesforceClient: SalesforceClient
    private let accessToken: String
    private let instanceUrl: String

    /// Creates a new SalesforceSeekersHandler
    /// - Parameters:
    ///   - salesforceClient: The Salesforce client instance
    ///   - accessToken: The OAuth access token
    ///   - instanceUrl: The Salesforce instance URL
    public init(salesforceClient: SalesforceClient, accessToken: String, instanceUrl: String) {
        self.salesforceClient = salesforceClient
        self.accessToken = accessToken
        self.instanceUrl = instanceUrl
    }

    /// Fetches all seekers with pagination and optional filters
    public func fetchAll(
        pageNumber: Int? = nil,
        pageSize: Int? = nil,
        seekerId: String? = nil,
        name: String? = nil,
        campus: Campus? = nil,
        leadStatus: LeadStatus? = nil,
        email: String? = nil,
        leadId: String? = nil,
        contactNumber: String? = nil
    ) async throws -> SeekerResponse {
        return try await salesforceClient.seekers.fetchAll(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            pageNumber: pageNumber,
            pageSize: pageSize,
            seekerId: seekerId,
            name: name,
            campus: campus,
            leadStatus: leadStatus,
            email: email,
            leadId: leadId,
            contactNumber: contactNumber
        )
    }

    /// Fetches a specific seeker by identifier (leadId or phone, case-insensitive)
    public func fetch(identifier: String) async throws -> Seeker {
        return try await salesforceClient.seekers.fetch(
            identifier: identifier,
            accessToken: accessToken,
            instanceUrl: instanceUrl
        )
    }

    /// Fetches all seekers (non-paginated)
    /// - Returns: Array of seekers
    /// - Throws: `SeekerError` if operation fails
    public func fetchAll() async throws -> [Seeker] {
        return try await salesforceClient.seekers.fetchAll(
            accessToken: accessToken,
            instanceUrl: instanceUrl
        )
    }
}
