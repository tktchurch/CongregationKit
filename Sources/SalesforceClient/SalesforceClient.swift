import AsyncHTTPClient
import Congregation
import Foundation

/// A client for interacting with the Salesforce API
///
/// Use this actor to access Salesforce's services and manage church member data.
///
/// ## Overview
/// The Salesforce client provides a Swift interface to Salesforce's APIs.
/// It handles authentication and provides type-safe access to various API endpoints.
///
/// ```swift
/// let httpClient = HTTPClient(eventLoopGroupProvider: .shared)
/// let salesforce = SalesforceClient(httpClient: httpClient)
///
/// // Authenticate and fetch members
/// let credentials = SalesforceCredentials(
///     clientId: "your_client_id",
///     clientSecret: "your_client_secret",
///     username: "your_username",
///     password: "your_password"
/// )
///
/// let authResponse = try await salesforce.auth.authenticate(credentials: credentials)
/// let members = try await salesforce.members.fetchAll(
///     accessToken: authResponse.accessToken,
///     instanceUrl: authResponse.instanceUrl
/// )
/// ```
///
/// ## Topics
/// ### Creating a Client
/// - ``init(httpClient:)``
///
/// ### Available Services
/// - ``auth``
/// - ``members``
public actor SalesforceClient {

    /// Routes for Salesforce authentication
    public let auth: any SalesforceAuthRoutes

    /// Routes for Salesforce member management
    public let members: any SalesforceMemberRoutes

    /// Routes for Salesforce seeker management
    public let seekers: any SalesforceSeekerRoutes

    private let handler: SalesforceAPIHandler

    /// Creates a new Salesforce API client.
    /// - Parameter httpClient: The HTTP client to use for making requests
    public init(httpClient: HTTPClient) {
        self.handler = SalesforceAPIHandler(httpClient: httpClient)
        self.auth = SalesforceAuthRoutesImpl(client: handler)
        self.members = SalesforceMemberRoutesImpl(client: handler)
        self.seekers = SalesforceSeekerRoutesImpl(client: handler)
    }
}

// MARK: - Convenience Methods

extension SalesforceClient {
    /// Authenticates with Salesforce and fetches all members in one operation
    /// - Parameter credentials: The Salesforce credentials
    /// - Returns: Array of church members
    /// - Throws: `SalesforceAuthError` or `MemberError` if operation fails
    public func authenticateAndFetchMembers(credentials: SalesforceCredentials) async throws -> [Member] {
        let authResponse = try await auth.authenticate(credentials: credentials)
        return try await members.fetchAll(
            accessToken: authResponse.accessToken,
            instanceUrl: authResponse.instanceUrl
        )
    }

    /// Authenticates with Salesforce and fetches a specific member
    /// - Parameters:
    ///   - credentials: The Salesforce credentials
    ///   - memberId: The member ID to fetch
    /// - Returns: The member if found
    /// - Throws: `SalesforceAuthError` or `MemberError` if operation fails
    public func authenticateAndFetchMember(credentials: SalesforceCredentials, memberId: String) async throws -> Member {
        let authResponse = try await auth.authenticate(credentials: credentials)
        return try await members.fetch(
            memberId: memberId,
            accessToken: authResponse.accessToken,
            instanceUrl: authResponse.instanceUrl
        )
    }
}
