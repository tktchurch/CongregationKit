import Foundation

/// Protocol defining the interface for church Salesforce integration
///
/// Provides access to member and seeker handlers for Salesforce operations.
public protocol CongregationKitProtocol: Sendable {
    /// The members handler for member operations
    var members: MembersHandler { get }
    /// The seekers handler for seeker operations
    var seekers: SeekersHandler { get }
}
