import AsyncHTTPClient
import Foundation
import SalesforceClient
import Testing

@Suite("SalesforceClient Tests")
struct SalesforceClientTests {
    let client: SalesforceClient
    // TODO: Replace with `false` when you have valid Salesforce credentials
    let credentialsAreInvalid = true

    init() {
        // TODO: Replace with valid Salesforce credentials to test
        let credentials = SalesforceCredentials(
            clientId: "YOUR_CLIENT_ID",
            clientSecret: "YOUR_CLIENT_SECRET",
            username: "YOUR_USERNAME",
            password: "YOUR_PASSWORD"
        )
        client = SalesforceClient(httpClient: .shared)
    }

    @Test("Initialization")
    func testInitialization() async throws {
        #expect(client != nil)
        await #expect(client.auth != nil)
        await #expect(client.members != nil)
    }

    @Test("Salesforce Auth Response Coding")
    func testSalesforceAuthResponseCoding() throws {
        // Given: Sample auth response JSON
        let json = """
        {
            "access_token": "FAKE_ACCESS_TOKEN",
            "instance_url": "https://example.my.salesforce.com",
            "id": "https://login.salesforce.com/id/ORGID/USERID",
            "token_type": "Bearer",
            "issued_at": "1234567890000",
            "signature": "FAKE_SIGNATURE=="
        }
        """
        
        // When: Decoding the JSON
        let data = json.data(using: .utf8)!
        let authResponse = try JSONDecoder().decode(SalesforceAuthResponse.self, from: data)
        
        // Then: All fields should be correctly decoded
        #expect(authResponse.accessToken == "FAKE_ACCESS_TOKEN")
        #expect(authResponse.instanceUrl == "https://example.my.salesforce.com")
        #expect(authResponse.id == "https://login.salesforce.com/id/ORGID/USERID")
        #expect(authResponse.tokenType == "Bearer")
        #expect(authResponse.issuedAt == "1234567890000")
        #expect(authResponse.signature == "FAKE_SIGNATURE==")
    }

    @Test("Member Coding")
    func testMemberCoding() throws {
        // Given: Sample member JSON
        let json = """
        {
            "memberId": "M001",
            "memberName": "John Doe",
            "phone": "+1234567890",
            "lifeGroupName": "Young Adults",
            "email": "john.doe@example.com",
            "area": "North Campus",
            "address": "123 Main St, City, State 12345"
        }
        """
        
        // When: Decoding the JSON
        let data = json.data(using: .utf8)!
        let member = try JSONDecoder().decode(Member.self, from: data)
        
        // Then: All fields should be correctly decoded
        #expect(member.memberId?.rawValue == "M001")
        #expect(member.memberName == "John Doe")
        #expect(member.phone == "+1234567890")
        #expect(member.lifeGroupName == "Young Adults")
        #expect(member.email == "john.doe@example.com")
        #expect(member.area == "North Campus")
        #expect(member.address == "123 Main St, City, State 12345")
    }

    @Test("Member Response Coding")
    func testMemberResponseCoding() throws {
        // Given: Sample member response JSON
        let json = """
        {
            "member": [
                {
                    "memberId": "M001",
                    "memberName": "John Doe",
                    "phone": "+1234567890",
                    "lifeGroupName": "Young Adults",
                    "email": "john.doe@example.com",
                    "area": "North Campus",
                    "address": "123 Main St, City, State 12345"
                },
                {
                    "memberId": "M002",
                    "memberName": "Jane Smith",
                    "phone": "+0987654321",
                    "lifeGroupName": "Women's Group",
                    "email": "jane.smith@example.com",
                    "area": "South Campus",
                    "address": "456 Oak Ave, City, State 12345"
                }
            ]
        }
        """
        
        // When: Decoding the JSON
        let data = json.data(using: .utf8)!
        let memberResponse = try JSONDecoder().decode(MemberResponse.self, from: data)
        
        // Then: All members should be correctly decoded
        #expect(memberResponse.members.count == 2)
        #expect(memberResponse.members[0].memberId?.rawValue == "M001")
        #expect(memberResponse.members[0].memberName == "John Doe")
        #expect(memberResponse.members[1].memberId?.rawValue == "M002")
        #expect(memberResponse.members[1].memberName == "Jane Smith")
    }

    @Test("Salesforce Credentials Initialization")
    func testSalesforceCredentialsInitialization() {
        // Given: Credentials parameters
        let clientId = "test_client_id"
        let clientSecret = "test_client_secret"
        let username = "test@example.com"
        let password = "test_password"
        
        // When: Creating credentials
        let credentials = SalesforceCredentials(
            clientId: clientId,
            clientSecret: clientSecret,
            username: username,
            password: password
        )
        
        // Then: All fields should be correctly set
        #expect(credentials.clientId == clientId)
        #expect(credentials.clientSecret == clientSecret)
        #expect(credentials.username == username)
        #expect(credentials.password == password)
    }

    @Test("Member Initialization")
    func testMemberInitialization() {
        // Given: Member parameters
        let id = "1"
        let memberId = "M001"
        let memberName = "John Doe"
        let phone = "+1234567890"
        let lifeGroupName = "Young Adults"
        let email = "john.doe@example.com"
        let area = "North Campus"
        let address = "123 Main St"
        
        // When: Creating member
        let member = Member(
            id: id,
            memberId: memberId,
            memberName: memberName,
            phone: phone,
            email: email, lifeGroupName: lifeGroupName,
            area: area,
            address: address
        )
        
        // Then: All fields should be correctly set
        #expect(member.id == id)
        #expect(member.memberId?.rawValue == memberId)
        #expect(member.memberName == memberName)
        #expect(member.phone == phone)
        #expect(member.lifeGroupName == lifeGroupName)
        #expect(member.email == email)
        #expect(member.area == area)
        #expect(member.address == address)
    }

    @Test("Error Descriptions")
    func testErrorDescriptions() {
        // Test SalesforceAuthError descriptions
        #expect(SalesforceAuthError.invalidCredentials.errorDescription == "Invalid Salesforce credentials")
        #expect(SalesforceAuthError.rateLimitExceeded.errorDescription == "Salesforce API rate limit exceeded")
        
        // Test MemberError descriptions
        #expect(MemberError.memberNotFound.errorDescription == "Member not found")
        #expect(MemberError.invalidMemberData.errorDescription == "Invalid member data received")
    }

    @Test("API Constants")
    func testAPIConstants() {
        #expect(SalesforceAPIConstants.baseURL == "https://login.salesforce.com")
        #expect(SalesforceAPIConstants.tokenEndpoint == "/services/oauth2/token")
        #expect(SalesforceAPIConstants.memberEndpoint == "/services/apexrest/api/member")
    }

    @Test("Authentication")
    func testAuthentication() async throws {
        try await withKnownIssue {
            let credentials = SalesforceCredentials(
                clientId: "test_client_id",
                clientSecret: "test_client_secret",
                username: "test@example.com",
                password: "test_password"
            )
            
            let authResponse = try await client.auth.authenticate(credentials: credentials)
            #expect(!authResponse.accessToken.isEmpty)
            #expect(!authResponse.instanceUrl.isEmpty)
        } when: {
            credentialsAreInvalid
        }
    }
} 