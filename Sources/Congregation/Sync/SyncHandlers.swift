import Foundation

/// List envelope for v2 member responses.
public struct MemberListEnvelope: Decodable, Sendable {
    public let members: [Member]
    public let nextPageToken: String?
    public let prevPageToken: String?
    public let totalSize: Int?
}

/// List envelope for v2 seeker responses.
public struct SeekerListEnvelope: Decodable, Sendable {
    let seekers: [Seeker]
    let nextPageToken: String?
    let prevPageToken: String?
    let totalSize: Int?
}

/// List envelope for v2 task responses.
public struct FollowUpTaskListEnvelope: Decodable, Sendable {
    let tasks: [FollowUpTask]
    let nextPageToken: String?
    let prevPageToken: String?
    let totalSize: Int?
}

/// List envelope for v2 user responses.
public struct StaffUserListEnvelope: Decodable, Sendable {
    let users: [StaffUser]
    let nextPageToken: String?
    let prevPageToken: String?
    let totalSize: Int?
}

/// List envelope for v2 course responses.
public struct CourseListEnvelope: Decodable, Sendable {
    let courses: [Course]
    let nextPageToken: String?
    let prevPageToken: String?
    let totalSize: Int?
}

/// List envelope for v2 family responses.
public struct FamilyRecordListEnvelope: Decodable, Sendable {
    let families: [FamilyRecord]
    let nextPageToken: String?
    let prevPageToken: String?
    let totalSize: Int?
}

/// List envelope for v2 spiritual record responses.
public struct SpiritualRecordListEnvelope: Decodable, Sendable {
    let spiritualRecords: [SpiritualRecord]
    let nextPageToken: String?
    let prevPageToken: String?
    let totalSize: Int?
}

extension MemberListEnvelope {
    public var asSyncPage: SyncPage<Member> {
        SyncPage(records: members, nextPageToken: nextPageToken, prevPageToken: prevPageToken, totalSize: totalSize)
    }
}

extension SeekerListEnvelope {
    public var asSyncPage: SyncPage<Seeker> {
        SyncPage(records: seekers, nextPageToken: nextPageToken, prevPageToken: prevPageToken, totalSize: totalSize)
    }
}

extension FollowUpTaskListEnvelope {
    public var asSyncPage: SyncPage<FollowUpTask> {
        SyncPage(records: tasks, nextPageToken: nextPageToken, prevPageToken: prevPageToken, totalSize: totalSize)
    }
}

extension StaffUserListEnvelope {
    public var asSyncPage: SyncPage<StaffUser> {
        SyncPage(records: users, nextPageToken: nextPageToken, prevPageToken: prevPageToken, totalSize: totalSize)
    }
}

extension CourseListEnvelope {
    public var asSyncPage: SyncPage<Course> {
        SyncPage(records: courses, nextPageToken: nextPageToken, prevPageToken: prevPageToken, totalSize: totalSize)
    }
}

extension FamilyRecordListEnvelope {
    public var asSyncPage: SyncPage<FamilyRecord> {
        SyncPage(records: families, nextPageToken: nextPageToken, prevPageToken: prevPageToken, totalSize: totalSize)
    }
}

extension SpiritualRecordListEnvelope {
    public var asSyncPage: SyncPage<SpiritualRecord> {
        SyncPage(records: spiritualRecords, nextPageToken: nextPageToken, prevPageToken: prevPageToken, totalSize: totalSize)
    }
}

/// v2 sync-capable member operations (framework-agnostic protocol).
public protocol MembersSyncHandler: Sendable {
    func fetchAll(query: SyncQuery, filters: MemberListQuery?) async throws -> SyncPage<Member>
    func fetch(id: MemberID, query: SyncQuery?) async throws -> Member
}

/// v2 sync-capable seeker operations.
public protocol SeekersSyncHandler: Sendable {
    func fetchAll(query: SyncQuery, filters: SeekerListQuery?) async throws -> SyncPage<Seeker>
    func fetch(id: String, query: SyncQuery?) async throws -> Seeker
    func create(_ seeker: Seeker, options: SyncWriteOptions?) async throws -> Seeker
    func listHistory(id: String) async throws -> SeekerHistoryPage
    func completeLeadStatus(id: String, options: SyncWriteOptions?) async throws -> Seeker
    func update(id: String, body: [String: String], options: SyncWriteOptions?) async throws -> Seeker
}

/// v2 follow-up task operations for church ops work queues.
public protocol TasksHandler: Sendable {
    func fetchAll(query: SyncQuery, filters: FollowUpTaskQuery?) async throws -> SyncPage<FollowUpTask>
    func fetch(id: FollowUpTaskID, query: SyncQuery?) async throws -> FollowUpTask
    func fetchForMember(memberId: MemberID, query: SyncQuery) async throws -> SyncPage<FollowUpTask>
    func fetchForSeeker(seekerId: String, query: SyncQuery) async throws -> SyncPage<FollowUpTask>
    func fetchForStaffUser(staffUserId: StaffUserID, query: SyncQuery) async throws -> SyncPage<FollowUpTask>
    func complete(id: FollowUpTaskID, options: SyncWriteOptions?) async throws -> FollowUpTask
    func reassign(id: FollowUpTaskID, ownerId: StaffUserID, options: SyncWriteOptions?) async throws -> FollowUpTask
}

/// v2 read-only staff user operations.
public protocol UsersHandler: Sendable {
    func fetchAll(query: SyncQuery, filters: StaffUserListQuery?) async throws -> SyncPage<StaffUser>
    func fetch(id: StaffUserID, query: SyncQuery?) async throws -> StaffUser
    func fetchMe(query: SyncQuery?) async throws -> StaffUser
}

/// v2 course operations.
public protocol CoursesHandler: Sendable {
    func fetchAll(query: SyncQuery) async throws -> SyncPage<Course>
    func fetch(id: CourseID, query: SyncQuery?) async throws -> Course
}

/// v2 family information record operations.
public protocol FamilyRecordsHandler: Sendable {
    func fetchAll(query: SyncQuery) async throws -> SyncPage<FamilyRecord>
    func fetch(id: FamilyRecordID, query: SyncQuery?) async throws -> FamilyRecord
}

/// v2 spiritual information record operations.
public protocol SpiritualRecordsHandler: Sendable {
    func fetchAll(query: SyncQuery) async throws -> SyncPage<SpiritualRecord>
    func fetch(id: SpiritualRecordID, query: SyncQuery?) async throws -> SpiritualRecord
}
