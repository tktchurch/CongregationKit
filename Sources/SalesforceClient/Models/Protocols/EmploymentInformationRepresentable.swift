import Foundation

/// Protocol for exposing employment information fields for a member.
///
/// Adopt this protocol to provide access to a member's employment and occupation details in a type-safe, modular way.
///
/// - Note: This protocol is used by `EmploymentInformation` and `Member` for consistent access to employment data.
public protocol EmploymentInformationRepresentable: Sendable {
    /// The member's employment status, if available.
    var employmentStatus: EmploymentStatus? { get }
    /// The name of the member's organization, if available.
    var nameOfTheOrganization: String? { get }
    /// The member's occupation category, if available.
    var occupation: Occupation? { get }
    /// The member's occupation subcategory as an enum, if available.
    var occupationSubCategoryEnum: OccupationSubCategory? { get }
    /// The member's occupation category, inferred from subcategory if needed.
    var occupationCategory: Occupation? { get }
} 