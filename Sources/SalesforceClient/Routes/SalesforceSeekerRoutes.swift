import Foundation
import AsyncHTTPClient
import NIOHTTP1

/// Implementation of Salesforce seeker routes
public struct SalesforceSeekerRoutesImpl: SalesforceSeekerRoutes {
    public var headers: HTTPHeaders = [:]
    private let client: SalesforceAPIHandler
    
    init(client: SalesforceAPIHandler) {
        self.client = client
    }

    /// Fetches a paginated list of seekers from Salesforce.
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
        let page = pageNumber ?? 1
        let size = pageSize ?? 50
        var queryParams: [String: String] = [
            "pageNumber": String(page),
            "pageSize": String(size)
        ]
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
            "Content-Type": "application/json"
        ])
        let response = try await client.sendRequest(
            method: .GET,
            path: seekerURL,
            queryParams: queryParams,
            headers: requestHeaders
        )
        return try await client.processResponse(response, as: SeekerResponse.self)
    }

    /// Fetches a specific seeker by identifier (leadId or phone, case-insensitive).
    public func fetch(identifier: String, accessToken: String, instanceUrl: String) async throws -> Seeker {
        let seekerURL = "\(instanceUrl)\(SalesforceAPIConstants.seekerEndpointV2)/\(identifier)"
        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
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
 