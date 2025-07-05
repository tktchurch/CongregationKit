import Foundation

/// A protocol describing the common data fields for a seeker (lead/contact) as represented in Salesforce.
///
/// Types conforming to this protocol provide access to all standard seeker fields, including
/// demographic, contact, and entry information. This protocol is designed for extensibility
/// and can be used for any model representing seeker data from Salesforce.
public protocol SeekerDataRepresentable: Codable, Sendable {
    /// The seeker's unique identifier, if available.
    var id: String? { get }
    /// The lead information for the seeker, if available.
    var lead: Lead? { get }
    /// The seeker's full name, if available.
    var fullName: String? { get }
    /// The seeker's email address, if available.
    var email: String? { get }
    /// The seeker's phone number, if available.
    var phone: String? { get }
    /// The seeker's date of birth, if available.
    var dateOfBirth: Date? { get }
    /// The seeker's age group (derived or provided), if available.
    var ageGroup: String? { get }
    /// The seeker's area or locality, if available.
    var area: String? { get }
    /// The type of entry for the seeker (e.g., Salvation, New Visitor), if available.
    var typeOfEntry: TypeOfEntry? { get }
    /// The seeker's marital status, if available.
    var maritalStatus: MaritalStatus? { get }
    /// The date the seeker was created, if available.
    var createdDate: Date? { get }
    /// The seeker's age, calculated from dateOfBirth if available.
    var age: Int? { get }
}