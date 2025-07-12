import AsyncHTTPClient
import Congregation
import Foundation
import SalesforceClient

/// Protocol for file operations in CongregationKit
public protocol FilesHandler: Sendable {
    /// Downloads a file from Salesforce using a record ID
    /// - Parameter recordId: The record ID to download the file from
    /// - Returns: File download response containing file data and metadata
    /// - Throws: `FileDownloadError` if download fails
    func download(recordId: String) async throws -> FileDownloadResponse
}

/// Implementation of FilesHandler using Salesforce
public struct SalesforceFilesHandler: FilesHandler {
    private let salesforceClient: SalesforceClient
    private let accessToken: String
    private let instanceUrl: String

    /// Creates a new Salesforce files handler
    /// - Parameters:
    ///   - salesforceClient: The Salesforce client
    ///   - accessToken: The OAuth access token
    ///   - instanceUrl: The Salesforce instance URL
    public init(
        salesforceClient: SalesforceClient,
        accessToken: String,
        instanceUrl: String
    ) {
        self.salesforceClient = salesforceClient
        self.accessToken = accessToken
        self.instanceUrl = instanceUrl
    }

    public func download(recordId: String) async throws -> FileDownloadResponse {
        return try await salesforceClient.files.download(
            recordId: recordId,
            accessToken: accessToken,
            instanceUrl: instanceUrl
        )
    }
}
