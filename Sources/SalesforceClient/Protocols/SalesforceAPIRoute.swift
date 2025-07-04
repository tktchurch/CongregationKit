import Foundation
import NIOHTTP1
import AsyncHTTPClient

/// Base protocol for all Salesforce API routes
public protocol SalesforceAPIRoute: Sendable {
    /// The HTTP headers for the request
    var headers: HTTPHeaders { get set }
}

/// Protocol for Salesforce authentication routes
public protocol SalesforceAuthRoutes: SalesforceAPIRoute {
    /// Authenticates with Salesforce using OAuth 2.0 password flow
    /// - Parameter credentials: The Salesforce credentials
    /// - Returns: Authentication response containing access token and instance URL
    /// - Throws: `SalesforceAuthError` if authentication fails
    func authenticate(credentials: SalesforceCredentials) async throws -> SalesforceAuthResponse
}

/// Enum specifying which related information to expand for a member fetch.
public enum MemberExpand: String, Codable, Sendable {
    /// Expand employment information
    case employmentInformation
    /// Expand contact information
    case contactInformation
    /// Expand martial information
    case martialInformation
    /// Expand discipleship and spiritual information
    case discipleshipInformation
}

/// Protocol for Salesforce member routes
public protocol SalesforceMemberRoutes: SalesforceAPIRoute {
    /// Fetches all members from Salesforce (backward compatible, returns all members, not paginated)
    /// - Parameter accessToken: The OAuth access token
    /// - Parameter instanceUrl: The Salesforce instance URL
    /// - Returns: Array of church members
    /// - Throws: `MemberError` if fetch fails
    @available(*, deprecated, message: "Use fetchAll(accessToken:instanceUrl:pageNumber:pageSize:) for paginated results.")
    func fetchAll(accessToken: String, instanceUrl: String) async throws -> [Member]
    
    /// Fetches all members from Salesforce with pagination support
    /// - Parameters:
    ///   - accessToken: The OAuth access token
    ///   - instanceUrl: The Salesforce instance URL
    ///   - pageNumber: The page number to fetch (optional, default 1)
    ///   - pageSize: The page size to fetch (optional, default 50)
    /// - Returns: MemberResponse containing members and pagination info
    /// - Throws: `MemberError` if fetch fails
    func fetchAll(accessToken: String, instanceUrl: String, pageNumber: Int?, pageSize: Int?) async throws -> MemberResponse
    
    /// Fetches a specific member by ID (deprecated, use fetch(validatedMemberId:...))
    /// - Parameters:
    ///   - memberId: The member ID to fetch
    ///   - accessToken: The OAuth access token
    ///   - instanceUrl: The Salesforce instance URL
    /// - Returns: The member if found
    /// - Throws: `MemberError` if member not found or fetch fails
    @available(*, deprecated, message: "Use fetch(memberId:accessToken:instanceUrl:) with MemberID for automatic validation.")
    func fetch(memberId: String, accessToken: String, instanceUrl: String) async throws -> Member

    /**
     Fetches a specific member by ID (must start with TKT).
     - Parameters:
        - memberId: The member ID to fetch. This will be validated automatically (must start with TKT) via the `MemberID` type.
        - accessToken: The OAuth access token.
        - instanceUrl: The Salesforce instance URL.
     - Returns: The member if found.
     - Throws: `MemberError` if member not found, fetch fails, or validation fails.
     */
    func fetch(memberId: MemberID, accessToken: String, instanceUrl: String) async throws -> Member

    /**
     Fetches all members from Salesforce with optional expanded information (contact and employment).
     - Parameters:
        - accessToken: The OAuth access token
        - instanceUrl: The Salesforce instance URL
        - pageNumber: The page number to fetch (optional, default 1)
        - pageSize: The page size to fetch (optional, default 50)
        - expanded: An array of `MemberExpand` specifying which related information to expand (e.g., [.employmentInformation, .contactInformation])
     - Returns: MemberResponse containing members and pagination info
     - Throws: `MemberError` if fetch fails
     */
    func fetchAll(accessToken: String, instanceUrl: String, pageNumber: Int?, pageSize: Int?, expanded: [MemberExpand]) async throws -> MemberResponse

    /**
     Fetches a specific member by ID with optional expanded information (contact and employment).
     - Parameters:
        - memberId: The member ID to fetch. This will be validated automatically (must start with TKT) via the `MemberID` type.
        - accessToken: The OAuth access token.
        - instanceUrl: The Salesforce instance URL.
        - expanded: An array of `MemberExpand` specifying which related information to expand (e.g., [.employmentInformation, .contactInformation])
     - Returns: The member if found.
     - Throws: `MemberError` if member not found, fetch fails, or validation fails.
     */
    func fetch(memberId: MemberID, accessToken: String, instanceUrl: String, expanded: [MemberExpand]) async throws -> Member
} 
