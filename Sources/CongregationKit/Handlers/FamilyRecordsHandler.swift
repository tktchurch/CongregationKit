import Congregation
import Foundation
import SalesforceClient

/// Salesforce-backed implementation of ``Congregation/FamilyRecordsHandler``.
public struct SalesforceFamilyRecordsHandler: FamilyRecordsHandler {
    private let salesforceClient: SalesforceClient
    private let accessToken: String
    private let instanceUrl: String

    public init(salesforceClient: SalesforceClient, accessToken: String, instanceUrl: String) {
        self.salesforceClient = salesforceClient
        self.accessToken = accessToken
        self.instanceUrl = instanceUrl
    }

    public func fetchAll(query: SyncQuery) async throws -> SyncPage<FamilyRecord> {
        try await salesforceClient.v2.listFamilies(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            query: query
        )
    }

    public func fetch(id: FamilyRecordID, query: SyncQuery?) async throws -> FamilyRecord {
        try await salesforceClient.v2.getFamily(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            familyId: id,
            query: query
        )
    }
}
