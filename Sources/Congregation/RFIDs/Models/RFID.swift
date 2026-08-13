import Foundation

/// An RFID card/tag in the congregation domain (framework-agnostic).
///
/// Salesforce v2 `/families` only exposes ``FamilyRecord/cardIssued`` (a boolean).
/// That snapshot is not a substitute for this model: tag number, status, issue/
/// activate/block, and expiry live here. Implement ``RFIDsHandler`` in the app
/// or a future backend — CongregationKit does not map RFID to Salesforce v2.
///
/// RFID cards provide contactless identification for members, enabling
/// automated attendance tracking, access control, and event check-ins.
///
/// ## Overview
///
/// The `RFID` struct provides:
/// - **Card Identity:** Unique ID and tag number
/// - **Status Management:** Current card status (active, lost, etc.)
/// - **Member Association:** Link to the card holder
/// - **Lifecycle Tracking:** Issue date, activation date, expiry date
/// - **Security:** Block status and reason tracking
/// - **Timestamps:** Creation and modification tracking
///
/// ## Example Usage
///
/// ```swift
/// let rfid = RFID(
///     id: RFIDID(rawValue: "RFID001")!,
///     tagNumber: "1234567890ABCD",
///     memberId: MemberID(rawValue: "TKT123456")!,
///     status: .active,
///     issueDate: Date(),
///     expiryDate: Calendar.current.date(byAdding: .year, value: 5, to: Date())
/// )
///
/// // Check if card is active
/// if rfid.status.isUsable {
///     print("Card is active and ready to use")
/// }
///
/// // Check expiry
/// if let daysUntilExpiry = rfid.daysUntilExpiry {
///     print("Card expires in \(daysUntilExpiry) days")
/// }
/// ```
public struct RFID: Codable, Equatable, Sendable, Identifiable {
    /// Unique identifier for this RFID record.
    public let id: RFIDID

    /// The physical RFID tag number (unique identifier on the card/tag).
    public let tagNumber: String

    /// The member ID of the card holder.
    public let memberId: MemberID

    /// Current status of the RFID card.
    public let status: RFIDStatus

    /// Date when the card was issued.
    public let issueDate: Date?

    /// Date when the card was activated (if different from issue date).
    public let activationDate: Date?

    /// Date when the card expires.
    public let expiryDate: Date?

    /// Date when the card was deactivated (if applicable).
    public let deactivationDate: Date?

    /// Reason for blocking/deactivation (if applicable).
    public let blockReason: String?

    /// Date when this record was created.
    public let createdDate: Date?

    /// Date when this record was last modified.
    public let lastModifiedDate: Date?

    /// Optional notes about this RFID card.
    public let notes: String?

    /// The type or category of the RFID card (e.g., "Member Card", "Staff Card", "Visitor Pass").
    public let cardType: String?

    /// Whether this is the primary/active card for the member.
    public let isPrimary: Bool

    /// Creates a new RFID instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the RFID record
    ///   - tagNumber: The physical RFID tag number
    ///   - memberId: The member ID of the card holder
    ///   - status: Current status of the card
    ///   - issueDate: Date when the card was issued
    ///   - activationDate: Date when the card was activated
    ///   - expiryDate: Date when the card expires
    ///   - deactivationDate: Date when the card was deactivated
    ///   - blockReason: Reason for blocking/deactivation
    ///   - createdDate: Date when the record was created
    ///   - lastModifiedDate: Date when the record was last modified
    ///   - notes: Optional notes
    ///   - cardType: Type or category of the card
    ///   - isPrimary: Whether this is the primary card for the member
    public init(
        id: RFIDID,
        tagNumber: String,
        memberId: MemberID,
        status: RFIDStatus,
        issueDate: Date? = nil,
        activationDate: Date? = nil,
        expiryDate: Date? = nil,
        deactivationDate: Date? = nil,
        blockReason: String? = nil,
        createdDate: Date? = nil,
        lastModifiedDate: Date? = nil,
        notes: String? = nil,
        cardType: String? = nil,
        isPrimary: Bool = false
    ) {
        self.id = id
        self.tagNumber = tagNumber
        self.memberId = memberId
        self.status = status
        self.issueDate = issueDate
        self.activationDate = activationDate
        self.expiryDate = expiryDate
        self.deactivationDate = deactivationDate
        self.blockReason = blockReason
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate
        self.notes = notes
        self.cardType = cardType
        self.isPrimary = isPrimary
    }
}

// MARK: - Computed Properties
extension RFID {
    /// Whether the card is currently active and usable.
    public var isActive: Bool {
        status.isUsable
    }

    /// Whether the card is expired based on expiry date.
    public var isExpired: Bool {
        guard let expiryDate = expiryDate else { return false }
        return expiryDate < Date()
    }

    /// Number of days until the card expires (nil if no expiry date or already expired).
    public var daysUntilExpiry: Int? {
        guard let expiryDate = expiryDate, expiryDate > Date() else { return nil }
        let components = Calendar.current.dateComponents([.day], from: Date(), to: expiryDate)
        return components.day
    }

    /// Whether the card is expiring soon (within 30 days).
    public var isExpiringSoon: Bool {
        guard let days = daysUntilExpiry else { return false }
        return days <= 30
    }

    /// Duration the card has been active in days (from issue date to now or deactivation date).
    public var activeDurationInDays: Int? {
        guard let issueDate = issueDate else { return nil }
        let endDate = deactivationDate ?? Date()
        let components = Calendar.current.dateComponents([.day], from: issueDate, to: endDate)
        return components.day
    }

    /// Whether the card requires attention (lost, stolen, expiring soon, etc.).
    public var requiresAttention: Bool {
        status.requiresAttention || isExpiringSoon || isExpired
    }
}
