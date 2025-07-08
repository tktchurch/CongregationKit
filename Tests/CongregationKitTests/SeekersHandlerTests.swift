import CongregationKit
import Foundation
import SalesforceClient
import Testing

@Suite("SeekersHandler Tests")
actor SeekersHandlerTests {
    let accessToken: String
    let instanceUrl: String
    let handler: SeekersHandler

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
        self.handler = SalesforceSeekersHandler(
            salesforceClient: salesforceClient,
            accessToken: authResponse.accessToken,
            instanceUrl: authResponse.instanceUrl
        )
    }

    @Test("Fetch all seekers (paginated)")
    func testFetchAllSeekersPaginated() async throws {
        let response = try await handler.fetchAll(
            pageNumber: 1,
            pageSize: 2,
            seekerId: nil,
            name: nil,
            campus: nil,
            leadStatus: nil,
            email: nil,
            leadId: nil,
            contactNumber: nil
        )
        #expect(response.seekers.count > 0)
    }

    @Test("Fetch seeker by identifier")
    func testFetchSeekerByIdentifier() async throws {
        guard let identifier = ProcessInfo.processInfo.environment["TEST_SEEKER_IDENTIFIER"] else {
            print("No TEST_SEEKER_IDENTIFIER set in environment. Skipping fetch by identifier test.")
            return
        }
        let seeker = try await handler.fetch(identifier: identifier)
        #expect(seeker != nil)
    }
}
