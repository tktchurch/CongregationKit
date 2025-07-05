import Foundation

/// Protocol defining the interface for church Salesforce integration
public protocol CongregationKitProtocol: Sendable {
    /// The members handler for member operations
    var members: MembersHandler { get }
    /// The seekers handler for seeker operations
    var seekers: SeekersHandler { get }
}
