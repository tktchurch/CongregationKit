import Foundation

/// Protocol for exposing contact information fields for a member.
///
/// Adopt this protocol to provide access to a member's contact details in a type-safe, modular way.
///
/// - Note: This protocol is used by `ContactInformation` and `Member` for consistent access to contact data.
public protocol ContactInformationRepresentable: Sendable {
    /// The member's primary phone number, if available.
    var phoneNumber: String? { get }
    /// The member's email address, if available.
    var email: String? { get }
    /// The member's physical address, if available.
    var address: String? { get }
    /// The member's geographic area, if available.
    var area: String? { get }
    /// The member's WhatsApp number, if available.
    var whatsappNumber: String? { get }
    /// The member's alternate phone number, if available.
    var alternateNumber: String? { get }
    /// The member's profession, if available.
    var profession: String? { get }
    /// The member's location, if available.
    var location: String? { get }
} 