// The Swift Programming Language
// https://docs.swift.org/swift-book

import AsyncHTTPClient
import Congregation
import Foundation
import SalesforceClient
@_exported import SalesforceClient

/// A high-level client for church Salesforce integration
///
/// Use this actor to access church-specific Salesforce services and manage congregation data.
/// Designed to work seamlessly with Vapor 4 and Hummingbird server frameworks.
///
/// ## Overview
/// The CongregationKit client provides a simplified interface to Salesforce's APIs
/// specifically designed for church management systems. It handles authentication
/// and provides type-safe access to member data without conflicting with server
/// framework authentication systems.
///
/// ```swift
/// let httpClient = HTTPClient(eventLoopGroupProvider: .shared)
/// let credentials = SalesforceCredentials(
///     clientId: "your_client_id",
///     clientSecret: "your_client_secret",
///     username: "your_username",
///     password: "your_password"
/// )
///
/// let congregation = CongregationKit(httpClient: httpClient, credentials: credentials)
/// let members = try await congregation.members.fetchAll()
/// ```
///
/// ## Topics
/// ### Creating a Client
/// - ``init(httpClient:credentials:)``
/// - ``init(httpClient:authResponse:)``
/// - ``init(httpClient:membersHandler:)``
///
/// ### Available Services
/// - ``members``
public struct CongregationKit: CongregationKitProtocol {

    private let salesforceClient: SalesforceClient
    private let authResponse: SalesforceAuthResponse
    private let membersHandler: MembersHandler
    private let seekersHandler: SeekersHandler

    /// Creates a new CongregationKit client and authenticates with Salesforce
    /// - Parameters:
    ///   - httpClient: The HTTP client to use for making requests
    ///   - credentials: The Salesforce credentials for authentication
    /// - Throws: `SalesforceAuthError` if authentication fails during initialization
    public init(httpClient: HTTPClient, credentials: SalesforceCredentials) async throws {
        self.salesforceClient = SalesforceClient(httpClient: httpClient)
        self.authResponse = try await salesforceClient.auth.authenticate(credentials: credentials)
        self.membersHandler = SalesforceMembersHandler(
            salesforceClient: salesforceClient,
            accessToken: authResponse.accessToken,
            instanceUrl: authResponse.instanceUrl
        )
        self.seekersHandler = SalesforceSeekersHandler(
            salesforceClient: salesforceClient,
            accessToken: authResponse.accessToken,
            instanceUrl: authResponse.instanceUrl
        )
    }

    /// Creates a new CongregationKit client using pre-authenticated data
    /// - Parameters:
    ///   - httpClient: The HTTP client to use for making requests
    ///   - authResponse: The pre-authenticated Salesforce response
    public init(httpClient: HTTPClient, authResponse: SalesforceAuthResponse) {
        self.salesforceClient = SalesforceClient(httpClient: httpClient)
        self.authResponse = authResponse
        self.membersHandler = SalesforceMembersHandler(
            salesforceClient: salesforceClient,
            accessToken: authResponse.accessToken,
            instanceUrl: authResponse.instanceUrl
        )
        self.seekersHandler = SalesforceSeekersHandler(
            salesforceClient: salesforceClient,
            accessToken: authResponse.accessToken,
            instanceUrl: authResponse.instanceUrl
        )
    }

    /// The members handler for member operations
    public var members: MembersHandler {
        return membersHandler
    }

    /// The seekers handler for seeker operations
    public var seekers: SeekersHandler {
        return seekersHandler
    }
}
