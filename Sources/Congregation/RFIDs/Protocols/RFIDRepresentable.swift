import Foundation

/// Protocol for types that can provide RFID information.
///
/// This protocol allows different types to expose RFID-related properties
/// in a standardized way, supporting flexible data access patterns.
///
/// ## Overview
///
/// Types conforming to this protocol can represent:
/// - RFID cards themselves
/// - Members with associated RFID cards
/// - Data transfer objects with RFID information
///
/// ## Example Usage
///
/// ```swift
/// struct MemberWithRFID: RFIDRepresentable {
///     let member: Member
///     let rfid: RFID
///
///     var rfidId: RFIDID? { rfid.id }
///     var tagNumber: String? { rfid.tagNumber }
///     var rfidStatus: RFIDStatus? { rfid.status }
///     var rfidIssueDate: Date? { rfid.issueDate }
///     var rfidExpiryDate: Date? { rfid.expiryDate }
/// }
/// ```
public protocol RFIDRepresentable {
    /// The unique identifier for the RFID record.
    var rfidId: RFIDID? { get }

    /// The physical RFID tag number.
    var tagNumber: String? { get }

    /// Current status of the RFID card.
    var rfidStatus: RFIDStatus? { get }

    /// Date when the card was issued.
    var rfidIssueDate: Date? { get }

    /// Date when the card expires.
    var rfidExpiryDate: Date? { get }

    /// Whether this is the primary card.
    var isPrimaryRFID: Bool? { get }

    /// Type or category of the card.
    var cardType: String? { get }
}

// Default implementations for optional conformance
extension RFIDRepresentable {
    /// Whether the RFID card is currently active and usable.
    public var isRFIDActive: Bool {
        rfidStatus?.isUsable ?? false
    }

    /// Whether the RFID card is expired.
    public var isRFIDExpired: Bool {
        guard let expiryDate = rfidExpiryDate else { return false }
        return expiryDate < Date()
    }

    /// Days until the RFID card expires.
    public var daysUntilRFIDExpiry: Int? {
        guard let expiryDate = rfidExpiryDate, expiryDate > Date() else { return nil }
        let components = Calendar.current.dateComponents([.day], from: Date(), to: expiryDate)
        return components.day
    }
}
