import Foundation

/// Represents the current status of an RFID card.
///
/// This enum provides a comprehensive set of states that an RFID card can be in,
/// supporting lifecycle management from issuance to deactivation.
///
/// ## Overview
///
/// The `RFIDStatus` enum supports:
/// - **Active Management:** Track which cards are currently usable
/// - **Security:** Mark cards as lost, stolen, or blocked
/// - **Lifecycle:** Track cards through issuance, activation, and deactivation
/// - **Auditing:** Maintain card status history
///
/// ## Example Usage
///
/// ```swift
/// let rfid = RFID(
///     id: RFIDID(rawValue: "RFID001")!,
///     tagNumber: "1234567890",
///     status: .active
/// )
///
/// // Check if card can be used
/// if rfid.status.isUsable {
///     print("Card is active and can be used")
/// }
///
/// // Display status to user
/// print("Status: \(rfid.status.displayName)")
/// ```
public enum RFIDStatus: String, Codable, CaseIterable, Sendable {
    /// Card is active and can be used
    case active = "Active"

    /// Card is inactive but not permanently disabled
    case inactive = "Inactive"

    /// Card has been reported as lost
    case lost = "Lost"

    /// Card has been reported as stolen
    case stolen = "Stolen"

    /// Card has been blocked by administrator
    case blocked = "Blocked"

    /// Card has been permanently deactivated
    case deactivated = "Deactivated"

    /// Card has been issued but not yet activated
    case pending = "Pending"

    /// Card has been damaged and needs replacement
    case damaged = "Damaged"

    /// Card has expired
    case expired = "Expired"

    /// Human-readable display name for the status
    public var displayName: String {
        rawValue
    }

    /// Whether the RFID card can currently be used
    public var isUsable: Bool {
        switch self {
        case .active:
            return true
        case .inactive, .lost, .stolen, .blocked, .deactivated, .pending, .damaged, .expired:
            return false
        }
    }

    /// Whether the card status requires immediate attention
    public var requiresAttention: Bool {
        switch self {
        case .lost, .stolen, .blocked, .damaged:
            return true
        case .active, .inactive, .deactivated, .pending, .expired:
            return false
        }
    }

    /// Color code for UI display purposes
    public var colorCode: String {
        switch self {
        case .active:
            return "green"
        case .inactive, .pending:
            return "gray"
        case .lost, .stolen, .blocked:
            return "red"
        case .deactivated, .expired:
            return "darkGray"
        case .damaged:
            return "orange"
        }
    }
}
