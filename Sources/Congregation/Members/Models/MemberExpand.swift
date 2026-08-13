import Foundation

/// Enum specifying which related information to expand for a member fetch.
///
/// Client-side cases (contact/employment/marital/discipleship) filter nested
/// structs after decode. Server-side cases (`family`, `spiritualRecords`,
/// `courses`, `tasks`) are sent as `?expand=` on `GET /v2/members/{id}`.
public enum MemberExpand: String, Codable, Sendable {
    /// Expand employment information
    case employmentInformation
    /// Expand contact information
    case contactInformation
    /// Expand martial information
    case martialInformation
    /// Expand discipleship and spiritual information
    case discipleshipInformation
    /// Embed related `/v2/families` rows
    case family
    /// Embed related `/v2/spiritual-records` rows
    case spiritualRecords
    /// Embed related `/v2/courses` rows
    case courses
    /// Embed related `/v2/tasks` rows
    case tasks

    /// Query token for GET member `expand` (nil for client-side-only cases).
    public var serverExpandToken: String? {
        switch self {
        case .family: return "family"
        case .spiritualRecords: return "spiritualRecords"
        case .courses: return "courses"
        case .tasks: return "tasks"
        case .employmentInformation, .contactInformation, .martialInformation, .discipleshipInformation:
            return nil
        }
    }
}
