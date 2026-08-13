import Congregation
import Foundation
import SalesforceClient

/// Salesforce-backed implementation of ``Congregation/UsersHandler``.
public struct SalesforceUsersHandler: UsersHandler {
    private let salesforceClient: SalesforceClient
    private let accessToken: String
    private let instanceUrl: String

    public init(salesforceClient: SalesforceClient, accessToken: String, instanceUrl: String) {
        self.salesforceClient = salesforceClient
        self.accessToken = accessToken
        self.instanceUrl = instanceUrl
    }

    public func fetchAll(query: SyncQuery, filters: StaffUserListQuery?) async throws -> SyncPage<StaffUser> {
        try await salesforceClient.v2.listUsers(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            query: query,
            filters: filters
        )
    }

    public func fetch(id: StaffUserID, query: SyncQuery?) async throws -> StaffUser {
        try await salesforceClient.v2.getUser(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            userId: id,
            query: query
        )
    }

    public func fetchMe(query: SyncQuery?) async throws -> StaffUser {
        try await salesforceClient.v2.getCurrentUser(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            query: query
        )
    }
}
