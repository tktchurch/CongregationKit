import Foundation

/// A protocol describing the common data fields for a church member as represented in Salesforce.
///
/// Types conforming to this protocol provide access to all standard member fields, including
/// demographic, contact, and membership information. This protocol is designed for extensibility
/// and can be used for any model representing member data from Salesforce.
public protocol MemberDataRepresentable: Codable, Sendable {
    /// The member's date of birth with detailed information, if available.
    var dateOfBirth: BirthDateInfo? { get }
    /// Date when the member record was created.
    var createdDate: Date? { get }
    /// Date when the member record was last modified.
    var lastModifiedDate: Date? { get }
    /// The member's title (e.g., Mr, Mrs, Dr), if available.
    var title: MemberTitle? { get }
    /// The member's type (e.g., TKT, EFAM), if available.
    var memberType: MemberType? { get }
    /// The member's blood group, if available.
    var bloodGroup: BloodGroup? { get }
    /// The member's preferred languages, if available.
    var preferredLanguages: [PreferredLanguage]? { get }
    /// The campus the member is attending, if available.
    var attendingCampus: AttendingCampus? { get }
    /// The campus where the member serves, if available.
    var serviceCampus: ServiceCampus? { get }
    /// Whether the member is part of a life group.
    var partOfLifeGroup: Bool? { get }
    /// The member's status (e.g., Regular, Inactive), if available.
    var status: MemberStatus? { get }
    /// The campus the member is associated with, if available.
    var campus: Campus? { get }
    /// Whether the member is part of SPM.
    var spm: Bool? { get }
    /// The service the member is attending, if available.
    var attendingService: AttendingService? { get }
    /// The member's age, calculated from dateOfBirth if available.
    var age: Int? { get }
    /// The parsed member photo (URL and alt text), if available.
    var photo: MemberPhoto? { get }
}

extension MemberDataRepresentable {
    public var age: Int? {
        guard let dob = dateOfBirth else { return nil }
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: dob.date, to: now)
        guard let years = ageComponents.year else { return nil }
        let hasHadBirthdayThisYear: Bool
        if let month = ageComponents.month, let day = ageComponents.day {
            hasHadBirthdayThisYear = (month > 0) || (month == 0 && day >= 0)
        } else {
            hasHadBirthdayThisYear = true
        }
        return years - (hasHadBirthdayThisYear ? 0 : 1)
    }
}
