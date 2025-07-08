import AsyncHTTPClient
import Foundation
import NIOHTTP1

/// Implementation of Salesforce seeker routes
public struct SalesforceSeekerRoutesImpl: SalesforceSeekerRoutes {
    
    public var headers: HTTPHeaders = [:]
    private let client: SalesforceAPIHandler

    init(client: SalesforceAPIHandler) {
        self.client = client
    }

    /**
     Fetches a paginated list of seekers from Salesforce with full filtering and cursor-based pagination support.
     - Parameters:
        - accessToken: The OAuth access token.
        - instanceUrl: The Salesforce instance URL.
        - pageNumber: The page number to fetch (optional, default 1).
        - pageSize: The page size to fetch (optional, default 50).
        - nextPageToken: The next page token for cursor-based pagination (optional).
        - seekerId: Filter by seeker ID (optional).
        - name: Filter by name (optional).
        - campus: Filter by campus (optional).
        - leadStatus: Filter by lead status (optional).
        - email: Filter by email (optional).
        - leadId: Filter by lead ID (optional).
        - contactNumber: Filter by contact number (optional).
     - Returns: SeekerResponse containing seekers and pagination info.
     - Throws: `SeekerError` if fetch fails.
     */
    private func fetchAllImpl(
        accessToken: String,
        instanceUrl: String,
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
    ) async throws -> SeekerResponse {
        let size = pageSize ?? 50
        var queryParams: [String: String] = ["pageSize": String(size)]
        if let token = nextPageToken { queryParams["nextPageToken"] = token }
        if let seekerId = seekerId { queryParams["seekerId"] = seekerId }
        if let name = name { queryParams["name"] = name }
        if let campus = campus { queryParams["campus"] = campus.rawValue }
        if let leadStatus = leadStatus { queryParams["leadStatus"] = leadStatus.rawValue }
        if let email = email { queryParams["email"] = email }
        if let leadId = leadId { queryParams["leadId"] = leadId }
        if let contactNumber = contactNumber { queryParams["contactNumber"] = contactNumber }
        let seekerURL = "\(instanceUrl)\(SalesforceAPIConstants.seekerEndpointV2)"
        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
        ])
        // If pageNumber is 1 or not provided, just fetch the first page
        if nextPageToken == nil && (pageNumber == nil || pageNumber == 1) {
            let response = try await client.sendRequest(
                method: .GET,
                path: seekerURL,
                queryParams: queryParams,
                headers: requestHeaders
            )
            return try await client.processResponse(response, as: SeekerResponse.self)
        }
        // If nextPageToken is provided, fetch that page
        if let token = nextPageToken {
            let response = try await client.sendRequest(
                method: .GET,
                path: seekerURL,
                queryParams: queryParams,
                headers: requestHeaders
            )
            return try await client.processResponse(response, as: SeekerResponse.self)
        }
        // If pageNumber > 1, walk tokens from the start
        var currentToken: String? = nil
        var currentPage = 1
        var lastResponse: SeekerResponse? = nil
        while currentPage < (pageNumber ?? 1) {
            let pageQueryParams: [String: String] = {
                var qp = ["pageSize": String(size)]
                if let t = currentToken { qp["nextPageToken"] = t }
                if let seekerId = seekerId { qp["seekerId"] = seekerId }
                if let name = name { qp["name"] = name }
                if let campus = campus { qp["campus"] = campus.rawValue }
                if let leadStatus = leadStatus { qp["leadStatus"] = leadStatus.rawValue }
                if let email = email { qp["email"] = email }
                if let leadId = leadId { qp["leadId"] = leadId }
                if let contactNumber = contactNumber { qp["contactNumber"] = contactNumber }
                return qp
            }()
            let response = try await client.sendRequest(
                method: .GET,
                path: seekerURL,
                queryParams: pageQueryParams,
                headers: requestHeaders
            )
            let decoded = try await client.processResponse(response, as: SeekerResponse.self)
            guard let nextToken = decoded.metadata?.nextPageToken, !decoded.seekers.isEmpty else {
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
            if let seekerId = seekerId { qp["seekerId"] = seekerId }
            if let name = name { qp["name"] = name }
            if let campus = campus { qp["campus"] = campus.rawValue }
            if let leadStatus = leadStatus { qp["leadStatus"] = leadStatus.rawValue }
            if let email = email { qp["email"] = email }
            if let leadId = leadId { qp["leadId"] = leadId }
            if let contactNumber = contactNumber { qp["contactNumber"] = contactNumber }
            return qp
        }()
        let finalResponse = try await client.sendRequest(
            method: .GET,
            path: seekerURL,
            queryParams: finalQueryParams,
            headers: requestHeaders
        )
        return try await client.processResponse(finalResponse, as: SeekerResponse.self)
    }

    /// Fetches a paginated list of seekers from Salesforce (v2 endpoint, no filters).
    /// - Parameters:
    ///   - accessToken: The OAuth access token.
    ///   - instanceUrl: The Salesforce instance URL.
    /// - Returns: SeekerResponse containing seekers and pagination info.
    /// - Throws: `SeekerError` if fetch fails.
    public func fetch(accessToken: String, instanceUrl: String) async throws -> SeekerResponse {
        let seekerURL = "\(instanceUrl)\(SalesforceAPIConstants.seekerEndpointV2)"
        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
        ])
        let response = try await client.sendRequest(
            method: .GET,
            path: seekerURL,
            headers: requestHeaders
        )
        let seekerResponse = try await client.processResponse(response, as: SeekerResponse.self)
        return seekerResponse
    }

    /// Fetches all seekers with filtering.
    /// - Parameters: See `fetchAllImpl`.
    /// - Returns: SeekerResponse containing seekers and pagination info.
    /// - Throws: `SeekerError` if fetch fails.
    public func fetchAll(
        accessToken: String,
        instanceUrl: String,
        pageNumber: Int?,
        pageSize: Int?,
        seekerId: String?,
        name: String?,
        campus: Campus?,
        leadStatus: LeadStatus?,
        email: String?,
        leadId: String?,
        contactNumber: String?
    ) async throws -> SeekerResponse {
        return try await fetchAllImpl(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            pageNumber: pageNumber,
            pageSize: pageSize,
            nextPageToken: nil,
            seekerId: seekerId,
            name: name,
            campus: campus,
            leadStatus: leadStatus,
            email: email,
            leadId: leadId,
            contactNumber: contactNumber
        )
    }

    /// Fetches all seekers with cursor-based pagination.
    /// - Parameters: See `fetchAllImpl`.
    /// - Returns: SeekerResponse containing seekers and pagination info.
    /// - Throws: `SeekerError` if fetch fails.
    public func fetchAll(
        accessToken: String,
        instanceUrl: String,
        pageNumber: Int?,
        pageSize: Int?,
        nextPageToken: String?
    ) async throws -> SeekerResponse {
        return try await fetchAllImpl(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            pageNumber: pageNumber,
            pageSize: pageSize,
            nextPageToken: nextPageToken,
            seekerId: nil,
            name: nil,
            campus: nil,
            leadStatus: nil,
            email: nil,
            leadId: nil,
            contactNumber: nil
        )
    }

    /// Fetches all seekers with cursor-based pagination and filtering.
    /// - Parameters: See `fetchAllImpl`.
    /// - Returns: SeekerResponse containing seekers and pagination info.
    /// - Throws: `SeekerError` if fetch fails.
    public func fetchAll(
        accessToken: String,
        instanceUrl: String,
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
    ) async throws -> SeekerResponse {
        return try await fetchAllImpl(
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

    /// Deprecated: Use the new fetchAll with nextPageToken for cursor-based pagination.
    /// - Parameters: See `fetchAllImpl`.
    /// - Returns: SeekerResponse containing seekers and pagination info.
    /// - Throws: `SeekerError` if fetch fails.
    @available(*, deprecated, message: "Use fetchAll(accessToken:instanceUrl:pageNumber:pageSize:nextPageToken:) for cursor-based pagination.")
    public func fetchAll(accessToken: String, instanceUrl: String, pageNumber: Int? = nil, pageSize: Int? = nil) async throws -> SeekerResponse {
        return try await fetchAllImpl(accessToken: accessToken, instanceUrl: instanceUrl, pageNumber: pageNumber, pageSize: pageSize, nextPageToken: nil, seekerId: nil, name: nil, campus: nil, leadStatus: nil, email: nil, leadId: nil, contactNumber: nil)
    }

    /// Fetches all seekers from Salesforce (returns all seekers, not paginated)
    /// - Parameters:
    ///   - accessToken: The OAuth access token.
    ///   - instanceUrl: The Salesforce instance URL.
    /// - Returns: Array of seekers.
    /// - Throws: `SeekerError` if fetch fails.
    public func fetchAll(accessToken: String, instanceUrl: String) async throws -> [Seeker] {
        let response = try await fetchAllImpl(accessToken: accessToken, instanceUrl: instanceUrl, pageNumber: 1, pageSize: 1000, nextPageToken: nil, seekerId: nil, name: nil, campus: nil, leadStatus: nil, email: nil, leadId: nil, contactNumber: nil)
        return response.seekers
    }

    /// Fetches a specific seeker by identifier (leadId or phone, case-insensitive).
    /// - Parameters:
    ///   - identifier: The identifier to fetch (leadId or phone).
    ///   - accessToken: The OAuth access token.
    ///   - instanceUrl: The Salesforce instance URL.
    /// - Returns: The seeker if found.
    /// - Throws: `SeekerError` if seeker not found or fetch fails.
    public func fetch(identifier: String, accessToken: String, instanceUrl: String) async throws -> Seeker {
        let seekerURL = "\(instanceUrl)\(SalesforceAPIConstants.seekerEndpointV2)/\(identifier)"
        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
        ])
        let response = try await client.sendRequest(
            method: .GET,
            path: seekerURL,
            headers: requestHeaders
        )
        let seekerResponse = try await client.processResponse(response, as: SeekerResponse.self)
        guard let seeker = seekerResponse.seekers.first else {
            throw SeekerError.seekerNotFound
        }
        return seeker
    }
}
