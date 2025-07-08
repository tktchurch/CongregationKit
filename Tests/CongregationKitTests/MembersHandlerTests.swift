import CongregationKit
import Foundation
import SalesforceClient
import Testing

@Suite("MembersHandler Tests")
actor MembersHandlerTests {
    let accessToken: String
    let instanceUrl: String
    let handler: MembersHandler

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
        self.handler = SalesforceMembersHandler(
            salesforceClient: salesforceClient,
            accessToken: authResponse.accessToken,
            instanceUrl: authResponse.instanceUrl
        )
    }

    @Test("Fetch all members (paginated)")
    func testFetchAllMembersPaginated() async throws {
        let response = try await handler.fetchAll(pageNumber: 1, pageSize: 2)
        #expect(response.members.count > 0)
    }

    @Test("Fetch member by ID")
    func testFetchMemberById() async throws {
        guard let testMemberId = ProcessInfo.processInfo.environment["TEST_MEMBER_ID"],
            let memberId = MemberID(rawValue: testMemberId)
        else {
            return
        }
        let member = try await handler.fetch(id: memberId)
        #expect(member.memberId?.rawValue == testMemberId)
    }

    @Test("Fetch all members (raw server response)")
    func testFetchAllMembersRawServerResponse() async throws {
        let url = URL(string: instanceUrl + "/services/apexrest/members?pageNumber=1&pageSize=2")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await URLSession.shared.data(for: request)
        _ = (response as? HTTPURLResponse)?.statusCode
        _ = String(data: data, encoding: .utf8)
    }

    @Test("Decode legacy member array (backwards compatibility)")
    func testDecodeLegacyMemberArray() async throws {
        let legacyJSON = """
            {
                "member": [
                    {
                        "id": "legacy1",
                        "memberId": "TKT9999",
                        "firstName": "Legacy",
                        "lastName": "User",
                        "dateOfBirth": "1990-01-01"
                    }
                ],
                "message": "Legacy Success"
            }
            """.data(using: .utf8)!
        let response = try JSONDecoder().decode(MemberResponse.self, from: legacyJSON)
        #expect(response.members.count == 1)
        #expect(response.members.first?.firstName == "Legacy")
        #expect(response.message == "Legacy Success")
    }
}
