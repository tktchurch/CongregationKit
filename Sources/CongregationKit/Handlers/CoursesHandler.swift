import Congregation
import Foundation
import SalesforceClient

/// Salesforce-backed implementation of ``Congregation/CoursesHandler``.
public struct SalesforceCoursesHandler: CoursesHandler {
    private let salesforceClient: SalesforceClient
    private let accessToken: String
    private let instanceUrl: String

    public init(salesforceClient: SalesforceClient, accessToken: String, instanceUrl: String) {
        self.salesforceClient = salesforceClient
        self.accessToken = accessToken
        self.instanceUrl = instanceUrl
    }

    public func fetchAll(query: SyncQuery) async throws -> SyncPage<Course> {
        try await salesforceClient.v2.listCourses(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            query: query
        )
    }

    public func fetch(id: CourseID, query: SyncQuery?) async throws -> Course {
        try await salesforceClient.v2.getCourse(
            accessToken: accessToken,
            instanceUrl: instanceUrl,
            courseId: id,
            query: query
        )
    }
}
