import Foundation

/// Utility for automatically inferring relationships between members based on available data.
///
/// The `RelationshipBuilder` provides heuristic-based analysis to suggest potential
/// relationships between members, using data like addresses, names, ages, and marital information.
///
/// ## Overview
///
/// This utility supports:
/// - **Address Matching:** Find members at the same address
/// - **Name Matching:** Find members with the same last name
/// - **Spouse Detection:** Match spouse names to existing members
/// - **Age Analysis:** Infer parent-child or sibling relationships from age gaps
/// - **Marital Info:** Use marital information for relationship inference
///
/// ## Example Usage
///
/// ```swift
/// let suggestions = RelationshipBuilder.inferRelationships(
///     for: member,
///     from: allMembers,
///     options: .default
/// )
///
/// for suggestion in suggestions where suggestion.isHighConfidence {
///     print("Suggested: \(suggestion.suggestedType.displayName)")
///     print("Confidence: \(suggestion.confidence)")
///     print("Reason: \(suggestion.reason.description)")
/// }
/// ```
public enum RelationshipBuilder {
    /// Infers potential relationships for a member from a pool of all members.
    ///
    /// - Parameters:
    ///   - member: The member to find relationships for
    ///   - allMembers: All available members to compare against
    ///   - options: Configuration options for the inference
    /// - Returns: Array of suggested relationships sorted by confidence
    public static func inferRelationships(
        for member: Member,
        from allMembers: [Member],
        options: RelationshipSuggestionOptions = .default
    ) -> [SuggestedRelationship] {
        guard let memberId = member.memberId else { return [] }

        var suggestions: [SuggestedRelationship] = []

        // Filter out the member itself
        let otherMembers = allMembers.filter { $0.memberId != memberId }

        // 1. Spouse name matching (highest confidence)
        if options.includeNameMatching {
            suggestions.append(contentsOf: inferSpouseFromName(member: member, others: otherMembers))
        }

        // 2. Address matching
        if options.includeAddressMatching {
            suggestions.append(contentsOf: inferFromAddress(member: member, others: otherMembers))
        }

        // 3. Last name matching
        if options.includeNameMatching {
            suggestions.append(contentsOf: inferFromLastName(member: member, others: otherMembers))
        }

        // 4. Age-based inference
        if options.includeAgeAnalysis {
            suggestions.append(contentsOf: inferFromAge(member: member, others: otherMembers))
        }

        // 5. Life group connection
        suggestions.append(contentsOf: inferFromLifeGroup(member: member, others: otherMembers))

        // 6. Phone number matching
        suggestions.append(contentsOf: inferFromPhoneNumber(member: member, others: otherMembers))

        // Remove duplicates (same source/target pair), keeping highest confidence
        let uniqueSuggestions = removeDuplicates(suggestions)

        // Filter by minimum confidence and sort
        let filtered = uniqueSuggestions
            .filter { $0.confidence >= options.minimumConfidence }
            .sorted { $0.confidence > $1.confidence }

        // Limit results
        return Array(filtered.prefix(options.maxSuggestions))
    }

    /// Infers spouse relationship from marital information.
    private static func inferSpouseFromName(
        member: Member,
        others: [Member]
    ) -> [SuggestedRelationship] {
        guard let memberId = member.memberId,
            let spouseName = member.spouseName?.trimmingCharacters(in: .whitespacesAndNewlines),
            !spouseName.isEmpty
        else { return [] }

        var suggestions: [SuggestedRelationship] = []

        for other in others {
            guard let otherId = other.memberId else { continue }

            // Check if the other member's name matches the spouse name
            let otherFullName = other.memberName ?? ""
            let otherFirstName = other.firstName ?? ""

            var confidence = 0.0
            var matched = false

            // Exact full name match
            if otherFullName.localizedCaseInsensitiveCompare(spouseName) == .orderedSame {
                confidence = 0.95
                matched = true
            }
            // First name match (less confident)
            else if otherFirstName.localizedCaseInsensitiveCompare(spouseName) == .orderedSame {
                confidence = 0.85
                matched = true
            }
            // Partial match (contains)
            else if otherFullName.localizedCaseInsensitiveContains(spouseName)
                || spouseName.localizedCaseInsensitiveContains(otherFullName)
            {
                confidence = 0.7
                matched = true
            }

            if matched {
                suggestions.append(
                    SuggestedRelationship(
                        sourceMemberId: memberId,
                        targetMemberId: otherId,
                        suggestedType: .spouse,
                        confidence: confidence,
                        reason: .spouseNameMatch,
                        additionalContext: "Spouse name '\(spouseName)' matches '\(otherFullName)'"
                    ))
            }
        }

        return suggestions
    }

    /// Infers relationships from shared address.
    private static func inferFromAddress(
        member: Member,
        others: [Member]
    ) -> [SuggestedRelationship] {
        guard let memberId = member.memberId,
            let address = member.address?.trimmingCharacters(in: .whitespacesAndNewlines),
            !address.isEmpty
        else { return [] }

        var suggestions: [SuggestedRelationship] = []

        for other in others {
            guard let otherId = other.memberId,
                let otherAddress = other.address?.trimmingCharacters(in: .whitespacesAndNewlines),
                !otherAddress.isEmpty
            else { continue }

            // Normalize addresses for comparison
            let normalizedAddress = normalizeAddress(address)
            let normalizedOtherAddress = normalizeAddress(otherAddress)

            if normalizedAddress == normalizedOtherAddress {
                // Same address - likely family, but need age analysis to determine type
                let confidence = 0.8
                let suggestedType: RelationshipType = .other  // Will be refined by age analysis

                suggestions.append(
                    SuggestedRelationship(
                        sourceMemberId: memberId,
                        targetMemberId: otherId,
                        suggestedType: suggestedType,
                        confidence: confidence,
                        reason: .sameAddress,
                        additionalContext: "Both live at '\(address)'"
                    ))
            }
        }

        return suggestions
    }

    /// Infers relationships from shared last name.
    private static func inferFromLastName(
        member: Member,
        others: [Member]
    ) -> [SuggestedRelationship] {
        guard let memberId = member.memberId,
            let lastName = member.lastName?.trimmingCharacters(in: .whitespacesAndNewlines),
            !lastName.isEmpty
        else { return [] }

        var suggestions: [SuggestedRelationship] = []

        for other in others {
            guard let otherId = other.memberId,
                let otherLastName = other.lastName?.trimmingCharacters(in: .whitespacesAndNewlines),
                !otherLastName.isEmpty
            else { continue }

            if lastName.localizedCaseInsensitiveCompare(otherLastName) == .orderedSame {
                let confidence = 0.6  // Medium confidence - same last name doesn't always mean family
                suggestions.append(
                    SuggestedRelationship(
                        sourceMemberId: memberId,
                        targetMemberId: otherId,
                        suggestedType: .other,
                        confidence: confidence,
                        reason: .sameLastName,
                        additionalContext: "Both have last name '\(lastName)'"
                    ))
            }
        }

        return suggestions
    }

    /// Infers relationships from age differences.
    private static func inferFromAge(
        member: Member,
        others: [Member]
    ) -> [SuggestedRelationship] {
        guard let memberId = member.memberId,
            let memberAge = member.dateOfBirth?.age
        else { return [] }

        var suggestions: [SuggestedRelationship] = []

        for other in others {
            guard let otherId = other.memberId,
                let otherAge = other.dateOfBirth?.age
            else { continue }

            let ageDifference = abs(memberAge - otherAge)

            // Parent-child relationship: 18-45 year gap
            if ageDifference >= 18 && ageDifference <= 45 {
                let suggestedType: RelationshipType = memberAge > otherAge ? .parent : .child
                let confidence = calculateParentChildConfidence(ageDifference: ageDifference)

                suggestions.append(
                    SuggestedRelationship(
                        sourceMemberId: memberId,
                        targetMemberId: otherId,
                        suggestedType: suggestedType,
                        confidence: confidence,
                        reason: .ageGapParentChild,
                        additionalContext:
                            "Age difference of \(ageDifference) years suggests \(suggestedType.displayName)"
                    ))
            }
            // Sibling relationship: 0-15 year gap
            else if ageDifference <= 15 {
                let confidence = calculateSiblingConfidence(ageDifference: ageDifference)

                suggestions.append(
                    SuggestedRelationship(
                        sourceMemberId: memberId,
                        targetMemberId: otherId,
                        suggestedType: .sibling,
                        confidence: confidence,
                        reason: .ageGapSibling,
                        additionalContext:
                            "Age difference of \(ageDifference) years suggests siblings"
                    ))
            }
        }

        return suggestions
    }

    /// Infers relationships from life group membership.
    private static func inferFromLifeGroup(
        member: Member,
        others: [Member]
    ) -> [SuggestedRelationship] {
        guard let memberId = member.memberId,
            let lifeGroup = member.lifeGroupName?.trimmingCharacters(in: .whitespacesAndNewlines),
            !lifeGroup.isEmpty
        else { return [] }

        var suggestions: [SuggestedRelationship] = []

        for other in others {
            guard let otherId = other.memberId,
                let otherLifeGroup = other.lifeGroupName?.trimmingCharacters(in: .whitespacesAndNewlines),
                !otherLifeGroup.isEmpty
            else { continue }

            if lifeGroup.localizedCaseInsensitiveCompare(otherLifeGroup) == .orderedSame {
                suggestions.append(
                    SuggestedRelationship(
                        sourceMemberId: memberId,
                        targetMemberId: otherId,
                        suggestedType: .lifeGroupMember,
                        confidence: 0.5,
                        reason: .lifeGroupConnection,
                        additionalContext: "Both in life group '\(lifeGroup)'"
                    ))
            }
        }

        return suggestions
    }

    /// Infers relationships from shared phone numbers.
    private static func inferFromPhoneNumber(
        member: Member,
        others: [Member]
    ) -> [SuggestedRelationship] {
        guard let memberId = member.memberId,
            let phone = member.phone?.trimmingCharacters(in: .whitespacesAndNewlines),
            !phone.isEmpty
        else { return [] }

        var suggestions: [SuggestedRelationship] = []
        let normalizedPhone = normalizePhoneNumber(phone)

        for other in others {
            guard let otherId = other.memberId,
                let otherPhone = other.phone?.trimmingCharacters(in: .whitespacesAndNewlines),
                !otherPhone.isEmpty
            else { continue }

            let normalizedOtherPhone = normalizePhoneNumber(otherPhone)

            if normalizedPhone == normalizedOtherPhone {
                suggestions.append(
                    SuggestedRelationship(
                        sourceMemberId: memberId,
                        targetMemberId: otherId,
                        suggestedType: .other,
                        confidence: 0.75,
                        reason: .phoneNumberMatch,
                        additionalContext: "Same phone number: \(phone)"
                    ))
            }
        }

        return suggestions
    }

    // MARK: - Helper Functions

    private static func normalizeAddress(_ address: String) -> String {
        address.lowercased()
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func normalizePhoneNumber(_ phone: String) -> String {
        phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    private static func calculateParentChildConfidence(ageDifference: Int) -> Double {
        // Optimal parent-child age difference is around 25-30 years
        if ageDifference >= 25 && ageDifference <= 35 {
            return 0.75
        } else if ageDifference >= 20 && ageDifference <= 40 {
            return 0.65
        } else {
            return 0.55
        }
    }

    private static func calculateSiblingConfidence(ageDifference: Int) -> Double {
        // Closer ages suggest higher confidence for siblings
        if ageDifference <= 5 {
            return 0.65
        } else if ageDifference <= 10 {
            return 0.55
        } else {
            return 0.45
        }
    }

    private static func removeDuplicates(_ suggestions: [SuggestedRelationship]) -> [SuggestedRelationship] {
        var seen: [String: SuggestedRelationship] = [:]

        for suggestion in suggestions {
            let key = "\(suggestion.sourceMemberId.rawValue)-\(suggestion.targetMemberId.rawValue)-\(suggestion.suggestedType.rawValue)"

            if let existing = seen[key] {
                // Keep the one with higher confidence
                if suggestion.confidence > existing.confidence {
                    seen[key] = suggestion
                }
            } else {
                seen[key] = suggestion
            }
        }

        return Array(seen.values)
    }
}

// MARK: - String Extension for Case-Insensitive Contains

extension String {
    fileprivate func localizedCaseInsensitiveContains(_ other: String) -> Bool {
        self.range(of: other, options: .caseInsensitive) != nil
    }
}
