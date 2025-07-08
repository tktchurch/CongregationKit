import Foundation

/// Protocol for modular access to marital information fields.
public protocol MaritalInformationRepresentable: Sendable {
    /// The member's marital status (e.g., Married, Single, Widowed, etc.)
    var maritalStatus: MaritalStatus? { get }
    /// The member's wedding anniversary info, if available.
    var weddingAnniversary: MaritalInformation.WeddingAnniversaryInfo? { get }
    /// The member's spouse's name, if available.
    var spouseName: String? { get }
    /// The number of children the member has, if available.
    var numberOfChildren: Int? { get }
}
