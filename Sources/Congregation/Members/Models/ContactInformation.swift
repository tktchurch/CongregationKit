import Foundation

/// A comprehensive representation of a member's contact information, including phone, email, address, and communication preferences.
///
/// The `ContactInformation` struct consolidates all contact-related data for church members,
/// providing a modular, extensible way to manage communication channels and location data.
/// This struct is designed to support church-specific needs like WhatsApp integration and
/// professional information tracking.
///
/// ## Overview
///
/// This struct organizes contact information into logical categories:
/// - **Primary Contact:** Phone number and email address
/// - **Location Data:** Physical address and area information
/// - **Alternative Contact:** WhatsApp number and alternate phone
/// - **Professional Context:** Profession and location for ministry planning
///
/// ## Key Features
///
/// - **Multiple Contact Methods:** Primary phone, WhatsApp, and alternate numbers
/// - **Location Tracking:** Address and area for pastoral visits and ministry planning
/// - **Professional Context:** Profession and location for ministry matching
/// - **Protocol Conformance:** Implements `ContactInformationRepresentable` for type-safe access
/// - **Church-Specific Design:** Built for church communication and ministry needs
///
/// ## Example Usage
///
/// ```swift
/// // Create contact information for a member
/// let contactInfo = ContactInformation(
///     phoneNumber: "+1234567890",
///     email: "john.doe@example.com",
///     address: "123 Main Street, Downtown",
///     area: "Downtown",
///     whatsappNumber: "+1234567890",
///     alternateNumber: "+0987654321",
///     profession: "Software Engineer",
///     location: "Tech District"
/// )
///
/// // Access contact methods
/// if let phone = contactInfo.phoneNumber {
///     print("Primary phone: \(phone)")
/// }
///
/// if let whatsapp = contactInfo.whatsappNumber {
///     print("WhatsApp: \(whatsapp)")
/// }
///
/// // Use for ministry planning
/// if let profession = contactInfo.profession {
///     print("Professional background: \(profession)")
/// }
///
/// if let area = contactInfo.area {
///     print("Geographic area: \(area)")
/// }
/// ```
///
/// ## Topics
///
/// ### Primary Contact
/// - ``phoneNumber`` - The member's primary phone number
/// - ``email`` - The member's email address
///
/// ### Location Information
/// - ``address`` - The member's physical address
/// - ``area`` - The member's area or locality
/// - ``location`` - The member's location (city, region, etc.)
///
/// ### Alternative Contact
/// - ``whatsappNumber`` - The member's WhatsApp number
/// - ``alternateNumber`` - An alternate contact number for the member
///
/// ### Professional Context
/// - ``profession`` - The member's profession or job title
///
/// ## Church-Specific Features
///
/// ### Communication Preferences
/// - **WhatsApp Integration:** Dedicated WhatsApp number field for church communications
/// - **Multiple Contact Methods:** Primary and alternate numbers for reliable outreach
/// - **Email Support:** Email address for digital communications and newsletters
///
/// ### Ministry Planning
/// - **Geographic Data:** Area and location information for pastoral visits
/// - **Professional Background:** Profession tracking for ministry matching and mentoring
/// - **Address Information:** Physical address for home visits and event planning
///
/// ### Data Organization
/// - **Modular Design:** Logical grouping of related contact information
/// - **Protocol Conformance:** Consistent access patterns across the codebase
/// - **Extensible Structure:** Easy to add new contact methods or fields
///
/// ## Integration with Member Model
///
/// ```swift
/// // In Member struct
/// let member = Member(
///     contactInformation: ContactInformation(
///         phoneNumber: "+1234567890",
///         email: "member@church.com",
///         address: "123 Church Street",
///         area: "Downtown"
///     )
/// )
///
/// // Access through protocol conformance
/// if let phone = member.phoneNumber {
///     print("Member phone: \(phone)")
/// }
///
/// if let email = member.email {
///     print("Member email: \(email)")
/// }
/// ```
///
/// ## Data Validation
///
/// - **Optional Fields:** All fields are optional to handle incomplete data gracefully
/// - **Format Flexibility:** Accepts various phone number and email formats
/// - **Location Flexibility:** Supports different address and area formats
/// - **Professional Context:** Flexible profession and location descriptions
///
/// ## Performance Considerations
///
/// - **Lightweight Structure:** Minimal memory footprint for contact data
/// - **Efficient Access:** Direct property access without computation overhead
/// - **Concurrency Safe:** All properties are `Sendable` for async operations
/// - **Serialization Ready:** Full `Codable` support for API integration
///
/// ## Best Practices
///
/// ### Contact Method Priority
/// 1. **Primary Phone:** Use for urgent communications and pastoral care
/// 2. **WhatsApp:** Use for group communications and event updates
/// 3. **Email:** Use for newsletters, announcements, and formal communications
/// 4. **Alternate Phone:** Use as backup for primary phone
///
/// ### Ministry Applications
/// - **Pastoral Care:** Use address and area for home visits
/// - **Event Planning:** Use location data for regional event organization
/// - **Ministry Matching:** Use profession for skill-based ministry placement
/// - **Communication:** Use preferred contact methods for effective outreach
///
/// - Note: This struct is modular and conforms to `ContactInformationRepresentable` for type-safe access in the member model.
public struct ContactInformation: Codable, Equatable, Sendable, ContactInformationRepresentable {
    /// The member's primary phone number.
    ///
    /// This is the main contact number for the member, typically used for
    /// urgent communications, pastoral care, and general church outreach.
    /// The format can vary (e.g., "+1234567890", "123-456-7890", etc.).
    public let phoneNumber: String?

    /// The member's email address.
    ///
    /// Used for digital communications, newsletters, announcements, and
    /// formal church communications. Supports standard email formats.
    public let email: String?

    /// The member's physical address.
    ///
    /// The complete street address for pastoral visits, home ministry,
    /// and event planning. Can include street, city, state, and postal code.
    public let address: String?

    /// The member's area or locality.
    ///
    /// A broader geographic identifier (e.g., "Downtown", "North Side",
    /// "Suburban Area") used for regional ministry planning and event organization.
    public let area: String?

    /// The member's WhatsApp number.
    ///
    /// Dedicated WhatsApp contact for church group communications, event updates,
    /// and informal ministry outreach. Often the same as the primary phone number.
    public let whatsappNumber: String?

    /// An alternate contact number for the member.
    ///
    /// Secondary phone number for backup communication, typically used when
    /// the primary number is unavailable or for different types of communications.
    public let alternateNumber: String?

    /// The member's profession or job title.
    ///
    /// Professional background information used for ministry matching, mentoring
    /// programs, and skill-based ministry placement (e.g., "Software Engineer",
    /// "Teacher", "Healthcare Worker").
    public let profession: String?

    /// The member's location (city, region, etc.).
    ///
    /// Broader geographic context for ministry planning, regional events,
    /// and demographic analysis (e.g., "Tech District", "Healthcare Hub").
    public let location: String?
}
