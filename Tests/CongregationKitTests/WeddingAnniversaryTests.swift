import XCTest
@testable import Congregation

final class WeddingAnniversaryTests: XCTestCase {
    
    func testWeddingAnniversaryDateAccess() throws {
        // Test that weddingAnniversaryDate is accessible
        let sampleJSON = """
        {
            "martialStatus": "Married",
            "weddingAnniversaryDdMmYyyy": "2013-12-27",
            "spouseName": "Jane Doe",
            "numberOfChildren": 2
        }
        """
        
        let data = sampleJSON.data(using: .utf8)!
        let maritalInfo = try JSONDecoder().decode(MaritalInformation.self, from: data)
        
        // Test that weddingAnniversaryDate is accessible
        XCTAssertNotNil(maritalInfo.weddingAnniversaryDate)
        
        if let date = maritalInfo.weddingAnniversaryDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: date)
            XCTAssertEqual(dateString, "2013-12-27")
            print("Wedding Anniversary Date: \(dateString)")
        }
        
        // Test that rich info is also available
        XCTAssertNotNil(maritalInfo.weddingAnniversaryInfo)
        XCTAssertNotNil(maritalInfo.weddingAnniversary)
    }
    
    func testWeddingAnniversaryNotExposedInEncoding() throws {
        // Test that weddingAnniversary is encoded as "weddingAnniversary" not "weddingAnniversaryDdMmYyyy"
        let maritalInfo = MaritalInformation(
            maritalStatus: .married,
            weddingAnniversary: Date(timeIntervalSince1970: 1388102400), // 2013-12-27
            spouseName: "Jane Doe",
            numberOfChildren: 2
        )
        let encoder = JSONEncoder()
        let data = try encoder.encode(maritalInfo)
        let jsonString = String(data: data, encoding: .utf8)!
        // Verify that weddingAnniversary is in the JSON (not weddingAnniversaryDdMmYyyy)
        XCTAssertTrue(jsonString.contains("weddingAnniversary"), "weddingAnniversary should be included in encoding")
        XCTAssertFalse(jsonString.contains("weddingAnniversaryDdMmYyyy"), "weddingAnniversaryDdMmYyyy should not be in encoding")
        // Verify that other fields are present
        XCTAssertTrue(jsonString.contains("martialStatus"))
        XCTAssertTrue(jsonString.contains("spouseName"))
        XCTAssertTrue(jsonString.contains("numberOfChildren"))
        print("Encoded JSON: \(jsonString)")
    }
} 