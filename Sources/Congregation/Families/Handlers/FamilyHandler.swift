import Foundation

/// Protocol defining the interface for family-related operations.
///
/// This protocol provides a standardized API for managing families, relationships,
/// and family-related queries in a congregation management system.
///
/// ## Overview
///
/// The `FamiliesHandler` protocol supports:
/// - **CRUD Operations:** Create, read, update families
/// - **Relationship Management:** Add and query relationships
/// - **Family Discovery:** Auto-suggest relationships
/// - **Family Tree Building:** Construct family hierarchies
///
/// ## Example Usage
///
/// ```swift
/// let handler: FamiliesHandler = SalesforceFamiliesHandler(...)
///
/// // Fetch all families
/// let response = try await handler.fetchAll(pageNumber: 1, pageSize: 10)
///
/// // Get family members
/// let members = try await handler.fetchMembers(familyId: familyId)
///
/// // Suggest relationships
/// let suggestions = try await handler.suggestRelationships(for: member)
/// ```
public protocol FamiliesHandler: Sendable {
    // MARK: - Family CRUD Operations

    /// Fetches all families with pagination.
    ///
    /// - Parameters:
    ///   - pageNumber: The page number to fetch (1-indexed)
    ///   - pageSize: Number of families per page
    /// - Returns: A response containing families and metadata
    func fetchAll(pageNumber: Int, pageSize: Int) async throws -> FamilyResponse

    /// Fetches a single family by ID.
    ///
    /// - Parameter id: The family's unique identifier
    /// - Returns: The family if found
    func fetch(id: FamilyID) async throws -> Family

    /// Fetches all members belonging to a family.
    ///
    /// - Parameter familyId: The family's unique identifier
    /// - Returns: Array of members in the family
    func fetchMembers(familyId: FamilyID) async throws -> [Member]

    /// Fetches detailed family information including members and relationships.
    ///
    /// - Parameter familyId: The family's unique identifier
    /// - Returns: Rich family information with statistics
    func fetchFamilyInfo(familyId: FamilyID) async throws -> FamilyInfo

    /// Creates a new family.
    ///
    /// - Parameter family: The family to create
    /// - Returns: The created family with server-assigned ID
    func createFamily(_ family: Family) async throws -> Family

    /// Updates an existing family.
    ///
    /// - Parameter family: The family with updated information
    /// - Returns: The updated family
    func updateFamily(_ family: Family) async throws -> Family

    /// Deletes a family.
    ///
    /// - Parameter id: The family's unique identifier
    func deleteFamily(id: FamilyID) async throws

    // MARK: - Family Membership Operations

    /// Adds a member to a family.
    ///
    /// - Parameters:
    ///   - memberId: The member's ID
    ///   - familyId: The family's ID
    ///   - role: The member's role in the family
    /// - Returns: The created membership record
    func addMemberToFamily(
        memberId: MemberID,
        familyId: FamilyID,
        role: FamilyRole
    ) async throws -> FamilyMembership

    /// Removes a member from a family.
    ///
    /// - Parameters:
    ///   - memberId: The member's ID
    ///   - familyId: The family's ID
    func removeMemberFromFamily(memberId: MemberID, familyId: FamilyID) async throws

    /// Updates a member's role in a family.
    ///
    /// - Parameters:
    ///   - memberId: The member's ID
    ///   - familyId: The family's ID
    ///   - newRole: The new role
    /// - Returns: The updated membership record
    func updateMemberRole(
        memberId: MemberID,
        familyId: FamilyID,
        newRole: FamilyRole
    ) async throws -> FamilyMembership

    // MARK: - Relationship Operations

    /// Fetches all relationships for a member.
    ///
    /// - Parameter memberId: The member's ID
    /// - Returns: Array of relationships involving this member
    func fetchRelationships(memberId: MemberID) async throws -> [MemberRelationship]

    /// Creates a new relationship between members.
    ///
    /// - Parameter relationship: The relationship to create
    /// - Returns: The created relationship
    func createRelationship(_ relationship: MemberRelationship) async throws -> MemberRelationship

    /// Creates bidirectional relationships (primary and inverse).
    ///
    /// - Parameter relationship: The primary relationship
    /// - Returns: Tuple of primary and inverse relationships
    func createBidirectionalRelationship(
        _ relationship: MemberRelationship
    ) async throws -> (primary: MemberRelationship, inverse: MemberRelationship)

    /// Deletes a relationship.
    ///
    /// - Parameter id: The relationship's ID
    func deleteRelationship(id: RelationshipID) async throws

    /// Updates an existing relationship.
    ///
    /// - Parameter relationship: The relationship with updated information
    /// - Returns: The updated relationship
    func updateRelationship(_ relationship: MemberRelationship) async throws -> MemberRelationship

    // MARK: - Relationship Discovery

    /// Suggests potential relationships for a member based on heuristics.
    ///
    /// - Parameter member: The member to analyze
    /// - Returns: Array of suggested relationships with confidence scores
    func suggestRelationships(for member: Member) async throws -> [SuggestedRelationship]

    /// Suggests potential relationships for a member with custom options.
    ///
    /// - Parameters:
    ///   - member: The member to analyze
    ///   - options: Configuration options for suggestions
    /// - Returns: Array of suggested relationships
    func suggestRelationships(
        for member: Member,
        options: RelationshipSuggestionOptions
    ) async throws -> [SuggestedRelationship]

    // MARK: - Family Tree Operations

    /// Builds a family tree starting from a specific member.
    ///
    /// - Parameter memberId: The root member's ID
    /// - Returns: A family tree structure
    func buildFamilyTree(startingFrom memberId: MemberID) async throws -> FamilyTree

    /// Builds a family tree for an entire family.
    ///
    /// - Parameter familyId: The family's ID
    /// - Returns: A family tree structure
    func buildFamilyTree(forFamily familyId: FamilyID) async throws -> FamilyTree
}

/// Options for relationship suggestion algorithms.
public struct RelationshipSuggestionOptions: Codable, Equatable, Sendable {
    /// Minimum confidence threshold (0.0 to 1.0).
    public let minimumConfidence: Double

    /// Whether to include address-based suggestions.
    public let includeAddressMatching: Bool

    /// Whether to include name-based suggestions.
    public let includeNameMatching: Bool

    /// Whether to include age-based suggestions.
    public let includeAgeAnalysis: Bool

    /// Maximum number of suggestions to return.
    public let maxSuggestions: Int

    /// Creates default options.
    public static var `default`: RelationshipSuggestionOptions {
        RelationshipSuggestionOptions(
            minimumConfidence: 0.5,
            includeAddressMatching: true,
            includeNameMatching: true,
            includeAgeAnalysis: true,
            maxSuggestions: 10
        )
    }

    /// Creates a new RelationshipSuggestionOptions instance.
    ///
    /// - Parameters:
    ///   - minimumConfidence: Minimum confidence threshold
    ///   - includeAddressMatching: Include address matching
    ///   - includeNameMatching: Include name matching
    ///   - includeAgeAnalysis: Include age analysis
    ///   - maxSuggestions: Maximum suggestions to return
    public init(
        minimumConfidence: Double = 0.5,
        includeAddressMatching: Bool = true,
        includeNameMatching: Bool = true,
        includeAgeAnalysis: Bool = true,
        maxSuggestions: Int = 10
    ) {
        self.minimumConfidence = min(1.0, max(0.0, minimumConfidence))
        self.includeAddressMatching = includeAddressMatching
        self.includeNameMatching = includeNameMatching
        self.includeAgeAnalysis = includeAgeAnalysis
        self.maxSuggestions = maxSuggestions
    }
}
