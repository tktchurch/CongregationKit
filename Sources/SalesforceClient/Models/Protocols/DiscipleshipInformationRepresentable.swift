import Foundation

/// Protocol for modular access to spiritual and discipleship information.
///
/// This protocol provides type-safe, modular access to a member's discipleship and spiritual journey fields, including water baptism, prayer course, foundation course, serving/ministry, and more. Designed for extensibility in production-grade church data models.
public protocol DiscipleshipInformationRepresentable: Sendable {
    /// The date the member was born again (as provided by the API).
    var bornAgainDate: String? { get }
    /// Water baptism information.
    var waterBaptism: WaterBaptism? { get }
    /// Prayer course information.
    var prayerCourse: PrayerCourse? { get }
    /// Foundation course information.
    var foundationCourse: FoundationCourse? { get }
    /// Whether the member attended a life transformation camp.
    var attendedLifeTransformationCamp: Bool? { get }
    /// Whether the member has received the Holy Spirit filling.
    var holySpiritFilling: Bool? { get }
    /// The member's missionary type (picklist).
    var missionary: MissionaryType? { get }
    /// Whether the member is subscribed to the YouTube channel.
    var subscribedToYoutubeChannel: SubscriptionStatus? { get }
    /// Whether the member is subscribed to WhatsApp.
    var subscribedToWhatsapp: SubscriptionStatus? { get }
    /// Serving/ministry involvement information.
    var serving: ServingInformation? { get }
    /// The member's Bible course (picklist).
    var bibleCourse: BibleCourse? { get }
} 