import AsyncHTTPClient
import Foundation
import NIOHTTP1

/// Implementation of Salesforce member routes
public struct SalesforceMemberRoutesImpl: SalesforceMemberRoutes {
    public var headers: HTTPHeaders = [:]
    private let client: SalesforceAPIHandler

    init(client: SalesforceAPIHandler) {
        self.client = client
    }

    /// Fetches all members from Salesforce (backward compatible, returns all members, not paginated)
    /// - Parameters:
    ///   - accessToken: The OAuth access token
    ///   - instanceUrl: The Salesforce instance URL
    /// - Returns: Array of church members
    /// - Throws: `MemberError` if fetch fails
    @available(*, deprecated, message: "Use fetchAll(accessToken:instanceUrl:pageNumber:pageSize:) for paginated results.")
    public func fetchAll(accessToken: String, instanceUrl: String) async throws -> [Member] {
        let memberURL = "\(instanceUrl)\(SalesforceAPIConstants.memberEndpoint)"

        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
        ])

        let response = try await client.sendRequest(
            method: .GET,
            path: memberURL,
            headers: requestHeaders
        )

        let memberResponse = try await client.processResponse(response, as: MemberResponse.self)
        return memberResponse.members
    }

    /// Deprecated: Use the new fetchAll with nextPageToken for cursor-based pagination.
    @available(*, deprecated, message: "Use fetchAll(accessToken:instanceUrl:pageNumber:pageSize:nextPageToken:) for cursor-based pagination.")
    public func fetchAll(accessToken: String, instanceUrl: String, pageNumber: Int? = nil, pageSize: Int? = nil) async throws -> MemberResponse {
        return try await fetchAll(accessToken: accessToken, instanceUrl: instanceUrl, pageNumber: pageNumber, pageSize: pageSize, nextPageToken: nil)
    }

    /// Fetches all members from Salesforce with pagination support (v2 endpoint).
    ///
    /// - Parameters:
    ///   - accessToken: The OAuth access token.
    ///   - instanceUrl: The Salesforce instance URL.
    ///   - pageNumber: The page number to fetch (optional, default 1).
    ///   - pageSize: The page size to fetch (optional, default 50).
    ///   - nextPageToken: The next page token for cursor-based pagination (optional).
    /// - Returns: MemberResponse containing members and pagination info.
    /// - Throws: `MemberError` if fetch fails.
    public func fetchAll(accessToken: String, instanceUrl: String, pageNumber: Int? = nil, pageSize: Int? = nil, nextPageToken: String? = nil) async throws -> MemberResponse {
        let size = pageSize ?? 50
        var queryParams: [String: String] = ["pageSize": String(size)]
        if let token = nextPageToken {
            queryParams["nextPageToken"] = token
        }
        let memberURL = "\(instanceUrl)\(SalesforceAPIConstants.memberEndpointV2)"
        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
        ])
        // If pageNumber is 1 or not provided, just fetch the first page
        if nextPageToken == nil && (pageNumber == nil || pageNumber == 1) {
            let response = try await client.sendRequest(
                method: .GET,
                path: memberURL,
                queryParams: queryParams,
                headers: requestHeaders
            )
            return try await client.processResponse(response, as: MemberResponse.self)
        }
        // If nextPageToken is provided, fetch that page
        if let token = nextPageToken {
            let response = try await client.sendRequest(
                method: .GET,
                path: memberURL,
                queryParams: queryParams,
                headers: requestHeaders
            )
            return try await client.processResponse(response, as: MemberResponse.self)
        }
        // If pageNumber > 1, walk tokens from the start
        var currentToken: String? = nil
        var currentPage = 1
        var lastResponse: MemberResponse? = nil
        while currentPage < (pageNumber ?? 1) {
            let pageQueryParams: [String: String] = {
                var qp = ["pageSize": String(size)]
                if let t = currentToken { qp["nextPageToken"] = t }
                return qp
            }()
            let response = try await client.sendRequest(
                method: .GET,
                path: memberURL,
                queryParams: pageQueryParams,
                headers: requestHeaders
            )
            let decoded = try await client.processResponse(response, as: MemberResponse.self)
            guard let nextToken = decoded.metadata?.nextPageToken, !decoded.members.isEmpty else {
                return decoded // End of data or error
            }
            currentToken = nextToken
            lastResponse = decoded
            currentPage += 1
        }
        // Fetch the desired page
        let finalQueryParams: [String: String] = {
            var qp = ["pageSize": String(size)]
            if let t = currentToken { qp["nextPageToken"] = t }
            return qp
        }()
        let finalResponse = try await client.sendRequest(
            method: .GET,
            path: memberURL,
            queryParams: finalQueryParams,
            headers: requestHeaders
        )
        return try await client.processResponse(finalResponse, as: MemberResponse.self)
    }

    public func fetch(accessToken: String, instanceUrl: String) async throws -> MemberResponse {
        let memberURL = "\(instanceUrl)\(SalesforceAPIConstants.memberEndpointV2)"  // v2 endpoint
        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
        ])
        let response = try await client.sendRequest(
            method: .GET,
            path: memberURL,
            headers: requestHeaders
        )
        let memberResponse = try await client.processResponse(response, as: MemberResponse.self)
        return memberResponse
    }

    @available(*, deprecated, message: "Use fetch(validatedMemberId:accessToken:instanceUrl:) for validated member ID.")
    public func fetch(memberId: String, accessToken: String, instanceUrl: String) async throws -> Member {
        let memberURL = "\(instanceUrl)\(SalesforceAPIConstants.memberEndpoint)/\(memberId)"

        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
        ])

        let response = try await client.sendRequest(
            method: .GET,
            path: memberURL,
            headers: requestHeaders
        )

        // For single member, we expect the response to be wrapped in a member array
        let memberResponse = try await client.processResponse(response, as: MemberResponse.self)

        guard let member = memberResponse.members.first else {
            throw MemberError.memberNotFound
        }

        return member
    }

    /// Fetches a specific member by ID (must start with TKT, v2 endpoint)
    public func fetch(memberId: MemberID, accessToken: String, instanceUrl: String) async throws -> Member {
        let memberURL = "\(instanceUrl)\(SalesforceAPIConstants.memberEndpointV2)/\(memberId.rawValue)"  // v2 endpoint
        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
        ])
        let response = try await client.sendRequest(
            method: .GET,
            path: memberURL,
            headers: requestHeaders
        )
        let memberResponse = try await client.processResponse(response, as: MemberResponse.self)
        guard let member = memberResponse.members.first else {
            throw MemberError.memberNotFound
        }
        return member
    }

    /// Fetches all members from Salesforce with pagination support and optional expanded fields.
    public func fetchAll(accessToken: String, instanceUrl: String, pageNumber: Int?, pageSize: Int?, expanded: [MemberExpand]) async throws
        -> MemberResponse
    {
        let response = try await fetchAll(accessToken: accessToken, instanceUrl: instanceUrl, pageNumber: pageNumber, pageSize: pageSize)
        let expandedSet = Set(expanded)
        let filteredMembers = response.members.map { $0.withFilteredFields(expanded: expandedSet) }
        return MemberResponse(members: filteredMembers)
    }

    /// Fetches a specific member by ID with optional expanded fields.
    public func fetch(memberId: MemberID, accessToken: String, instanceUrl: String, expanded: [MemberExpand]) async throws -> Member {
        let member = try await fetch(memberId: memberId, accessToken: accessToken, instanceUrl: instanceUrl)
        let expandedSet = Set(expanded)
        return member.withFilteredFields(expanded: expandedSet)
    }
}
