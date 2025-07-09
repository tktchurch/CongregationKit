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

    @Test("Fetch all seekers across all pages (pagination, decoding check)")
    func testFetchAllSeekersAllPages() async throws {
        let pageSize = 10
        var allSeekers: [Seeker] = []
        var nextPageToken: String? = nil
        var totalRecords: Int? = nil
        var pageNumber = 1
        repeat {
            do {
                let response = try await handler.fetchAll(pageNumber: nil, pageSize: pageSize, nextPageToken: nextPageToken, seekerId: nil, name: nil, campus: nil, leadStatus: nil, email: nil, leadId: nil, contactNumber: nil)
                if totalRecords == nil {
                    totalRecords = response.metadata?.total
                }
                print("[DEBUG] Page \(pageNumber): Fetched \(response.seekers.count) seekers, nextPageToken: \(String(describing: response.metadata?.nextPageToken))")
                if response.seekers.count < pageSize && response.metadata?.nextPageToken != nil {
                    print("[WARNING] Page \(pageNumber) returned fewer than pageSize seekers but nextPageToken is not nil!")
                }
                allSeekers.append(contentsOf: response.seekers)
                nextPageToken = response.metadata?.nextPageToken
                if response.seekers.isEmpty || nextPageToken == nil { break }
                pageNumber += 1
            } catch {
                print("[ERROR] Decoding or API error on page \(pageNumber):", error)
                throw error
            }
        } while allSeekers.count < (totalRecords ?? Int.max)
        print("[DEBUG] Total seekers fetched: \(allSeekers.count), totalRecords: \(String(describing: totalRecords))")
    }
}
