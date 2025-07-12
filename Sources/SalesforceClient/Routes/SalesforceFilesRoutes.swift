import AsyncHTTPClient
import Congregation
import Foundation
import NIOHTTP1

/// Implementation of Salesforce files routes
public struct SalesforceFilesRoutesImpl: SalesforceFilesRoutes {
    public var headers: HTTPHeaders = [:]
    private let client: SalesforceAPIHandler

    init(client: SalesforceAPIHandler) {
        self.client = client
    }

    public func download(recordId: String, accessToken: String, instanceUrl: String) async throws -> FileDownloadResponse {
        // Validate record ID format (similar to Salesforce backend validation)
        guard isValidRecordId(recordId) else {
            throw FileDownloadError.invalidRecordId
        }

        let fileDownloadURL = "\(instanceUrl)\(SalesforceAPIConstants.fileDownloadEndpoint)"

        // Add query parameter for record ID (eid parameter as per Salesforce backend)
        let queryParams = ["eid": recordId]

        let requestHeaders = SalesforceAPIUtil.convertToHTTPHeaders([
            "Authorization": "Bearer \(accessToken)",
            "Accept": "*/*",  // Accept any content type for file downloads
        ])

        let response = try await client.sendRequest(
            method: .GET,
            path: fileDownloadURL,
            queryParams: queryParams,
            headers: requestHeaders
        )

        // Extract ContentDocumentId from response headers
        var contentDocumentId = "unknown"
        if let contentDocumentIdHeader = response.headers["ContentDocumentId"].first {
            contentDocumentId = contentDocumentIdHeader
        } else if let contentDocumentIdHeader = response.headers["X-ContentDocumentId"].first {
            contentDocumentId = contentDocumentIdHeader
        }
        
        return try await client.processBinaryResponse(
            response,
            recordId: recordId,
            contentDocumentId: contentDocumentId
        )
    }

    /// Validates that the record ID format is correct
    /// - Parameter recordId: The record ID to validate
    /// - Returns: True if the record ID is valid, false otherwise
    private func isValidRecordId(_ recordId: String) -> Bool {
        // Salesforce record IDs are 15 or 18 characters long and contain only alphanumeric characters
        return recordId.count >= 15 && recordId.count <= 18 && recordId.range(of: "^[a-zA-Z0-9]+$", options: .regularExpression) != nil
    }
}
