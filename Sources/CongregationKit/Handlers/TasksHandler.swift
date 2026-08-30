import Congregation
import Foundation
import SalesforceClient

/// Salesforce-backed implementation of ``Congregation/TasksHandler``.
public struct SalesforceTasksHandler: TasksHandler {
    private let salesforceClient: SalesforceClient
    private let accessToken: String
    private let instanceUrl: String

    public init(salesforceClient: SalesforceClient, accessToken: String, instanceUrl: String) {
        self.salesforceClient = salesforceClient
        self.accessToken = accessToken
        self.instanceUrl = instanceUrl
    }

    public func fetchAll(query: SyncQuery, filters: FollowUpTaskQuery?) async throws -> SyncPage<FollowUpTask> {
        try await salesforceClient.v2.listTasks(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            query: query,
            filters: filters
        )
    }

    public func fetch(id: FollowUpTaskID, query: SyncQuery?) async throws -> FollowUpTask {
        try await salesforceClient.v2.getTask(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            taskId: id,
            query: query
        )
    }

    public func fetchForMember(memberId: MemberID, query: SyncQuery) async throws -> SyncPage<FollowUpTask> {
        try await salesforceClient.v2.listTasksForMember(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            memberId: memberId,
            query: query
        )
    }

    public func fetchForSeeker(seekerId: String, query: SyncQuery) async throws -> SyncPage<FollowUpTask> {
        try await salesforceClient.v2.listTasksForSeeker(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            seekerId: seekerId,
            query: query
        )
    }

    public func fetchForStaffUser(staffUserId: StaffUserID, query: SyncQuery) async throws -> SyncPage<FollowUpTask> {
        try await salesforceClient.v2.listTasksForStaffUser(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            staffUserId: staffUserId,
            query: query
        )
    }

    public func complete(id: FollowUpTaskID, options: SyncWriteOptions?) async throws -> FollowUpTask {
        try await salesforceClient.v2.completeTask(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            taskId: id,
            options: options
        )
    }

    public func reassign(id: FollowUpTaskID, ownerId: StaffUserID, options: SyncWriteOptions?) async throws -> FollowUpTask {
        try await salesforceClient.v2.reassignTask(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            taskId: id,
            ownerId: ownerId,
            options: options
        )
    }
}
