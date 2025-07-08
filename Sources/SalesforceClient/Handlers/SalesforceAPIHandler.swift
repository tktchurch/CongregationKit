import AsyncHTTPClient
import Foundation
import NIOCore
import NIOHTTP1

/// Constants for Salesforce API endpoints
public enum SalesforceAPIConstants {
    public static let baseURL = "https://login.salesforce.com"
    public static let tokenEndpoint = "/services/oauth2/token"
    /// v1 (default, non-paginated)
    public static let memberEndpoint = "/services/apexrest/api/member"
    /// v2 (paginated)
    public static let memberEndpointV2 = "/services/apexrest/members"
    public static let seekerEndpointV2 = "/services/apexrest/seekers"
}

/// Utility functions for Salesforce API operations
public enum SalesforceAPIUtil {
    /// Converts a dictionary of query parameters to a URL query string.
    ///
    /// - Parameter queryParams: An optional dictionary of string key-value pairs representing query parameters.
    /// - Returns: A URL-encoded query string starting with "?", or an empty string if no parameters are provided.
    ///
    /// ```swift
    /// let params = ["page": "1", "limit": "10"]
    /// let queryString = SalesforceAPIUtil.convertToQueryString(params)
    /// // Returns "?page=1&limit=10"
    /// ```
    static func convertToQueryString(_ queryParams: [String: String]?) -> String {
        guard let queryParams = queryParams, !queryParams.isEmpty else { return "" }
        let queryItems = queryParams.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
        return "?" + queryItems.joined(separator: "&")
    }

    /// Converts a dictionary of strings to HTTPHeaders
    /// - Parameter dictionary: The string dictionary
    /// - Returns: HTTPHeaders
    static func convertToHTTPHeaders(_ dictionary: [String: String]?) -> HTTPHeaders {
        guard let dictionary = dictionary else { return HTTPHeaders() }
        var headers = HTTPHeaders()
        for (key, value) in dictionary {
            headers.add(name: key, value: value)
        }
        return headers
    }
}

// MARK: - HTTPClientRequest.Body Extensions

extension HTTPClientRequest.Body {
    public static func string(_ string: String) -> Self {
        .bytes(.init(string: string))
    }

    public static func data(_ data: Data) -> Self {
        var buffer = ByteBufferAllocator().buffer(capacity: data.count)
        buffer.writeBytes(data)
        return .bytes(buffer)
    }

    public static func json(_ json: [String: Any]) throws -> Self {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        var buffer = ByteBufferAllocator().buffer(capacity: jsonData.count)
        buffer.writeBytes(jsonData)
        return .bytes(buffer)
    }
}

/// Handler for Salesforce API requests
public actor SalesforceAPIHandler {
    private let httpClient: HTTPClient

    /// Creates a new Salesforce API handler
    /// - Parameter httpClient: The HTTP client to use for making requests
    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    /// Sends a request to Salesforce API
    /// - Parameters:
    ///   - method: The HTTP method
    ///   - path: The API path
    ///   - queryParams: Optional query parameters
    ///   - body: The request body
    ///   - headers: Additional headers
    /// - Returns: The HTTP response
    /// - Throws: Network or API errors
    public func sendRequest(
        method: HTTPMethod,
        path: String,
        queryParams: [String: String]? = nil,
        body: HTTPClientRequest.Body? = nil,
        headers: HTTPHeaders = [:]
    ) async throws -> HTTPClientResponse {
        let queryString = SalesforceAPIUtil.convertToQueryString(queryParams)
        let url = path + queryString

        var requestHeaders: HTTPHeaders = [
            "Accept": "application/json"
        ]
        for header in headers {
            requestHeaders.add(name: header.name, value: header.value)
        }

        var request = HTTPClientRequest(url: url)
        request.method = method
        request.headers = requestHeaders
        request.body = body

        let response = try await httpClient.execute(request, timeout: .seconds(30))
        return response
    }

    /// Processes the response and decodes it to the specified type
    /// - Parameters:
    ///   - response: The HTTP response
    ///   - type: The type to decode to
    /// - Returns: The decoded object
    /// - Throws: Decoding errors
    public func processResponse<T: Codable>(_ response: HTTPClientResponse, as type: T.Type) async throws -> T {
        guard response.status == .ok else {
            let body = try await response.body.collect(upTo: 1024 * 1024)
            let errorMessage = String(buffer: body)
            throw SalesforceAuthError.serverError("HTTP \(response.status.code): \(errorMessage)")
        }

        let body = try await response.body.collect(upTo: 1024 * 1024)
        let data = Data(body.readableBytesView)
        let jsonData = try JSONDecoder().decode(type, from: data)
        return jsonData
    }

    /// Creates form-encoded body for OAuth requests
    /// - Parameter parameters: The form parameters
    /// - Returns: The HTTP body
    public func createFormBody(parameters: [String: String]) -> HTTPClientRequest.Body {
        let formString =
            parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")

        return .string(formString)
    }
}

// MARK: - Utility Extensions

extension HTTPHeaders {
    /// Converts a dictionary of strings to HTTPHeaders
    /// - Parameter dictionary: The string dictionary
    /// - Returns: HTTPHeaders
    public static func from(_ dictionary: [String: String]) -> HTTPHeaders {
        var headers = HTTPHeaders()
        for (key, value) in dictionary {
            headers.add(name: key, value: value)
        }
        return headers
    }
}
