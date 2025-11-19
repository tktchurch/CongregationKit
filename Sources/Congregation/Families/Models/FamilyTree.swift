import Foundation

/// A hierarchical representation of family relationships for visualization and analysis.
///
/// The `FamilyTree` struct provides a graph-based view of family relationships,
/// supporting tree visualization, relationship navigation, and genealogical analysis.
///
/// ## Overview
///
/// This struct provides:
/// - **Root Member:** Starting point for the tree
/// - **Tree Nodes:** Members positioned by generation
/// - **Tree Edges:** Relationship connections between nodes
/// - **Traversal:** Methods for navigating the family tree
///
/// ## Example Usage
///
/// ```swift
/// let tree = FamilyTree(
///     rootMember: grandparent,
///     nodes: [grandparentNode, parentNode, childNode],
///     edges: [grandparentToParent, parentToChild]
/// )
///
/// print("Generations: \(tree.generationCount)")
/// let parents = tree.nodes(inGeneration: 0)
/// let children = tree.nodes(inGeneration: 1)
/// ```
public struct FamilyTree: Codable, Sendable {
    /// The root member of the family tree (typically the oldest generation).
    public let rootMember: Member

    /// All nodes in the family tree.
    public let nodes: [FamilyTreeNode]

    /// All edges (relationships) in the family tree.
    public let edges: [FamilyTreeEdge]

    /// Creates a new FamilyTree instance.
    ///
    /// - Parameters:
    ///   - rootMember: The root member of the tree
    ///   - nodes: All tree nodes
    ///   - edges: All tree edges
    public init(
        rootMember: Member,
        nodes: [FamilyTreeNode],
        edges: [FamilyTreeEdge]
    ) {
        self.rootMember = rootMember
        self.nodes = nodes
        self.edges = edges
    }

    /// Number of generations in the tree.
    public var generationCount: Int {
        guard !nodes.isEmpty else { return 0 }
        let generations = Set(nodes.map { $0.generation })
        return generations.count
    }

    /// Gets all nodes in a specific generation.
    ///
    /// - Parameter generation: The generation number (0 = root generation)
    /// - Returns: Array of nodes in that generation
    public func nodes(inGeneration generation: Int) -> [FamilyTreeNode] {
        nodes.filter { $0.generation == generation }
    }

    /// Gets all edges originating from a specific member.
    ///
    /// - Parameter memberId: The source member's ID
    /// - Returns: Array of edges from that member
    public func edges(from memberId: MemberID) -> [FamilyTreeEdge] {
        edges.filter { $0.from == memberId }
    }

    /// Gets all edges pointing to a specific member.
    ///
    /// - Parameter memberId: The target member's ID
    /// - Returns: Array of edges to that member
    public func edges(to memberId: MemberID) -> [FamilyTreeEdge] {
        edges.filter { $0.to == memberId }
    }

    /// Finds a node by member ID.
    ///
    /// - Parameter memberId: The member's ID
    /// - Returns: The tree node if found
    public func node(for memberId: MemberID) -> FamilyTreeNode? {
        nodes.first { $0.member.memberId == memberId }
    }

    /// Gets the minimum generation number.
    public var minGeneration: Int {
        nodes.map { $0.generation }.min() ?? 0
    }

    /// Gets the maximum generation number.
    public var maxGeneration: Int {
        nodes.map { $0.generation }.max() ?? 0
    }

    /// Total number of members in the tree.
    public var memberCount: Int { nodes.count }

    /// Total number of relationships in the tree.
    public var relationshipCount: Int { edges.count }
}

/// A node in the family tree representing a single member.
public struct FamilyTreeNode: Codable, Sendable {
    /// The member represented by this node.
    public let member: Member

    /// The generation level (0 = root, negative = ancestors, positive = descendants).
    public let generation: Int

    /// Horizontal position within the generation (for layout purposes).
    public let position: Int

    /// Creates a new FamilyTreeNode instance.
    ///
    /// - Parameters:
    ///   - member: The member for this node
    ///   - generation: The generation level
    ///   - position: Horizontal position
    public init(member: Member, generation: Int, position: Int) {
        self.member = member
        self.generation = generation
        self.position = position
    }
}

/// An edge in the family tree representing a relationship.
public struct FamilyTreeEdge: Codable, Equatable, Sendable {
    /// The source member's ID (from).
    public let from: MemberID

    /// The target member's ID (to).
    public let to: MemberID

    /// The type of relationship.
    public let relationshipType: RelationshipType

    /// Creates a new FamilyTreeEdge instance.
    ///
    /// - Parameters:
    ///   - from: Source member ID
    ///   - to: Target member ID
    ///   - relationshipType: Type of relationship
    public init(from: MemberID, to: MemberID, relationshipType: RelationshipType) {
        self.from = from
        self.to = to
        self.relationshipType = relationshipType
    }
}
