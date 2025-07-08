import Foundation

/// Represents a member's water baptism experience.
///
/// - Parameters:
///    - date: The date of water baptism (as provided by the API, may be year or full date).
///    - received: Whether the member has received water baptism.
public struct WaterBaptism: Codable, Equatable, Sendable {
    /// The date of water baptism (as provided by the API, may be year or full date).
    public let date: String?
    /// Whether the member has received water baptism.
    public let received: Bool?
}

/// Represents a member's prayer course experience.
///
/// - Parameters:
///    - completed: Whether the member has completed the prayer course.
///    - date: The date the prayer course was completed (if available).
public struct PrayerCourse: Codable, Equatable, Sendable {
    /// Whether the member has completed the prayer course.
    public let completed: Bool?
    /// The date the prayer course was completed (if available).
    public let date: String?
}

/// Represents a member's foundation course experience.
///
/// - Parameters:
///    - completed: Whether the member has completed the foundation course.
public struct FoundationCourse: Codable, Equatable, Sendable {
    /// Whether the member has completed the foundation course.
    public let completed: Bool?
}

/// Represents a member's serving/ministry involvement.
///
/// - Parameters:
///    - involved: The type of ministry involvement (e.g., Full-time, Part-time, Volunteers, No).
///    - primaryDepartment: The member's primary department (picklist).
///    - serviceCampus: The campus where the member serves.
public struct ServingInformation: Codable, Equatable, Sendable {
    /// The type of ministry involvement (e.g., Full-time, Part-time, Volunteers, No).
    public let involved: MinistryInvolvement?
    /// The member's primary department (picklist).
    public let primaryDepartment: PrimaryDepartment?
    /// The campus where the member serves.
    public let serviceCampus: String?
}

/// A modular, extensible type representing a member's discipleship and spiritual journey information.
///
/// - Note: This struct is designed for production-grade church data modeling, supporting modular sub-structs for each major discipleship experience.
public struct DiscipleshipInformation: Codable, Equatable, Sendable, DiscipleshipInformationRepresentable {
    /// The date the member was born again (as provided by the API).
    public let bornAgainDate: String?
    /// Water baptism information.
    public let waterBaptism: WaterBaptism?
    /// Prayer course information.
    public let prayerCourse: PrayerCourse?
    /// Foundation course information.
    public let foundationCourse: FoundationCourse?
    /// Whether the member attended a life transformation camp.
    public let attendedLifeTransformationCamp: Bool?
    /// Whether the member has received the Holy Spirit filling.
    public let holySpiritFilling: Bool?
    /// The member's missionary type (picklist).
    public let missionary: MissionaryType?
    /// Whether the member is subscribed to the YouTube channel.
    public let subscribedToYoutubeChannel: SubscriptionStatus?
    /// Whether the member is subscribed to WhatsApp.
    public let subscribedToWhatsapp: SubscriptionStatus?
    /// Serving/ministry involvement information.
    public let serving: ServingInformation?
    /// The member's Bible course (picklist).
    public let bibleCourse: BibleCourse?

    enum CodingKeys: String, CodingKey {
        case bornAgainDate = "bornAgainDateText"
        case waterBaptismDate = "waterBaptismDateText"
        case waterBaptismReceived = "waterBaptism"
        case prayerCourseCompleted = "prayerCourse"
        case prayerCourseDate = "prayerCourseDateText"
        case foundationCourseCompleted = "foundationCourse"
        case attendedLifeTransformationCamp
        case holySpiritFilling = "holySpiritFiling"
        case missionary
        case subscribedToYoutubeChannel
        case subscribedToWhatsapp
        case involvedInMinistry
        case primaryDepartment
        case serviceCampus
        case bibleCourse
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bornAgainDate = try container.decodeIfPresent(String.self, forKey: .bornAgainDate)
        let waterBaptismDate = try container.decodeIfPresent(String.self, forKey: .waterBaptismDate)
        let waterBaptismReceived = try container.decodeIfPresent(Bool.self, forKey: .waterBaptismReceived)
        self.waterBaptism =
            (waterBaptismDate != nil || waterBaptismReceived != nil)
            ? WaterBaptism(date: waterBaptismDate, received: waterBaptismReceived) : nil
        let prayerCourseCompleted = try container.decodeIfPresent(Bool.self, forKey: .prayerCourseCompleted)
        let prayerCourseDate = try container.decodeIfPresent(String.self, forKey: .prayerCourseDate)
        self.prayerCourse =
            (prayerCourseCompleted != nil || prayerCourseDate != nil)
            ? PrayerCourse(completed: prayerCourseCompleted, date: prayerCourseDate) : nil
        let foundationCourseCompleted = try container.decodeIfPresent(Bool.self, forKey: .foundationCourseCompleted)
        self.foundationCourse = foundationCourseCompleted != nil ? FoundationCourse(completed: foundationCourseCompleted) : nil
        self.attendedLifeTransformationCamp = try container.decodeIfPresent(Bool.self, forKey: .attendedLifeTransformationCamp)
        self.holySpiritFilling = try container.decodeIfPresent(Bool.self, forKey: .holySpiritFilling)
        self.missionary = try container.decodeIfPresent(MissionaryType.self, forKey: .missionary)
        self.subscribedToYoutubeChannel = try container.decodeIfPresent(SubscriptionStatus.self, forKey: .subscribedToYoutubeChannel)
        self.subscribedToWhatsapp = try container.decodeIfPresent(SubscriptionStatus.self, forKey: .subscribedToWhatsapp)
        let involved = try container.decodeIfPresent(MinistryInvolvement.self, forKey: .involvedInMinistry)
        let department = try container.decodeIfPresent(PrimaryDepartment.self, forKey: .primaryDepartment)
        let campus = try container.decodeIfPresent(String.self, forKey: .serviceCampus)
        self.serving =
            (involved != nil || department != nil || campus != nil)
            ? ServingInformation(involved: involved, primaryDepartment: department, serviceCampus: campus) : nil
        self.bibleCourse = try container.decodeIfPresent(BibleCourse.self, forKey: .bibleCourse)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bornAgainDate, forKey: .bornAgainDate)
        try container.encodeIfPresent(waterBaptism?.date, forKey: .waterBaptismDate)
        try container.encodeIfPresent(waterBaptism?.received, forKey: .waterBaptismReceived)
        try container.encodeIfPresent(prayerCourse?.completed, forKey: .prayerCourseCompleted)
        try container.encodeIfPresent(prayerCourse?.date, forKey: .prayerCourseDate)
        try container.encodeIfPresent(foundationCourse?.completed, forKey: .foundationCourseCompleted)
        try container.encodeIfPresent(attendedLifeTransformationCamp, forKey: .attendedLifeTransformationCamp)
        try container.encodeIfPresent(holySpiritFilling, forKey: .holySpiritFilling)
        try container.encodeIfPresent(missionary, forKey: .missionary)
        try container.encodeIfPresent(subscribedToYoutubeChannel, forKey: .subscribedToYoutubeChannel)
        try container.encodeIfPresent(subscribedToWhatsapp, forKey: .subscribedToWhatsapp)
        try container.encodeIfPresent(serving?.involved, forKey: .involvedInMinistry)
        try container.encodeIfPresent(serving?.primaryDepartment, forKey: .primaryDepartment)
        try container.encodeIfPresent(serving?.serviceCampus, forKey: .serviceCampus)
        try container.encodeIfPresent(bibleCourse, forKey: .bibleCourse)
    }
}

public enum MissionaryType: String, Codable, CaseIterable, Sendable {
    case local = "Local"
    case national = "National"
    case international = "International"
    case localAndNational = "Local & National"
    case allThree = "All 3"
    case notApplicable = "Not Applicable"
    case unknown
    public var displayName: String {
        switch self {
        case .local: return "Local"
        case .national: return "National"
        case .international: return "International"
        case .localAndNational: return "Local & National"
        case .allThree: return "All 3"
        case .notApplicable: return "Not Applicable"
        case .unknown: return "Unknown"
        }
    }
}

public enum SubscriptionStatus: String, Codable, CaseIterable, Sendable {
    case yes = "Yes"
    case no = "No"
    case informed = "Informed" 
    case unknown
    public var displayName: String {
        switch self {
        case .yes: return "Yes"
        case .no: return "No"
        case .informed: return "Informed"
        case .unknown: return "Unknown"
        }
    }
}

public enum MinistryInvolvement: String, Codable, CaseIterable, Sendable {
    case fullTime = "Full-time"
    case partTime = "Part-time"
    case volunteers = "Volunteers"
    case no = "No"
    case unknown
    public var displayName: String {
        switch self {
        case .fullTime: return "Full-time"
        case .partTime: return "Part-time"
        case .volunteers: return "Volunteers"
        case .no: return "No"
        case .unknown: return "Unknown"
        }
    }
}

public enum PrimaryDepartment: String, Codable, CaseIterable, Sendable {
    case notApplicable = "Not Applicable"
    case officeStaff = "Office staff"
    case church = "Church"
    case youthMinistry = "Youth ministry"
    case kingsKids = "King's kids"
    case her = "HER"
    case missions = "Missions"
    case prayerTeam = "Prayer team"
    case limitlessFoundation = "Limitless foundation"
    case lifeGroups = "Life groups"
    case girlTribe = "Girl tribe"
    case spm = "SPM"
    case lifeTransformationCamp = "Life transformation camp"
    case foundationsCourse = "Foundations course"
    case prayerCourse = "Prayer course"
    case bibleCollege = "Bible college"
    case leadershipAcademy = "Leadership academy"
    case worshipTeam = "Worship team"
    case techTeam = "Tech team"
    case videoTeam = "Video team"
    case dreamTeam = "Dream team"
    case stageOperations = "Stage operations"
    case drama = "Drama"
    case dance = "Dance"
    case audio = "Audio"
    case mediaStore = "Media store"
    case communication = "Communication"
    case socialMedia = "Social Media"
    case setupBreakdown = "Setup/Breakdown"
    case eChurch = "E-Church"
    case parking = "Parking"
    case usherHost = "Usher/Host"
    case hospitality = "Hospitality"
    case security = "Security"
    case others = "others"
    case photography = "Photography"
    case welcomeTeam = "Welcome Team"
    case salvationTeam = "Salvation Team"
    case unknown
    public var displayName: String { self.rawValue }
}

public enum BibleCourse: String, Codable, CaseIterable, Sendable {
    case module1 = "Module 1"
    case module2 = "Module 2"
    case module3 = "Module 3"
    case module4 = "Module 4"
    case module5 = "Module 5"
    case module6 = "Module 6"
    case no = "No"
    case unknown
    public var displayName: String { self.rawValue }
}
