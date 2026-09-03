import AsyncHTTPClient
import Congregation
import Foundation
import NIOCore
import NIOHTTP1

/// Low-level HTTP transport for TKT API v2 (`/services/apexrest/v2`).
public struct TktApiV2Client: Sendable {
    private let handler: SalesforceAPIHandler

    public init(handler: SalesforceAPIHandler) {
        self.handler = handler
    }

    public func listMembers(
        accessToken: String,
        instanceUrl: String,
        query: SyncQuery,
        filters: MemberListQuery?
    ) async throws -> SyncPage<Member> {
        let params = query.asQueryParameters(extra: filters?.asQueryParameters() ?? [:])
        let envelope: MemberListEnvelope = try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "members"),
            queryParams: params,
            accessToken: accessToken,
            as: MemberListEnvelope.self
        )
        return envelope.asSyncPage
    }

    public func getMember(
        accessToken: String,
        instanceUrl: String,
        memberId: MemberID,
        query: SyncQuery?,
        expand: [MemberExpand] = []
    ) async throws -> Member {
        var extra: [String: String] = [:]
        let tokens = expand.compactMap(\.serverExpandToken)
        if !tokens.isEmpty {
            extra["expand"] = tokens.joined(separator: ",")
        }
        let params = query?.asQueryParameters(extra: extra) ?? extra
        return try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "members", id: memberId.rawValue),
            queryParams: params,
            accessToken: accessToken,
            as: Member.self
        )
    }

    public func listSeekers(
        accessToken: String,
        instanceUrl: String,
        query: SyncQuery,
        filters: SeekerListQuery?
    ) async throws -> SyncPage<Seeker> {
        let params = query.asQueryParameters(extra: filters?.asQueryParameters() ?? [:])
        let envelope: SeekerListEnvelope = try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "seekers"),
            queryParams: params,
            accessToken: accessToken,
            as: SeekerListEnvelope.self
        )
        return envelope.asSyncPage
    }

    public func getSeeker(
        accessToken: String,
        instanceUrl: String,
        seekerId: String,
        query: SyncQuery?
    ) async throws -> Seeker {
        let params = query?.asQueryParameters() ?? [:]
        return try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "seekers", id: seekerId),
            queryParams: params,
            accessToken: accessToken,
            as: Seeker.self
        )
    }

    public func createSeeker(
        accessToken: String,
        instanceUrl: String,
        seeker: Seeker,
        options: SyncWriteOptions?
    ) async throws -> Seeker {
        let body = try encodeJSON(seeker)
        let response = try await handler.sendRequest(
            method: .POST,
            path: v2URL(instanceUrl: instanceUrl, collection: "seekers"),
            body: body,
            headers: SalesforceAPIHandler.v2Headers(accessToken: accessToken, options: options)
        )
        return try await handler.processV2Response(response, as: Seeker.self)
    }

    public func listSeekerHistory(
        accessToken: String,
        instanceUrl: String,
        seekerId: String
    ) async throws -> SeekerHistoryPage {
        try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "seekers", id: seekerId, suffix: "history"),
            queryParams: [:],
            accessToken: accessToken,
            as: SeekerHistoryPage.self
        )
    }

    public func completeLeadStatus(
        accessToken: String,
        instanceUrl: String,
        seekerId: String,
        options: SyncWriteOptions?
    ) async throws -> Seeker {
        let response = try await handler.sendRequest(
            method: .POST,
            path: v2URL(instanceUrl: instanceUrl, collection: "seekers", id: "\(seekerId):completeLeadStatus"),
            headers: SalesforceAPIHandler.v2Headers(accessToken: accessToken, options: options)
        )
        return try await handler.processV2Response(response, as: Seeker.self)
    }

    public func updateSeeker(
        accessToken: String,
        instanceUrl: String,
        seekerId: String,
        body: [String: String],
        options: SyncWriteOptions?
    ) async throws -> Seeker {
        var queryParams: [String: String] = [:]
        if let mask = options?.updateMask, !mask.isEmpty {
            queryParams["updateMask"] = mask.joined(separator: ",")
        }
        let payload = try encodeJSON(body)
        let response = try await handler.sendRequest(
            method: .PATCH,
            path: v2URL(instanceUrl: instanceUrl, collection: "seekers", id: seekerId),
            queryParams: queryParams.isEmpty ? nil : queryParams,
            body: payload,
            headers: SalesforceAPIHandler.v2Headers(accessToken: accessToken, options: options)
        )
        return try await handler.processV2Response(response, as: Seeker.self)
    }

    public func listTasks(
        accessToken: String,
        instanceUrl: String,
        query: SyncQuery,
        filters: FollowUpTaskQuery?
    ) async throws -> SyncPage<FollowUpTask> {
        let params = query.asQueryParameters(extra: filters?.asQueryParameters() ?? [:])
        let envelope: FollowUpTaskListEnvelope = try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "tasks"),
            queryParams: params,
            accessToken: accessToken,
            as: FollowUpTaskListEnvelope.self
        )
        return envelope.asSyncPage
    }

    public func getTask(
        accessToken: String,
        instanceUrl: String,
        taskId: FollowUpTaskID,
        query: SyncQuery?
    ) async throws -> FollowUpTask {
        let params = query?.asQueryParameters() ?? [:]
        return try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "tasks", id: taskId.rawValue),
            queryParams: params,
            accessToken: accessToken,
            as: FollowUpTask.self
        )
    }

    public func listTaskHistory(
        accessToken: String,
        instanceUrl: String,
        taskId: FollowUpTaskID
    ) async throws -> TaskHistoryPage {
        try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "tasks", id: taskId.rawValue, suffix: "history"),
            queryParams: [:],
            accessToken: accessToken,
            as: TaskHistoryPage.self
        )
    }

    public func listTasksForMember(
        accessToken: String,
        instanceUrl: String,
        memberId: MemberID,
        query: SyncQuery
    ) async throws -> SyncPage<FollowUpTask> {
        let params = query.asQueryParameters()
        let envelope: FollowUpTaskListEnvelope = try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "members", id: memberId.rawValue, suffix: "tasks"),
            queryParams: params,
            accessToken: accessToken,
            as: FollowUpTaskListEnvelope.self
        )
        return envelope.asSyncPage
    }

    public func listTasksForSeeker(
        accessToken: String,
        instanceUrl: String,
        seekerId: String,
        query: SyncQuery
    ) async throws -> SyncPage<FollowUpTask> {
        let params = query.asQueryParameters()
        let envelope: FollowUpTaskListEnvelope = try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "seekers", id: seekerId, suffix: "tasks"),
            queryParams: params,
            accessToken: accessToken,
            as: FollowUpTaskListEnvelope.self
        )
        return envelope.asSyncPage
    }

    public func listTasksForStaffUser(
        accessToken: String,
        instanceUrl: String,
        staffUserId: StaffUserID,
        query: SyncQuery
    ) async throws -> SyncPage<FollowUpTask> {
        let params = query.asQueryParameters()
        let envelope: FollowUpTaskListEnvelope = try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "users", id: staffUserId.rawValue, suffix: "tasks"),
            queryParams: params,
            accessToken: accessToken,
            as: FollowUpTaskListEnvelope.self
        )
        return envelope.asSyncPage
    }

    public func completeTask(
        accessToken: String,
        instanceUrl: String,
        taskId: FollowUpTaskID,
        options: SyncWriteOptions?
    ) async throws -> FollowUpTask {
        let response = try await handler.sendRequest(
            method: .POST,
            path: v2URL(instanceUrl: instanceUrl, collection: "tasks", id: "\(taskId.rawValue):complete"),
            headers: SalesforceAPIHandler.v2Headers(accessToken: accessToken, options: options)
        )
        return try await handler.processV2Response(response, as: FollowUpTask.self)
    }

    public func reassignTask(
        accessToken: String,
        instanceUrl: String,
        taskId: FollowUpTaskID,
        ownerId: StaffUserID,
        options: SyncWriteOptions?
    ) async throws -> FollowUpTask {
        let payload = try encodeJSON(["ownerId": ownerId.rawValue])
        let response = try await handler.sendRequest(
            method: .POST,
            path: v2URL(instanceUrl: instanceUrl, collection: "tasks", id: "\(taskId.rawValue):reassign"),
            body: payload,
            headers: SalesforceAPIHandler.v2Headers(accessToken: accessToken, options: options)
        )
        return try await handler.processV2Response(response, as: FollowUpTask.self)
    }

    public func listUsers(
        accessToken: String,
        instanceUrl: String,
        query: SyncQuery,
        filters: StaffUserListQuery?
    ) async throws -> SyncPage<StaffUser> {
        let params = query.asQueryParameters(extra: filters?.asQueryParameters() ?? [:])
        let envelope: StaffUserListEnvelope = try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "users"),
            queryParams: params,
            accessToken: accessToken,
            as: StaffUserListEnvelope.self
        )
        return envelope.asSyncPage
    }

    public func getUser(
        accessToken: String,
        instanceUrl: String,
        userId: StaffUserID,
        query: SyncQuery?
    ) async throws -> StaffUser {
        let params = query?.asQueryParameters() ?? [:]
        return try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "users", id: userId.rawValue),
            queryParams: params,
            accessToken: accessToken,
            as: StaffUser.self
        )
    }

    public func getCurrentUser(
        accessToken: String,
        instanceUrl: String,
        query: SyncQuery?
    ) async throws -> StaffUser {
        let params = query?.asQueryParameters() ?? [:]
        return try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "users", id: "me"),
            queryParams: params,
            accessToken: accessToken,
            as: StaffUser.self
        )
    }

    public func listCourses(
        accessToken: String,
        instanceUrl: String,
        query: SyncQuery,
        memberId: String? = nil
    ) async throws -> SyncPage<Course> {
        var extra: [String: String] = [:]
        if let memberId { extra["memberId"] = memberId }
        let params = query.asQueryParameters(extra: extra)
        let envelope: CourseListEnvelope = try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "courses"),
            queryParams: params,
            accessToken: accessToken,
            as: CourseListEnvelope.self
        )
        return envelope.asSyncPage
    }

    public func getCourse(
        accessToken: String,
        instanceUrl: String,
        courseId: CourseID,
        query: SyncQuery?
    ) async throws -> Course {
        let params = query?.asQueryParameters() ?? [:]
        return try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "courses", id: courseId.rawValue),
            queryParams: params,
            accessToken: accessToken,
            as: Course.self
        )
    }

    public func listFamilies(
        accessToken: String,
        instanceUrl: String,
        query: SyncQuery,
        memberId: String? = nil
    ) async throws -> SyncPage<FamilyRecord> {
        var extra: [String: String] = [:]
        if let memberId { extra["memberId"] = memberId }
        let params = query.asQueryParameters(extra: extra)
        let envelope: FamilyRecordListEnvelope = try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "families"),
            queryParams: params,
            accessToken: accessToken,
            as: FamilyRecordListEnvelope.self
        )
        return envelope.asSyncPage
    }

    public func getFamily(
        accessToken: String,
        instanceUrl: String,
        familyId: FamilyRecordID,
        query: SyncQuery?
    ) async throws -> FamilyRecord {
        let params = query?.asQueryParameters() ?? [:]
        return try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "families", id: familyId.rawValue),
            queryParams: params,
            accessToken: accessToken,
            as: FamilyRecord.self
        )
    }

    public func listSpiritualRecords(
        accessToken: String,
        instanceUrl: String,
        query: SyncQuery,
        memberId: String? = nil
    ) async throws -> SyncPage<SpiritualRecord> {
        var extra: [String: String] = [:]
        if let memberId { extra["memberId"] = memberId }
        let params = query.asQueryParameters(extra: extra)
        let envelope: SpiritualRecordListEnvelope = try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "spiritual-records"),
            queryParams: params,
            accessToken: accessToken,
            as: SpiritualRecordListEnvelope.self
        )
        return envelope.asSyncPage
    }

    public func getSpiritualRecord(
        accessToken: String,
        instanceUrl: String,
        recordId: SpiritualRecordID,
        query: SyncQuery?
    ) async throws -> SpiritualRecord {
        let params = query?.asQueryParameters() ?? [:]
        return try await get(
            path: v2URL(instanceUrl: instanceUrl, collection: "spiritual-records", id: recordId.rawValue),
            queryParams: params,
            accessToken: accessToken,
            as: SpiritualRecord.self
        )
    }

    // MARK: - Private

    private func get<T: Decodable & Sendable>(
        path: String,
        queryParams: [String: String],
        accessToken: String,
        as type: T.Type
    ) async throws -> T {
        let response = try await handler.sendRequest(
            method: .GET,
            path: path,
            queryParams: queryParams,
            headers: SalesforceAPIHandler.v2Headers(accessToken: accessToken)
        )
        return try await handler.processV2Response(response, as: type)
    }

    private func v2URL(instanceUrl: String, collection: String, id: String? = nil, suffix: String? = nil) -> String {
        var path = instanceUrl + SalesforceAPIConstants.apiV2Base + "/" + collection
        if let id {
            let encoded = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? id
            path += "/" + encoded
        }
        if let suffix {
            path += "/" + suffix
        }
        return path
    }

    private func encodeJSON<T: Encodable>(_ value: T) throws -> HTTPClientRequest.Body {
        let data = try JSONEncoder().encode(value)
        var buffer = ByteBufferAllocator().buffer(capacity: data.count)
        buffer.writeBytes(data)
        return .bytes(buffer)
    }
}
