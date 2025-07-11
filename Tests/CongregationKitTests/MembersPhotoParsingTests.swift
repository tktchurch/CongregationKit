import Congregation
import XCTest

@testable import CongregationKit

final class MembersPhotoParsingTests: XCTestCase {
    func testPhotoParsingWithSrcAndAlt() {
        let html = #"<p><img src=\"https://example.com/image.jpg\" alt=\"Profile Photo\"></img></p>"#
        let expectedURL = "https://example.com/image.jpg"
        let expectedAlt = "Profile photo"
        let memberData = MemberData(photoRaw: html)
        XCTAssertEqual(memberData.photo?.url, expectedURL)
        XCTAssertEqual(memberData.photo?.alt, expectedAlt)
    }

    func testPhotoParsingWithOnlySrc() {
        let html = #"<img src=\"https://example.com/onlysrc.jpg\">"#
        let expectedURL = "https://example.com/onlysrc.jpg"
        let memberData = MemberData(photoRaw: html)
        XCTAssertEqual(memberData.photo?.url, expectedURL)
        XCTAssertNil(memberData.photo?.alt)
    }

    func testPhotoParsingWithEmptyAlt() {
        let html = #"<img src=\"https://example.com/emptyalt.jpg\" alt=\"\">"#
        let expectedURL = "https://example.com/emptyalt.jpg"
        let memberData = MemberData(photoRaw: html)
        XCTAssertEqual(memberData.photo?.url, expectedURL)
        XCTAssertNil(memberData.photo?.alt)
    }

    func testPhotoParsingWithEncodedAmpersand() {
        let html = #"<img src=\"https://example.com/image.jpg?foo=1&amp;bar=2\" alt=\"Test Photo\">"#
        let expectedURL = "https://example.com/image.jpg?foo=1&bar=2"
        let expectedAlt = "Test photo"
        let memberData = MemberData(photoRaw: html)
        XCTAssertEqual(memberData.photo?.url, expectedURL)
        XCTAssertEqual(memberData.photo?.alt, expectedAlt)
    }

    func testPhotoParsingWithUnderscoresAndDashesInAlt() {
        let html = #"<img src=\"https://example.com/image.jpg\" alt=\"profile_photo-test\">"#
        let expectedAlt = "Profile photo test"
        let memberData = MemberData(photoRaw: html)
        XCTAssertEqual(memberData.photo?.alt, expectedAlt)
    }

    func testPhotoParsingWithExtraWhitespaceInAlt() {
        let html = #"<img src=\"https://example.com/image.jpg\" alt=\"   profile   photo   \">"#
        let expectedAlt = "Profile photo"
        let memberData = MemberData(photoRaw: html)
        XCTAssertEqual(memberData.photo?.alt, expectedAlt)
    }

    func testPhotoParsingWithNilInput() {
        let memberData = MemberData(photoRaw: nil)
        XCTAssertNil(memberData.photo)
    }

    func testPhotoParsingWithEmptyInput() {
        let memberData = MemberData(photoRaw: "")
        XCTAssertNil(memberData.photo)
    }

    func testPhotoParsingWithRealApiFormat() {
        let html =
            #"<p><img src=\"https://data.file.force.com/servlet/rtaImage?eid=a0x2w000002jxqn&amp;feoid=00NIg000000m2td&amp;refid=0EMIg0000008WVM\" alt=\"WhatsApp Image 2024-06-09 at 8.39.03 PM.jpeg\"></img></p>"#
        let expectedURL = "https://data.file.force.com/servlet/rtaImage?eid=a0x2w000002jxqn&feoid=00NIg000000m2td&refid=0EMIg0000008WVM"
        let expectedAlt = "1717976340"  // 2024-06-09 at 8.39.03 PM UTC as timestamp
        let expectedTags = ["whatsapp"]
        let memberData = MemberData(photoRaw: html)
        XCTAssertEqual(memberData.photo?.url, expectedURL)
        XCTAssertEqual(memberData.photo?.alt, expectedAlt)
        XCTAssertEqual(memberData.photo?.tags, expectedTags)
    }

    // Optionally, test Member as well if it has a similar interface
    func testMemberPhotoParsing() {
        let html = #"<img src=\"https://example.com/member.jpg\" alt=\"member_photo\">"#
        let expectedURL = "https://example.com/member.jpg"
        let expectedAlt = "Member photo"
        let member = Member(
            id: nil,
            memberId: Optional<String>.none,  // explicitly String? to disambiguate
            createdDate: nil,
            lastModifiedDate: nil,
            memberName: nil,
            firstName: nil,
            middleName: nil,
            lastName: nil,
            gender: nil,
            phone: nil,
            email: nil,
            lifeGroupName: nil,
            area: nil,
            address: nil,
            dateOfBirth: nil,
            title: nil,
            memberType: nil,
            bloodGroup: nil,
            preferredLanguages: nil,
            attendingCampus: nil,
            serviceCampus: nil,
            partOfLifeGroup: nil,
            status: nil,
            campus: nil,
            spm: nil,
            attendingService: nil,
            contactInformation: nil,
            employmentInformation: nil,
            maritalInformation: nil,
            discipleshipInformation: nil,
            photoRaw: html
        )
        XCTAssertEqual(member.photo?.url, expectedURL)
        XCTAssertEqual(member.photo?.alt, expectedAlt)
    }
}
