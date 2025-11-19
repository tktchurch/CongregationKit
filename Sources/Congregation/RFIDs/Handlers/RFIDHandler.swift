import Foundation

/// Protocol defining the interface for RFID-related operations.
///
/// This protocol provides a standardized API for managing RFID cards,
/// member-RFID associations, and RFID-related queries in a congregation
/// management system.
///
/// ## Overview
///
/// The `RFIDsHandler` protocol supports:
/// - **CRUD Operations:** Create, read, update, delete RFID cards
/// - **Member Association:** Link and unlink cards with members
/// - **Status Management:** Activate, deactivate, block cards
/// - **Card Lifecycle:** Issue, return, replace cards
/// - **Queries:** Find cards by member, status, tag number
///
/// ## Example Usage
///
/// ```swift
/// let handler: RFIDsHandler = SalesforceRFIDsHandler(...)
///
/// // Fetch all RFIDs
/// let response = try await handler.fetchAll(pageNumber: 1, pageSize: 10)
///
/// // Get member's cards
/// let cards = try await handler.fetchRFIDsForMember(memberId: memberId)
///
/// // Issue a new card
/// let newCard = try await handler.issueRFID(
///     tagNumber: "1234567890",
///     memberId: memberId,
///     expiryDate: futureDate
/// )
/// ```
public protocol RFIDsHandler: Sendable {
    // MARK: - RFID CRUD Operations

    /// Fetches all RFIDs with pagination.
    ///
    /// - Parameters:
    ///   - pageNumber: The page number to fetch (1-indexed)
    ///   - pageSize: Number of RFIDs per page
    /// - Returns: A response containing RFIDs and metadata
    func fetchAll(pageNumber: Int, pageSize: Int) async throws -> RFIDResponse

    /// Fetches a single RFID by ID.
    ///
    /// - Parameter id: The RFID's unique identifier
    /// - Returns: The RFID if found
    func fetch(id: RFIDID) async throws -> RFID

    /// Fetches an RFID by its tag number.
    ///
    /// - Parameter tagNumber: The physical RFID tag number
    /// - Returns: The RFID if found
    func fetchByTagNumber(_ tagNumber: String) async throws -> RFID

    /// Creates a new RFID card.
    ///
    /// - Parameter rfid: The RFID to create
    /// - Returns: The created RFID with server-assigned ID
    func createRFID(_ rfid: RFID) async throws -> RFID

    /// Updates an existing RFID card.
    ///
    /// - Parameter rfid: The RFID with updated information
    /// - Returns: The updated RFID
    func updateRFID(_ rfid: RFID) async throws -> RFID

    /// Deletes an RFID card.
    ///
    /// - Parameter id: The RFID's unique identifier
    func deleteRFID(id: RFIDID) async throws

    // MARK: - Member-RFID Association Operations

    /// Fetches all RFIDs associated with a specific member.
    ///
    /// - Parameter memberId: The member's unique identifier
    /// - Returns: Array of RFIDs associated with the member
    func fetchRFIDsForMember(memberId: MemberID) async throws -> [RFID]

    /// Fetches the primary/active RFID for a member.
    ///
    /// - Parameter memberId: The member's unique identifier
    /// - Returns: The primary RFID if found
    func fetchPrimaryRFID(memberId: MemberID) async throws -> RFID?

    /// Fetches member-RFID association records.
    ///
    /// - Parameter memberId: The member's unique identifier
    /// - Returns: Array of member-RFID associations
    func fetchMemberRFIDs(memberId: MemberID) async throws -> [MemberRFID]

    /// Assigns an RFID card to a member.
    ///
    /// - Parameters:
    ///   - rfidId: The RFID's ID
    ///   - memberId: The member's ID
    ///   - isPrimary: Whether this is the primary card
    ///   - assignedBy: Who assigned the card
    /// - Returns: The created member-RFID association
    func assignRFIDToMember(
        rfidId: RFIDID,
        memberId: MemberID,
        isPrimary: Bool,
        assignedBy: String?
    ) async throws -> MemberRFID

    /// Unassigns an RFID card from a member.
    ///
    /// - Parameters:
    ///   - rfidId: The RFID's ID
    ///   - memberId: The member's ID
    ///   - returnReason: Reason for return
    ///   - returnedTo: Who received the returned card
    func unassignRFIDFromMember(
        rfidId: RFIDID,
        memberId: MemberID,
        returnReason: String?,
        returnedTo: String?
    ) async throws

    // MARK: - Card Lifecycle Operations

    /// Issues a new RFID card to a member.
    ///
    /// This is a convenience method that creates the RFID and assigns it to the member.
    ///
    /// - Parameters:
    ///   - tagNumber: The physical RFID tag number
    ///   - memberId: The member's ID
    ///   - expiryDate: When the card expires
    ///   - cardType: Type of card
    ///   - isPrimary: Whether this is the primary card
    ///   - assignedBy: Who issued the card
    /// - Returns: The created RFID
    func issueRFID(
        tagNumber: String,
        memberId: MemberID,
        expiryDate: Date?,
        cardType: String?,
        isPrimary: Bool,
        assignedBy: String?
    ) async throws -> RFID

    /// Replaces an existing RFID card with a new one.
    ///
    /// - Parameters:
    ///   - oldRFIDId: The ID of the card to replace
    ///   - newTagNumber: The new card's tag number
    ///   - reason: Reason for replacement
    /// - Returns: The new RFID
    func replaceRFID(
        oldRFIDId: RFIDID,
        newTagNumber: String,
        reason: String
    ) async throws -> RFID

    // MARK: - Status Management Operations

    /// Activates an RFID card.
    ///
    /// - Parameter id: The RFID's unique identifier
    /// - Returns: The updated RFID
    func activateRFID(id: RFIDID) async throws -> RFID

    /// Deactivates an RFID card.
    ///
    /// - Parameters:
    ///   - id: The RFID's unique identifier
    ///   - reason: Reason for deactivation
    /// - Returns: The updated RFID
    func deactivateRFID(id: RFIDID, reason: String?) async throws -> RFID

    /// Blocks an RFID card.
    ///
    /// - Parameters:
    ///   - id: The RFID's unique identifier
    ///   - reason: Reason for blocking
    /// - Returns: The updated RFID
    func blockRFID(id: RFIDID, reason: String) async throws -> RFID

    /// Marks an RFID card as lost.
    ///
    /// - Parameter id: The RFID's unique identifier
    /// - Returns: The updated RFID
    func markAsLost(id: RFIDID) async throws -> RFID

    /// Marks an RFID card as stolen.
    ///
    /// - Parameter id: The RFID's unique identifier
    /// - Returns: The updated RFID
    func markAsStolen(id: RFIDID) async throws -> RFID

    // MARK: - Query Operations

    /// Fetches RFIDs by status.
    ///
    /// - Parameters:
    ///   - status: The status to filter by
    ///   - pageNumber: The page number to fetch
    ///   - pageSize: Number of items per page
    /// - Returns: A response containing RFIDs matching the status
    func fetchByStatus(
        status: RFIDStatus,
        pageNumber: Int,
        pageSize: Int
    ) async throws -> RFIDResponse

    /// Fetches RFIDs that are expiring soon (within specified days).
    ///
    /// - Parameters:
    ///   - daysThreshold: Number of days threshold
    ///   - pageNumber: The page number to fetch
    ///   - pageSize: Number of items per page
    /// - Returns: A response containing expiring RFIDs
    func fetchExpiringSoon(
        daysThreshold: Int,
        pageNumber: Int,
        pageSize: Int
    ) async throws -> RFIDResponse

    /// Fetches RFIDs that require attention (lost, stolen, expiring, etc.).
    ///
    /// - Parameters:
    ///   - pageNumber: The page number to fetch
    ///   - pageSize: Number of items per page
    /// - Returns: A response containing RFIDs requiring attention
    func fetchRequiringAttention(
        pageNumber: Int,
        pageSize: Int
    ) async throws -> RFIDResponse
}
