import AsyncHTTPClient
import Congregation
import Foundation
import NIOHTTP1

/// Implementation of Salesforce authentication routes
public struct SalesforceAuthRoutesImpl: SalesforceAuthRoutes {
    public var headers: HTTPHeaders = [:]
    private let client: SalesforceAPIHandler

    init(client: SalesforceAPIHandler) {
        self.client = client
    }

    public func authenticate(credentials: SalesforceCredentials) async throws -> SalesforceAuthResponse {
        let tokenURL = "\(SalesforceAPIConstants.baseURL)\(SalesforceAPIConstants.tokenEndpoint)"

        let parameters = [
            "grant_type": "password",
            "client_id": credentials.clientId,
            "client_secret": credentials.clientSecret,
            "username": credentials.username,
            "password": credentials.password,
        ]

        let formBody = await client.createFormBody(parameters: parameters)
        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Content-Type": "application/x-www-form-urlencoded"
        ])

        let response = try await client.sendRequest(
            method: .POST,
            path: tokenURL,
            body: formBody,
            headers: requestHeaders
        )

        return try await client.processResponse(response, as: SalesforceAuthResponse.self)
    }
}
