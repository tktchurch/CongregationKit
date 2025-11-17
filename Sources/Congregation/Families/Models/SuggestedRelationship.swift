import Foundation

/// A suggested relationship between two members based on heuristic analysis.
///
/// This struct represents a potential relationship discovered through automated
/// analysis of member data, including confidence scoring and reasoning.
///
/// ## Overview
///
/// The `SuggestedRelationship` provides:
/// - **Potential Link:** Source and target member IDs
/// - **Relationship Type:** Suggested relationship category
/// - **Confidence Score:** How likely this relationship exists (0.0 to 1.0)
/// - **Reasoning:** Why this relationship was suggested
///
/// ## Example Usage
///
/// ```swift
/// let suggestion = SuggestedRelationship(
///     sourceMemberId: MemberID(rawValue: "TKT1234")!,
///     targetMemberId: MemberID(rawValue: "TKT5678")!,
///     suggestedType: .spouse,
///     confidence: 0.95,
///     reason: .spouseNameMatch
/// )
///
/// if suggestion.confidence > 0.8 {
///     print("High confidence: \(suggestion.suggestedType.displayName)")
///     print("Reason: \(suggestion.reason.description)")
/// }
/// ```
public struct SuggestedRelationship: Codable, Equatable, Sendable {
    /// The source member's ID.
    public let sourceMemberId: MemberID

    /// The target member's ID.
    public let targetMemberId: MemberID

    /// The suggested relationship type.
    public let suggestedType: RelationshipType

    /// Confidence score from 0.0 (low) to 1.0 (high).
    public let confidence: Double

    /// The reason for this suggestion.
    public let reason: SuggestionReason

    /// Additional context or evidence for the suggestion.
    public let additionalContext: String?

    /// Creates a new SuggestedRelationship instance.
    ///
    /// - Parameters:
    ///   - sourceMemberId: Source member ID
    ///   - targetMemberId: Target member ID
    ///   - suggestedType: Suggested relationship type
    ///   - confidence: Confidence score (0.0 to 1.0)
    ///   - reason: Reason for the suggestion
    ///   - additionalContext: Additional context
    public init(
        sourceMemberId: MemberID,
        targetMemberId: MemberID,
        suggestedType: RelationshipType,
        confidence: Double,
        reason: SuggestionReason,
        additionalContext: String? = nil
    ) {
        self.sourceMemberId = sourceMemberId
        self.targetMemberId = targetMemberId
        self.suggestedType = suggestedType
        self.confidence = min(1.0, max(0.0, confidence)) // Clamp to 0.0-1.0
        self.reason = reason
        self.additionalContext = additionalContext
    }

    /// Whether this is a high-confidence suggestion (>= 0.8).
    public var isHighConfidence: Bool { confidence >= 0.8 }

    /// Whether this is a medium-confidence suggestion (0.5 to 0.8).
    public var isMediumConfidence: Bool { confidence >= 0.5 && confidence < 0.8 }

    /// Whether this is a low-confidence suggestion (< 0.5).
    public var isLowConfidence: Bool { confidence < 0.5 }

    /// Human-readable confidence level.
    public var confidenceLevel: String {
        if isHighConfidence { return "High" }
        if isMediumConfidence { return "Medium" }
        return "Low"
    }
}

/// Reasons why a relationship was suggested.
public enum SuggestionReason: String, Codable, CaseIterable, Sendable {
    case sameAddress = "Same Address"
    case sameLastName = "Same Last Name"
    case spouseNameMatch = "Spouse Name Match"
    case ageGapParentChild = "Age Gap Suggests Parent-Child"
    case ageGapSibling = "Similar Age Suggests Siblings"
    case maritalInfoMatch = "Marital Information Match"
    case lifeGroupConnection = "Same Life Group"
    case phoneNumberMatch = "Same Phone Number"
    case emergencyContactMatch = "Emergency Contact Match"

    /// A human-readable description of the reason.
    public var description: String { rawValue }

    /// Detailed explanation of this reason.
    public var detailedExplanation: String {
        switch self {
        case .sameAddress:
            return "Members share the same residential address, suggesting they live together."
        case .sameLastName:
            return "Members share the same last name, suggesting family relation."
        case .spouseNameMatch:
            return "Member's spouse name matches another member in the system."
        case .ageGapParentChild:
            return "Age difference of 18-45 years suggests parent-child relationship."
        case .ageGapSibling:
            return "Similar ages (within 15 years) suggest sibling relationship."
        case .maritalInfoMatch:
            return "Marital information indicates a connection between members."
        case .lifeGroupConnection:
            return "Members belong to the same life group."
        case .phoneNumberMatch:
            return "Members share the same contact phone number."
        case .emergencyContactMatch:
            return "One member is listed as emergency contact for another."
        }
    }
}
