import Foundation
import SalesforceClient

/// Protocol for handling member operations
///
/// Provides methods to fetch all members or a specific member by ID, with support for pagination.
public protocol MembersHandler: Sendable {
    /// Fetches all members
    ///
    /// - Returns: Array of church members
    /// - Throws: `MemberError` if operation fails
    @available(*, deprecated, message: "Use paginated fetchAll for better performance.")
    func fetchAll() async throws -> [Member]
    
    /// Fetches a specific member by ID (type-safe, normalized)
    ///
    /// - Parameter memberId: The member ID to fetch (must start with TKT, case-insensitive normalization handled by MemberID)
    /// - Returns: The member if found
    /// - Throws: `MemberError` if operation fails or memberId is invalid
    func fetch(id memberId: MemberID) async throws -> Member
    
    /// Fetches a specific member by ID (deprecated; see note below)
    ///
    /// - Important: As a result of recent backend API changes, this method no longer retrieves a single member by ID. Instead, it returns a list of all members. For accurate single-member retrieval, use the new `fetch(id: MemberID)` method, which provides type safety and proper normalization.
    /// - Parameter memberId: The member ID to fetch (case-insensitive; will be normalized to a 'TKT' prefix if possible)
    /// - Returns: The member if found
    /// - Throws: `MemberError` if the operation fails or the memberId is invalid
    @available(*, deprecated, message: "This method no longer fetches a single member due to backend API changes. Use fetch(id:) with MemberID for correct, type-safe single-member retrieval.")
    func fetch(id memberId: String) async throws -> Member
    
    /// Fetches all members with pagination support
    ///
    /// - Parameters:
    ///   - pageNumber: The page number to fetch (optional, default 1)
    ///   - pageSize: The page size to fetch (optional, default 50)
    /// - Returns: MemberResponse containing members and pagination info
    /// - Throws: `MemberError` if operation fails
    func fetchAll(pageNumber: Int?, pageSize: Int?) async throws -> MemberResponse

    /**
     Fetches all members with pagination support and optional expanded fields.
     - Parameters:
        - pageNumber: The page number to fetch (optional, default 1)
        - pageSize: The page size to fetch (optional, default 50)
        - expanded: An array of `MemberExpand` specifying which related information to expand (e.g., [.employmentInformation, .contactInformation])
     - Returns: MemberResponse containing members and pagination info
     - Throws: `MemberError` if operation fails
     */
    func fetchAll(pageNumber: Int?, pageSize: Int?, expanded: [MemberExpand]) async throws -> MemberResponse

    /**
     Fetches a specific member by ID with optional expanded information (contact and employment).
     - Parameters:
        - memberId: The member ID to fetch. This will be validated automatically (must start with TKT) via the `MemberID` type.
        - expanded: An array of `MemberExpand` specifying which related information to expand (e.g., [.employmentInformation, .contactInformation])
     - Returns: The member if found.
     - Throws: `MemberError` if member not found, fetch fails, or validation fails.
     */
    func fetch(id memberId: MemberID, expanded: [MemberExpand]) async throws -> Member
}

/// Default implementation of MembersHandler for Salesforce
public struct SalesforceMembersHandler: MembersHandler {
    private let salesforceClient: SalesforceClient
    private let accessToken: String
    private let instanceUrl: String
    
    /// Creates a new SalesforceMembersHandler
    ///
    /// - Parameters:
    ///   - salesforceClient: The Salesforce client instance
    ///   - accessToken: The OAuth access token
    ///   - instanceUrl: The Salesforce instance URL
    public init(salesforceClient: SalesforceClient, accessToken: String, instanceUrl: String) {
        self.salesforceClient = salesforceClient
        self.accessToken = accessToken
        self.instanceUrl = instanceUrl
    }
    
    /// Fetches all members (deprecated)
    ///
    /// - Returns: Array of church members
    /// - Throws: `MemberError` if operation fails
    @available(*, deprecated, message: "Use paginated fetchAll for better performance.")
    public func fetchAll() async throws -> [Member] {
        return try await salesforceClient.members.fetchAll(
            accessToken: accessToken,
            instanceUrl: instanceUrl
        )
    }
    
    /// Fetches a specific member by ID (type-safe, normalized)
    ///
    /// - Parameter memberId: The member ID to fetch (must start with TKT, case-insensitive normalization handled by MemberID)
    /// - Returns: The member if found
    /// - Throws: `MemberError` if operation fails or memberId is invalid
    public func fetch(id memberId: MemberID) async throws -> Member {
        return try await salesforceClient.members.fetch(
            memberId: memberId,
            accessToken: accessToken,
            instanceUrl: instanceUrl
        )
    }

    /// Fetches a specific member by ID (deprecated; see note below)
    ///
    /// - Important: As a result of recent backend API changes, this method no longer retrieves a single member by ID. Instead, it returns a list of all members. For accurate single-member retrieval, use the new `fetch(id: MemberID)` method, which provides type safety and proper normalization.
    /// - Parameter memberId: The member ID to fetch (case-insensitive; will be normalized to a 'TKT' prefix if possible)
    /// - Returns: The member if found
    /// - Throws: `MemberError` if the operation fails or the memberId is invalid
    @available(*, deprecated, message: "This method no longer fetches a single member due to backend API changes. Use fetch(id:) with MemberID for correct, type-safe single-member retrieval.")
    public func fetch(id memberId: String) async throws -> Member {
        guard let normalizedMemberID = MemberID(rawValue: memberId) else {
            throw MemberError.invalidMemberID
        }
        return try await fetch(id: normalizedMemberID)
    }
    
    /// Fetches all members with pagination support
    ///
    /// - Parameters:
    ///   - pageNumber: The page number to fetch (optional, default 1)
    ///   - pageSize: The page size to fetch (optional, default 50)
    /// - Returns: MemberResponse containing members and pagination info
    /// - Throws: `MemberError` if operation fails
    public func fetchAll(pageNumber: Int?, pageSize: Int?) async throws -> MemberResponse {
        return try await salesforceClient.members.fetchAll(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            pageNumber: pageNumber,
            pageSize: pageSize
        )
    }

    /**
     Fetches all members with pagination support and optional expanded fields.
     - Parameters:
        - pageNumber: The page number to fetch (optional, default 1)
        - pageSize: The page size to fetch (optional, default 50)
        - expanded: An array of `MemberExpand` specifying which related information to expand (e.g., [.employmentInformation, .contactInformation])
     - Returns: MemberResponse containing members and pagination info
     - Throws: `MemberError` if operation fails
     */
    public func fetchAll(pageNumber: Int?, pageSize: Int?, expanded: [MemberExpand]) async throws -> MemberResponse {
        return try await salesforceClient.members.fetchAll(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            pageNumber: pageNumber,
            pageSize: pageSize,
            expanded: expanded
        )
    }

    /**
     Fetches a specific member by ID with optional expanded information (contact and employment).
     - Parameters:
        - memberId: The member ID to fetch. This will be validated automatically (must start with TKT) via the `MemberID` type.
        - expanded: An array of `MemberExpand` specifying which related information to expand (e.g., [.employmentInformation, .contactInformation])
     - Returns: The member if found.
     - Throws: `MemberError` if member not found, fetch fails, or validation fails.
     */
    public func fetch(id memberId: MemberID, expanded: [MemberExpand]) async throws -> Member {
        return try await salesforceClient.members.fetch(
            memberId: memberId,
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            expanded: expanded
        )
    }
} 