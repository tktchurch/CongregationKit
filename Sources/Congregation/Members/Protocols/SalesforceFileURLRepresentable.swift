import Foundation

/// Protocol for Salesforce file URL handling
public protocol SalesforceFileURLRepresentable: Sendable {
    /// The original URL
    var url: String { get }
    /// The extracted record ID (eid) from Salesforce file URLs, if available
    var recordId: String? { get }
    /// Whether this is a Salesforce file URL
    var isSalesforceFileURL: Bool { get }
} 