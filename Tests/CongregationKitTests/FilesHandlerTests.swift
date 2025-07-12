import Congregation
import CongregationKit
import Foundation
import SalesforceClient
import Testing

@Suite("FilesHandler Tests")
actor FilesHandlerTests {
    let accessToken: String
    let instanceUrl: String
    let handler: FilesHandler

    init() async throws {
        guard let clientId = ProcessInfo.processInfo.environment["SF_CLIENT_ID"],
            let clientSecret = ProcessInfo.processInfo.environment["SF_CLIENT_SECRET"],
            let username = ProcessInfo.processInfo.environment["SF_USERNAME"],
            let password = ProcessInfo.processInfo.environment["SF_PASSWORD"]
        else {
            throw NSError(domain: "Missing Salesforce credentials in environment.", code: 1)
        }
        let credentials = SalesforceCredentials(
            clientId: clientId,
            clientSecret: clientSecret,
            username: username,
            password: password
        )
        let salesforceClient = SalesforceClient(httpClient: .shared)
        let authResponse = try await salesforceClient.auth.authenticate(credentials: credentials)
        self.accessToken = authResponse.accessToken
        self.instanceUrl = authResponse.instanceUrl
        self.handler = SalesforceFilesHandler(
            salesforceClient: salesforceClient,
            accessToken: authResponse.accessToken,
            instanceUrl: authResponse.instanceUrl
        )
    }

    @Test("Download file by recordId")
    func testDownloadFileByRecordId() async throws {
        let recordId = "a0x2w000002jxqn"
        let response = try await handler.download(recordId: recordId)

        #expect(response.recordId == recordId)
        #expect(!response.data.isEmpty)
        #expect(!response.filename.isEmpty)
        #expect(!response.fileExtension.isEmpty)
        #expect(response.fileSize > 0)
        #expect(response.contentType != "application/octet-stream")

        // Additional assertions based on the actual response we saw
        #expect(response.contentType == "image/jpeg")
        #expect(response.fileExtension == "jpeg")
        #expect(response.filename.contains("WhatsApp Image"))
    }
}
