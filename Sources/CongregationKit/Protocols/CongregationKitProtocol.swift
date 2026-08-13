import Congregation
import Foundation

/// Protocol defining the interface for church Salesforce integration
///
/// Provides access to member, seeker, file, and v2 resource handlers for Salesforce operations.
public protocol CongregationKitProtocol: Sendable {
    /// The members handler for member operations
    var members: MembersHandler { get }
    /// The seekers handler for seeker operations
    var seekers: SeekersHandler { get }
    /// The files handler for file operations
    var files: FilesHandler { get }
    /// Follow-up tasks for church ops work queues (v2)
    var tasks: TasksHandler { get }
    /// Church ops staff users (v2, read-only)
    var users: UsersHandler { get }
    /// Course records (v2)
    var courses: CoursesHandler { get }
    /// Family information records (v2 `Family_Information__c`)
    var familyRecords: FamilyRecordsHandler { get }
    /// Spiritual information records (v2)
    var spiritualRecords: SpiritualRecordsHandler { get }
}
