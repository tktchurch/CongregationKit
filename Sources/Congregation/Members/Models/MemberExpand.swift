import Foundation

/// Enum specifying which related information to expand for a member fetch.
public enum MemberExpand: String, Codable, Sendable {
    /// Expand employment information
    case employmentInformation
    /// Expand contact information
    case contactInformation
    /// Expand martial information
    case martialInformation
    /// Expand discipleship and spiritual information
    case discipleshipInformation
}