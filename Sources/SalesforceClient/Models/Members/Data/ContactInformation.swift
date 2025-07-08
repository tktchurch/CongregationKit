import Foundation

/// A type representing a member's contact information, including phone, email, and address.
///
/// - Note: This struct is modular and conforms to `ContactInformationRepresentable` for type-safe access in the member model.
public struct ContactInformation: Codable, Equatable, Sendable, ContactInformationRepresentable {
    /// The member's primary phone number.
    public let phoneNumber: String?
    /// The member's email address.
    public let email: String?
    /// The member's physical address.
    public let address: String?
    /// The member's area or locality.
    public let area: String?
    /// The member's WhatsApp number.
    public let whatsappNumber: String?
    /// An alternate contact number for the member.
    public let alternateNumber: String?
    /// The member's profession or job title.
    public let profession: String?
    /// The member's location (city, region, etc.).
    public let location: String?
}
