import Foundation

/// Represents the association between a member and their RFID cards.
///
/// This struct tracks the relationship between members and their RFID cards,
/// supporting multiple cards per member and card history tracking.
///
/// ## Overview
///
/// The `MemberRFID` struct provides:
/// - **Member-Card Linking:** Associates cards with specific members
/// - **History Tracking:** Maintains card assignment history
/// - **Card Lifecycle:** Tracks when cards were assigned and returned
/// - **Primary Card:** Identifies the currently active primary card
///
/// ## Example Usage
///
/// ```swift
/// let memberRFID = MemberRFID(
///     memberId: MemberID(rawValue: "TKT123456")!,
///     rfidId: RFIDID(rawValue: "RFID001")!,
///     assignedDate: Date(),
///     isPrimary: true,
///     isActive: true
/// )
///
/// // Check if this is the primary card
/// if memberRFID.isPrimary {
///     print("This is the member's primary card")
/// }
///
/// // Calculate how long the member has had this card
/// if let days = memberRFID.assignmentDurationInDays {
///     print("Card assigned for \(days) days")
/// }
/// ```
public struct MemberRFID: Codable, Equatable, Sendable {
    /// The member who owns/uses this RFID card.
    public let memberId: MemberID

    /// The RFID card assigned to the member.
    public let rfidId: RFIDID

    /// Date when the card was assigned to the member.
    public let assignedDate: Date?

    /// Date when the card was returned by the member (if applicable).
    public let returnedDate: Date?

    /// Whether this is the member's primary/active card.
    public let isPrimary: Bool

    /// Whether this assignment is currently active.
    public let isActive: Bool

    /// Reason for returning/deactivating the card (if applicable).
    public let returnReason: String?

    /// Who assigned the card (staff member ID or name).
    public let assignedBy: String?

    /// Who received the returned card (staff member ID or name).
    public let returnedTo: String?

    /// Additional notes about this assignment.
    public let notes: String?

    /// Creates a new MemberRFID instance.
    ///
    /// - Parameters:
    ///   - memberId: The member's ID
    ///   - rfidId: The RFID's ID
    ///   - assignedDate: When the card was assigned
    ///   - returnedDate: When the card was returned
    ///   - isPrimary: Whether this is the primary card
    ///   - isActive: Whether this assignment is active
    ///   - returnReason: Reason for return
    ///   - assignedBy: Who assigned the card
    ///   - returnedTo: Who received the returned card
    ///   - notes: Additional notes
    public init(
        memberId: MemberID,
        rfidId: RFIDID,
        assignedDate: Date? = nil,
        returnedDate: Date? = nil,
        isPrimary: Bool = false,
        isActive: Bool = true,
        returnReason: String? = nil,
        assignedBy: String? = nil,
        returnedTo: String? = nil,
        notes: String? = nil
    ) {
        self.memberId = memberId
        self.rfidId = rfidId
        self.assignedDate = assignedDate
        self.returnedDate = returnedDate
        self.isPrimary = isPrimary
        self.isActive = isActive
        self.returnReason = returnReason
        self.assignedBy = assignedBy
        self.returnedTo = returnedTo
        self.notes = notes
    }

    /// Duration of card assignment in days.
    public var assignmentDurationInDays: Int? {
        guard let assigned = assignedDate else { return nil }
        let end = returnedDate ?? Date()
        let components = Calendar.current.dateComponents([.day], from: assigned, to: end)
        return components.day
    }

    /// Whether the card is currently assigned to the member.
    public var isCurrentlyAssigned: Bool {
        isActive && returnedDate == nil
    }
}
