import Congregation
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

    /// Fetches all seekers with pagination support (cursor-based, supports nextPageToken)
    /// - Parameters:
    ///   - pageNumber: The page number to fetch (optional, default 1)
    ///   - pageSize: The page size to fetch (optional, default 50)
    ///   - nextPageToken: The next page token for cursor-based pagination (optional)
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
        nextPageToken: String?,
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

    /// Creates a new seeker in Salesforce
    /// - Parameter seeker: The seeker to create
    /// - Returns: SeekerResponse containing the created seeker
    /// - Throws: `SeekerError` if operation fails
    func create(_ seeker: Seeker) async throws -> SeekerResponse

    // MARK: - v2 Sync API (preferred)

    /// Lists seekers using TKT API v2 cursor pagination and optional filters.
    func fetchAll(query: SyncQuery, filters: SeekerListQuery?) async throws -> SyncPage<Seeker>

    /// Fetches a single seeker via v2.
    func fetch(id: String, query: SyncQuery?) async throws -> Seeker

    /// Creates a seeker via v2 with optional write headers.
    func create(_ seeker: Seeker, options: SyncWriteOptions?) async throws -> Seeker

    /// Salesforce Field History plus Path for one seeker (`GET /v2/seekers/{id}/history`).
    func listHistory(id: String) async throws -> SeekerHistoryPage

    /// Advances `Lead_status__c` to the next Path stage (`POST /v2/seekers/{id}:completeLeadStatus`).
    func completeLeadStatus(id: String, options: SyncWriteOptions?) async throws -> Seeker

    /// Patches seeker fields via v2 (`PATCH /v2/seekers/{id}`).
    func update(id: String, body: [String: String], options: SyncWriteOptions?) async throws -> Seeker
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

    /// Fetches all seekers with pagination support (cursor-based, supports nextPageToken)
    public func fetchAll(
        pageNumber: Int? = nil,
        pageSize: Int? = nil,
        nextPageToken: String? = nil,
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
            nextPageToken: nextPageToken,
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

    /// Creates a new seeker in Salesforce
    /// - Parameter seeker: The seeker to create
    /// - Returns: SeekerResponse containing the created seeker
    /// - Throws: `SeekerError` if operation fails
    public func create(_ seeker: Seeker) async throws -> SeekerResponse {
        return try await salesforceClient.seekers.create(
            seeker,
            accessToken: accessToken,
            instanceUrl: instanceUrl
        )
    }

    public func fetchAll(query: SyncQuery, filters: SeekerListQuery?) async throws -> SyncPage<Seeker> {
        do {
            return try await salesforceClient.v2.listSeekers(
                accessToken: accessToken,
                instanceUrl: instanceUrl,
                query: query,
                filters: filters
            )
        } catch let error as SyncError {
            throw SeekerError.fetchFailed(error)
        }
    }

    public func fetch(id: String, query: SyncQuery?) async throws -> Seeker {
        do {
            return try await salesforceClient.v2.getSeeker(
                accessToken: accessToken,
                instanceUrl: instanceUrl,
                seekerId: id,
                query: query
            )
        } catch let error as SyncError {
            throw SeekerError.fetchFailed(error)
        }
    }

    public func create(_ seeker: Seeker, options: SyncWriteOptions?) async throws -> Seeker {
        do {
            return try await salesforceClient.v2.createSeeker(
                accessToken: accessToken,
                instanceUrl: instanceUrl,
                seeker: seeker,
                options: options
            )
        } catch let error as SyncError {
            throw SeekerError.fetchFailed(error)
        }
    }

    public func listHistory(id: String) async throws -> SeekerHistoryPage {
        do {
            return try await salesforceClient.v2.listSeekerHistory(
                accessToken: accessToken,
                instanceUrl: instanceUrl,
                seekerId: id
            )
        } catch let error as SyncError {
            throw SeekerError.fetchFailed(error)
        }
    }

    public func completeLeadStatus(id: String, options: SyncWriteOptions?) async throws -> Seeker {
        do {
            return try await salesforceClient.v2.completeLeadStatus(
                accessToken: accessToken,
                instanceUrl: instanceUrl,
                seekerId: id,
                options: options
            )
        } catch let error as SyncError {
            throw SeekerError.fetchFailed(error)
        }
    }

    public func update(
        id: String,
        body: [String: String],
        options: SyncWriteOptions?
    ) async throws -> Seeker {
        do {
            return try await salesforceClient.v2.updateSeeker(
                accessToken: accessToken,
                instanceUrl: instanceUrl,
                seekerId: id,
                body: body,
                options: options
            )
        } catch let error as SyncError {
            throw SeekerError.fetchFailed(error)
        }
    }
}
