import Congregation
import Foundation
import SalesforceClient

/// Salesforce-backed implementation of ``Congregation/SpiritualRecordsHandler``.
public struct SalesforceSpiritualRecordsHandler: SpiritualRecordsHandler {
    private let salesforceClient: SalesforceClient
    private let accessToken: String
    private let instanceUrl: String

    public init(salesforceClient: SalesforceClient, accessToken: String, instanceUrl: String) {
        self.salesforceClient = salesforceClient
        self.accessToken = accessToken
        self.instanceUrl = instanceUrl
    }

    public func fetchAll(query: SyncQuery) async throws -> SyncPage<SpiritualRecord> {
        try await salesforceClient.v2.listSpiritualRecords(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            query: query
        )
    }

    public func fetch(id: SpiritualRecordID, query: SyncQuery?) async throws -> SpiritualRecord {
        try await salesforceClient.v2.getSpiritualRecord(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            recordId: id,
            query: query
        )
    }
}
