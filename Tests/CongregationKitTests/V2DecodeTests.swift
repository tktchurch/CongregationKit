import Congregation
import Foundation
import Testing

@Suite("V2 JSON decode fixtures")
struct V2DecodeTests {
    private func fixtureURL(_ name: String) throws -> URL {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures/V2/\(name).json")
        return url
    }

    private func decodeFixture<T: Decodable>(_ name: String, as type: T.Type) throws -> T {
        let data = try Data(contentsOf: fixtureURL(name))
        return try JSONDecoder().decode(type, from: data)
    }

    @Test func decodeMemberV2() throws {
        let member = try decodeFixture("member", as: Member.self)
        #expect(member.memberId?.rawValue == "TKT100001")
        #expect(member.firstName == "Sample")
        #expect(member.lastName == "Member")
        #expect(member.sync?.etag == "W/\"abc123\"")
        #expect(member.sync?.name == "members/TKT100001")
        #expect(member.familyName == "Member Family")
        #expect(member.primaryDepartment == .worshipTeam)
        #expect(member.preferredCampus == .eastCampus)
        #expect(member.campus == .eastCampus)
        #expect(member.maritalInformation?.spouseName == "Sample Spouse")
        #expect(member.maritalInformation?.maritalStatus == .married)
        #expect(member.maritalInformation?.numberOfChildren == 2)
        #expect(member.employmentInformation?.employmentStatus == .employed)
        #expect(member.employmentInformation?.occupation == .it)
        #expect(member.discipleshipInformation?.waterBaptism?.received == true)
        #expect(member.discipleshipInformation?.holySpiritFilling == true)
        #expect(member.photo?.url == "https://example.com/p.jpg")
        #expect(member.family?.count == 1)
        #expect(member.family?.first?.cardIssued == true)
        #expect(member.courses?.first?.name == "Foundation Course")
    }

    @Test func decodeMemberListEnvelope() throws {
        let envelope = try decodeFixture("member-list", as: MemberListEnvelope.self)
        #expect(envelope.members.count == 1)
        #expect(envelope.nextPageToken == "cursor-page-2")
        #expect(envelope.asSyncPage.totalSize == 1)
        #expect(envelope.asSyncPage.records.first?.memberId?.rawValue == "TKT100001")
    }

    @Test func decodeSeekerV2() throws {
        let seeker = try decodeFixture("seeker", as: Seeker.self)
        #expect(seeker.seekerId?.rawValue == "SKR100001")
        #expect(seeker.fullName == "Sample Seeker")
        #expect(seeker.sync?.etag == "W/\"def456\"")
        #expect(seeker.lead?.status == .attempted)
        #expect(seeker.typeOfEntry == .newVisitor)
        #expect(seeker.ownerId?.rawValue == "005TEST00000001")
        #expect(seeker.gender == .female)
        #expect(seeker.preferredCampus == .eastCampus)
        #expect(seeker.priority == .high)
        #expect(seeker.callStatus == .notAnswered)
    }

    @Test func decodeFollowUpTask() throws {
        let task = try decodeFixture("task", as: FollowUpTask.self)
        #expect(task.id == "00TTEST00000001")
        #expect(task.type == .seeker)
        #expect(task.ownerId?.rawValue == "005TEST00000001")
        #expect(task.sync?.name == "tasks/00TTEST00000001")
        #expect(task.status == .open)
        #expect(task.priority == .normal)
    }

    @Test func decodeStaffUser() throws {
        let user = try decodeFixture("user", as: StaffUser.self)
        #expect(user.id == "005TEST00000001")
        #expect(user.username == "ops.staff")
        #expect(user.group == .adult)
        #expect(user.sync?.name == "users/005TEST00000001")
    }

    @Test func decodeCourse() throws {
        let course = try decodeFixture("course", as: Course.self)
        #expect(course.name == "Foundation Course")
        #expect(course.memberId?.rawValue == "TKT100001")
        #expect(course.score == 95.5)
    }

    @Test func decodeFamilyRecord() throws {
        let record = try decodeFixture("family", as: FamilyRecord.self)
        #expect(record.displayName == "Family Dependent")
        #expect(record.cardIssued == true)
        #expect(record.memberId?.rawValue == "TKT100001")
    }

    @Test func decodeSpiritualRecord() throws {
        let record = try decodeFixture("spiritual-record", as: SpiritualRecord.self)
        #expect(record.question == "Water baptism received?")
        #expect(record.answer == "Yes")
        #expect(record.memberId?.rawValue == "TKT100001")
    }

    @Test func syncQueryParameters() {
        let query = SyncQuery(pageSize: 50, fields: ["memberId", "firstName"], orderBy: "updateTime desc")
        let params = query.asQueryParameters()
        #expect(params["pageSize"] == "50")
        #expect(params["fields"] == "memberId,firstName")
        #expect(params["orderBy"] == "updateTime desc")

        let memberFilters = MemberListQuery(campus: .eastCampus, status: .regular, search: "Sample")
            .asQueryParameters()
        #expect(memberFilters["campus"] == "East Campus")
        #expect(memberFilters["status"] == "Regular")
        #expect(memberFilters["q"] == "Sample")

        let seekerFilters = SeekerListQuery(leadStatus: .attempted, callStatus: .notAnswered, search: "SKR")
            .asQueryParameters()
        #expect(seekerFilters["leadStatus"] == "Attempted")
        #expect(seekerFilters["callStatus"] == "Not Answered")
        #expect(seekerFilters["q"] == "SKR")
    }
}
