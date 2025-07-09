import Congregation
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

    @Test("Fetch all members (paginated, expanded fields)")
    func testFetchAllMembersPaginatedExpanded() async throws {
        let expanded: [MemberExpand] = [.employmentInformation, .contactInformation, .martialInformation, .discipleshipInformation]
        let response = try await handler.fetchAll(
            pageNumber: 1,
            pageSize: 2,
            expanded: expanded
        )
        #expect(response.members.count > 0)
    }

    @Test("Fetch member by ID")
    func testFetchMemberById() async throws {
        guard let testMemberId = ProcessInfo.processInfo.environment["TEST_MEMBER_ID"],
            let memberId = MemberID(rawValue: testMemberId)
        else {
            print("[DEBUG] No TEST_MEMBER_ID set in environment. Skipping fetch by ID test.")
            return
        }
        let member = try await handler.fetch(id: memberId)
        #expect(member.memberId?.rawValue == testMemberId)
    }

    @Test("Fetch member by ID (expanded fields)")
    func testFetchMemberByIdExpanded() async throws {
        guard let testMemberId = ProcessInfo.processInfo.environment["TEST_MEMBER_ID"],
            let memberId = MemberID(rawValue: testMemberId)
        else {
            print("[DEBUG] No TEST_MEMBER_ID set in environment. Skipping fetch by ID (expanded) test.")
            return
        }
        let expanded: [MemberExpand] = [.employmentInformation, .contactInformation, .martialInformation, .discipleshipInformation]
        let member = try await handler.fetch(id: memberId, expanded: expanded)
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

    @Test("Compare dateOfBirth: raw response vs SDK")
    func testCompareDateOfBirthRawVsSDK() async throws {
        // Fetch raw server response
        let url = URL(string: instanceUrl + "/services/apexrest/members?pageNumber=1&pageSize=1")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: request)
        let rawJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        let rawMembers = rawJSON?["members"] as? [[String: Any]]
        let rawDateOfBirth = rawMembers?.first?["dateOfBirth"]
        // print("[DEBUG] Raw server dateOfBirth: \(String(describing: rawDateOfBirth))")

        // Fetch via SDK
        let sdkResponse = try await handler.fetchAll(pageNumber: 1, pageSize: 1)
        let sdkDateOfBirth = sdkResponse.members.first?.dateOfBirth
        // print("[DEBUG] SDK dateOfBirth: \(String(describing: sdkDateOfBirth))")

        // Print both for comparison
        #expect(rawDateOfBirth != nil)
        #expect(sdkDateOfBirth != nil)
    }

    @Test("Fetch all members (no arguments, should use default pagination)")
    func testFetchAllMembersNoArgs() async throws {
        let members = try await handler.fetch()
        #expect(members.members.count > 0)
    }

    @Test("Fetch all members across all pages (pagination, decoding check)")
    func testFetchAllMembersAllPages() async throws {
        let pageSize = 100
        var allMembers: [Member] = []
        var pageNumber = 1
        var totalRecords: Int? = nil
        repeat {
            let response = try await handler.fetchAll(pageNumber: pageNumber, pageSize: pageSize)
            if totalRecords == nil {
                totalRecords = response.metadata?.total
            }
            print("[DEBUG] Page \(pageNumber): Fetched \(response.members.count) members")
            allMembers.append(contentsOf: response.members)
            if response.members.isEmpty { break }
            pageNumber += 1
        } while allMembers.count < (totalRecords ?? Int.max)
        print("[DEBUG] Total members fetched: \(allMembers.count)")
        #expect(totalRecords != nil && allMembers.count == totalRecords)
    }
}
