import Foundation

/// Represents a member's interest level in serving within the church ministry.
///
/// This enum defines the different levels of interest a member may have in serving,
/// which helps church leadership understand availability for ministry opportunities.
///
/// ## Topics
///
/// ### Cases
/// - ``yes`` - Member is fully available to serve
/// - ``no`` - Member is not currently available to serve
/// - ``yesButLimitedTime`` - Member can serve but with time limitations
///
/// ### Display Properties
/// - ``displayName`` - User-friendly display name
/// - ``shortDisplay`` - Short format for UI display
/// - ``internationalFormat`` - International standard format
///
/// ## Example Usage
/// ```swift
/// if let interested = member.serving?.interested {
///     switch interested {
///     case .yes:
///         print("Fully available for ministry")
///     case .yesButLimitedTime:
///         print("Available with time constraints")
///     case .no:
///         print("Not currently available")
///     }
/// }
/// ```
public enum InterestedToServe: String, Codable, CaseIterable, Sendable {
    /// Member is fully available to serve in ministry.
    case yes = "Yes"
    /// Member is not currently available to serve.
    case no = "No"
    /// Member can serve but has time limitations.
    case yesButLimitedTime = "Yes but limited time"
    
    /// A user-friendly display name for the service interest level.
    public var displayName: String {
        switch self {
        case .yes: return "Yes"
        case .no: return "No"
        case .yesButLimitedTime: return "Yes but limited time"
        }
    }
    
    /// A short display format suitable for UI components.
    public var shortDisplay: String {
        switch self {
        case .yes: return "Yes"
        case .no: return "No"
        case .yesButLimitedTime: return "Limited"
        }
    }
    
    /// International standard format for the service interest level.
    public var internationalFormat: String {
        switch self {
        case .yes: return "YES"
        case .no: return "NO"
        case .yesButLimitedTime: return "LIMITED"
        }
    }
}

/// Represents a member's water baptism experience and status.
///
/// This struct captures information about a member's water baptism journey,
/// including whether they have received baptism and the associated date.
///
/// ## Topics
///
/// ### Properties
/// - ``date`` - The date of water baptism (may be year or full date)
/// - ``received`` - Whether the member has received water baptism
///
/// ## Example Usage
/// ```swift
/// if let waterBaptism = member.waterBaptism {
///     if waterBaptism.received == true {
///         print("Baptized on: \(waterBaptism.date ?? "Date not specified")")
///     } else {
///         print("Not yet baptized")
///     }
/// }
/// ```
public struct WaterBaptism: Codable, Equatable, Sendable {
    /// The date of water baptism as provided by the API.
    ///
    /// This may be a full date or just a year, depending on the data available.
    public let date: String?
    
    /// Whether the member has received water baptism.
    ///
    /// `true` indicates the member has been baptized, `false` indicates they haven't,
    /// and `nil` means the information is not available.
    public let received: Bool?
}

/// Represents a member's prayer course completion status and details.
///
/// This struct tracks whether a member has completed the prayer course
/// and includes the completion date if available.
///
/// ## Topics
///
/// ### Properties
/// - ``completed`` - Whether the member has completed the prayer course
/// - ``date`` - The date the prayer course was completed
///
/// ## Example Usage
/// ```swift
/// if let prayerCourse = member.prayerCourse {
///     if prayerCourse.completed == true {
///         print("Completed prayer course on: \(prayerCourse.date ?? "Date not specified")")
///     } else {
///         print("Prayer course not yet completed")
///     }
/// }
/// ```
public struct PrayerCourse: Codable, Equatable, Sendable {
    /// Whether the member has completed the prayer course.
    ///
    /// `true` indicates completion, `false` indicates not completed,
    /// and `nil` means the information is not available.
    public let completed: Bool?
    
    /// The date the prayer course was completed, if available.
    ///
    /// This may be a full date or just a year, depending on the data available.
    public let date: String?
}

/// Represents a member's foundation course completion status.
///
/// This struct tracks whether a member has completed the foundation course,
/// which is a key component of the church's discipleship program.
///
/// ## Topics
///
/// ### Properties
/// - ``completed`` - Whether the member has completed the foundation course
///
/// ## Example Usage
/// ```swift
/// if let foundationCourse = member.foundationCourse {
///     if foundationCourse.completed == true {
///         print("Foundation course completed")
///     } else {
///         print("Foundation course not yet completed")
///     }
/// }
/// ```
public struct FoundationCourse: Codable, Equatable, Sendable {
    /// Whether the member has completed the foundation course.
    ///
    /// `true` indicates completion, `false` indicates not completed,
    /// and `nil` means the information is not available.
    public let completed: Bool?
}

/// Represents a member's serving and ministry involvement information.
///
/// This struct consolidates all information related to a member's ministry involvement,
/// including their current involvement level, primary department, service campus,
/// and interest in serving.
///
/// ## Topics
///
/// ### Properties
/// - ``involved`` - The type of ministry involvement
/// - ``primaryDepartment`` - The member's primary department
/// - ``serviceCampus`` - The campus where the member serves
/// - ``interested`` - Whether the member is interested to serve
///
/// ## Example Usage
/// ```swift
/// if let serving = member.serving {
///     print("Involvement: \(serving.involved?.displayName ?? "Not specified")")
///     print("Department: \(serving.primaryDepartment?.displayName ?? "Not specified")")
///     print("Campus: \(serving.serviceCampus ?? "Not specified")")
///     print("Interested: \(serving.interested?.displayName ?? "Not specified")")
/// }
/// ```
public struct ServingInformation: Codable, Equatable, Sendable {
    /// The type of ministry involvement (e.g., Full-time, Part-time, Volunteers, No).
    ///
    /// This indicates the member's current level of involvement in ministry activities.
    public let involved: MinistryInvolvement?
    
    /// The member's primary department (picklist).
    ///
    /// This represents the main area of ministry where the member serves or is interested in serving.
    public let primaryDepartment: PrimaryDepartment?
    
    /// The campus where the member serves.
    ///
    /// This indicates which church campus the member is associated with for ministry purposes.
    public let serviceCampus: String?
    
    /// Whether the member is interested to serve.
    ///
    /// This indicates the member's interest level in serving, regardless of current involvement.
    public let interested: InterestedToServe?
    
    /// Coding keys for mapping API fields to struct properties.
    enum CodingKeys: String, CodingKey {
        case involved = "involvedInMinistry"
        case primaryDepartment
        case serviceCampus
        case interested = "interestedToServe"
    }
}

/// A comprehensive representation of a member's discipleship and spiritual journey information.
///
/// This struct provides a modular, extensible way to represent all aspects of a member's
/// spiritual development and discipleship journey within the church. It supports
/// production-grade church data modeling with modular sub-structs for each major
/// discipleship experience.
///
/// ## Topics
///
/// ### Core Discipleship Information
/// - ``bornAgainDate`` - The date the member was born again
/// - ``waterBaptism`` - Water baptism information
/// - ``prayerCourse`` - Prayer course information
/// - ``foundationCourse`` - Foundation course information
///
/// ### Spiritual Experiences
/// - ``attendedLifeTransformationCamp`` - Life transformation camp attendance
/// - ``holySpiritFilling`` - Holy Spirit filling experience
/// - ``missionary`` - Missionary type and involvement
///
/// ### Communication Preferences
/// - ``subscribedToYoutubeChannel`` - YouTube channel subscription status
/// - ``subscribedToWhatsapp`` - WhatsApp subscription status
///
/// ### Ministry Involvement
/// - ``serving`` - Serving and ministry involvement information
/// - ``bibleCourse`` - Bible course participation
///
/// ## Example Usage
/// ```swift
/// if let discipleship = member.discipleshipInformation {
///     // Check spiritual milestones
///     if discipleship.waterBaptism?.received == true {
///         print("Member has been baptized")
///     }
///     
///     if discipleship.holySpiritFilling == true {
///         print("Member has received Holy Spirit filling")
///     }
///     
///     // Check ministry involvement
///     if let serving = discipleship.serving {
///         print("Ministry involvement: \(serving.involved?.displayName ?? "Not specified")")
///         print("Interested to serve: \(serving.interested?.displayName ?? "Not specified")")
///     }
///     
///     // Check course completions
///     if discipleship.prayerCourse?.completed == true {
///         print("Prayer course completed")
///     }
///     
///     if discipleship.foundationCourse?.completed == true {
///         print("Foundation course completed")
///     }
/// }
/// ```
public struct DiscipleshipInformation: Codable, Equatable, Sendable, DiscipleshipInformationRepresentable {
    /// The date the member was born again, as provided by the API.
    ///
    /// This may be a full date or just a year, depending on the data available.
    public let bornAgainDate: String?
    
    /// Water baptism information including date and completion status.
    public let waterBaptism: WaterBaptism?
    
    /// Prayer course information including completion status and date.
    public let prayerCourse: PrayerCourse?
    
    /// Foundation course information including completion status.
    public let foundationCourse: FoundationCourse?
    
    /// Whether the member attended a life transformation camp.
    ///
    /// `true` indicates attendance, `false` indicates no attendance,
    /// and `nil` means the information is not available.
    public let attendedLifeTransformationCamp: Bool?
    
    /// Whether the member has received the Holy Spirit filling.
    ///
    /// `true` indicates they have received the Holy Spirit filling,
    /// `false` indicates they haven't, and `nil` means the information is not available.
    public let holySpiritFilling: Bool?
    
    /// The member's missionary type and level of involvement.
    ///
    /// This indicates whether the member is involved in local, national, or international missions.
    public let missionary: MissionaryType?
    
    /// Whether the member is subscribed to the YouTube channel.
    ///
    /// This tracks the member's engagement with church's digital content.
    public let subscribedToYoutubeChannel: SubscriptionStatus?
    
    /// Whether the member is subscribed to WhatsApp communications.
    ///
    /// This tracks the member's engagement with church's messaging platform.
    public let subscribedToWhatsapp: SubscriptionStatus?
    
    /// Comprehensive serving and ministry involvement information.
    ///
    /// This includes current involvement, primary department, service campus, and interest level.
    public let serving: ServingInformation?
    
    /// The member's Bible course participation and progress.
    ///
    /// This tracks which Bible course modules the member has completed or is currently taking.
    public let bibleCourse: BibleCourse?

    /// Coding keys for mapping API fields to struct properties.
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
        case interestedToServe
        case bibleCourse
    }

    /// Creates a new DiscipleshipInformation instance from a decoder.
    ///
    /// This initializer handles the complex mapping between API field names and struct properties,
    /// including the creation of nested structs when appropriate data is available.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: `DecodingError` if the data is corrupted or invalid.
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
        let interestedToServe = try container.decodeIfPresent(InterestedToServe.self, forKey: .interestedToServe)
        self.serving =
            (involved != nil || department != nil || campus != nil || interestedToServe != nil)
            ? ServingInformation(involved: involved, primaryDepartment: department, serviceCampus: campus, interested: interestedToServe) : nil
        self.bibleCourse = try container.decodeIfPresent(BibleCourse.self, forKey: .bibleCourse)
    }

    /// Encodes the DiscipleshipInformation instance to an encoder.
    ///
    /// This method handles the reverse mapping from struct properties back to API field names
    /// for proper serialization.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: `EncodingError` if the data cannot be encoded.
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
        try container.encodeIfPresent(serving?.interested, forKey: .interestedToServe)
        try container.encodeIfPresent(bibleCourse, forKey: .bibleCourse)
    }
}

/// Represents the different types of missionary involvement a member may have.
///
/// This enum defines the various levels and scopes of missionary work that members
/// can participate in, from local to international missions.
///
/// ## Topics
///
/// ### Cases
/// - ``local`` - Local missionary work
/// - ``national`` - National missionary work
/// - ``international`` - International missionary work
/// - ``localAndNational`` - Both local and national missionary work
/// - ``allThree`` - Local, national, and international missionary work
/// - ``notApplicable`` - Not applicable to the member
/// - ``unknown`` - Unknown or unspecified missionary type
///
/// ### Display Properties
/// - ``displayName`` - User-friendly display name
///
/// ## Example Usage
/// ```swift
/// if let missionary = member.missionary {
///     switch missionary {
///     case .local:
///         print("Involved in local missions")
///     case .international:
///         print("Involved in international missions")
///     case .allThree:
///         print("Involved in all levels of missions")
///     default:
///         print("Other missionary involvement")
///     }
/// }
/// ```
public enum MissionaryType: String, Codable, CaseIterable, Sendable {
    /// Local missionary work within the community.
    case local = "Local"
    /// National missionary work within the country.
    case national = "National"
    /// International missionary work abroad.
    case international = "International"
    /// Both local and national missionary work.
    case localAndNational = "Local & National"
    /// Local, national, and international missionary work.
    case allThree = "All 3"
    /// Not applicable to the member.
    case notApplicable = "Not Applicable"
    /// Unknown or unspecified missionary type.
    case unknown
    
    /// A user-friendly display name for the missionary type.
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

/// Represents the subscription status for various communication channels.
///
/// This enum tracks whether members are subscribed to different church communication
/// platforms and their engagement level.
///
/// ## Topics
///
/// ### Cases
/// - ``yes`` - Member is subscribed
/// - ``no`` - Member is not subscribed
/// - ``informed`` - Member has been informed about the channel
/// - ``unknown`` - Subscription status is unknown
///
/// ### Display Properties
/// - ``displayName`` - User-friendly display name
///
/// ## Example Usage
/// ```swift
/// if let youtubeStatus = member.subscribedToYoutubeChannel {
///     switch youtubeStatus {
///     case .yes:
///         print("Subscribed to YouTube channel")
///     case .no:
///         print("Not subscribed to YouTube channel")
///     case .informed:
///         print("Informed about YouTube channel")
///     case .unknown:
///         print("YouTube subscription status unknown")
///     }
/// }
/// ```
public enum SubscriptionStatus: String, Codable, CaseIterable, Sendable {
    /// Member is subscribed to the communication channel.
    case yes = "Yes"
    /// Member is not subscribed to the communication channel.
    case no = "No"
    /// Member has been informed about the communication channel.
    case informed = "Informed"
    /// Subscription status is unknown or unspecified.
    case unknown
    
    /// A user-friendly display name for the subscription status.
    public var displayName: String {
        switch self {
        case .yes: return "Yes"
        case .no: return "No"
        case .informed: return "Informed"
        case .unknown: return "Unknown"
        }
    }
}

/// Represents the different levels of ministry involvement a member may have.
///
/// This enum defines the various types of ministry involvement, from full-time
/// ministry to no current involvement.
///
/// ## Topics
///
/// ### Cases
/// - ``fullTime`` - Full-time ministry involvement
/// - ``partTime`` - Part-time ministry involvement
/// - ``volunteers`` - Volunteer ministry involvement
/// - ``no`` - No current ministry involvement
/// - ``unknown`` - Unknown or unspecified involvement
///
/// ### Display Properties
/// - ``displayName`` - User-friendly display name
///
/// ## Example Usage
/// ```swift
/// if let involvement = member.serving?.involved {
///     switch involvement {
///     case .fullTime:
///         print("Full-time ministry involvement")
///     case .partTime:
///         print("Part-time ministry involvement")
///     case .volunteers:
///         print("Volunteer ministry involvement")
///     case .no:
///         print("No current ministry involvement")
///     case .unknown:
///         print("Ministry involvement unknown")
///     }
/// }
/// ```
public enum MinistryInvolvement: String, Codable, CaseIterable, Sendable {
    /// Full-time ministry involvement.
    case fullTime = "Full-time"
    /// Part-time ministry involvement.
    case partTime = "Part-time"
    /// Volunteer ministry involvement.
    case volunteers = "Volunteers"
    /// No current ministry involvement.
    case no = "No"
    /// Unknown or unspecified ministry involvement.
    case unknown
    
    /// A user-friendly display name for the ministry involvement level.
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

/// Represents the various departments and ministry areas within the church.
///
/// This enum defines all the different departments and ministry areas where
/// members can serve and be involved.
///
/// ## Topics
///
/// ### Core Departments
/// - ``officeStaff`` - Office staff
/// - ``church`` - General church ministry
/// - ``youthMinistry`` - Youth ministry
/// - ``kingsKids`` - King's kids ministry
/// - ``her`` - HER ministry
/// - ``missions`` - Missions department
///
/// ### Worship and Creative Arts
/// - ``worshipTeam`` - Worship team
/// - ``drama`` - Drama ministry
/// - ``dance`` - Dance ministry
/// - ``audio`` - Audio ministry
/// - ``videoTeam`` - Video team
/// - ``photography`` - Photography ministry
///
/// ### Technical and Support
/// - ``techTeam`` - Tech team
/// - ``stageOperations`` - Stage operations
/// - ``setupBreakdown`` - Setup/Breakdown team
/// - ``parking`` - Parking ministry
/// - ``security`` - Security team
///
/// ### Outreach and Hospitality
/// - ``usherHost`` - Usher/Host ministry
/// - ``hospitality`` - Hospitality ministry
/// - ``welcomeTeam`` - Welcome team
/// - ``salvationTeam`` - Salvation team
///
/// ### Education and Training
/// - ``lifeTransformationCamp`` - Life transformation camp
/// - ``foundationsCourse`` - Foundations course
/// - ``prayerCourse`` - Prayer course
/// - ``bibleCollege`` - Bible college
/// - ``leadershipAcademy`` - Leadership academy
///
/// ### Communication and Media
/// - ``communication`` - Communication team
/// - ``socialMedia`` - Social media team
/// - ``mediaStore`` - Media store
/// - ``eChurch`` - E-Church ministry
///
/// ### Other Ministries
/// - ``prayerTeam`` - Prayer team
/// - ``limitlessFoundation`` - Limitless foundation
/// - ``lifeGroups`` - Life groups
/// - ``girlTribe`` - Girl tribe
/// - ``spm`` - SPM ministry
/// - ``dreamTeam`` - Dream team
/// - ``others`` - Other ministries
///
/// ### Special Cases
/// - ``notApplicable`` - Not applicable
/// - ``unknown`` - Unknown or unspecified department
///
/// ### Display Properties
/// - ``displayName`` - User-friendly display name
///
/// ## Example Usage
/// ```swift
/// if let department = member.serving?.primaryDepartment {
///     switch department {
///     case .worshipTeam:
///         print("Serving in worship team")
///     case .youthMinistry:
///         print("Serving in youth ministry")
///     case .missions:
///         print("Serving in missions")
///     default:
///         print("Serving in \(department.displayName)")
///     }
/// }
/// ```
public enum PrimaryDepartment: String, Codable, CaseIterable, Sendable {
    /// Not applicable to the member.
    case notApplicable = "Not Applicable"
    /// Office staff department.
    case officeStaff = "Office staff"
    /// General church ministry.
    case church = "Church"
    /// Youth ministry department.
    case youthMinistry = "Youth ministry"
    /// King's kids ministry.
    case kingsKids = "King's kids"
    /// HER ministry.
    case her = "HER"
    /// Missions department.
    case missions = "Missions"
    /// Prayer team ministry.
    case prayerTeam = "Prayer team"
    /// Limitless foundation ministry.
    case limitlessFoundation = "Limitless foundation"
    /// Life groups ministry.
    case lifeGroups = "Life groups"
    /// Girl tribe ministry.
    case girlTribe = "Girl tribe"
    /// SPM ministry.
    case spm = "SPM"
    /// Life transformation camp ministry.
    case lifeTransformationCamp = "Life transformation camp"
    /// Foundations course ministry.
    case foundationsCourse = "Foundations course"
    /// Prayer course ministry.
    case prayerCourse = "Prayer course"
    /// Bible college ministry.
    case bibleCollege = "Bible college"
    /// Leadership academy ministry.
    case leadershipAcademy = "Leadership academy"
    /// Worship team ministry.
    case worshipTeam = "Worship team"
    /// Tech team ministry.
    case techTeam = "Tech team"
    /// Video team ministry.
    case videoTeam = "Video team"
    /// Dream team ministry.
    case dreamTeam = "Dream team"
    /// Stage operations ministry.
    case stageOperations = "Stage operations"
    /// Drama ministry.
    case drama = "Drama"
    /// Dance ministry.
    case dance = "Dance"
    /// Audio ministry.
    case audio = "Audio"
    /// Media store ministry.
    case mediaStore = "Media store"
    /// Communication team ministry.
    case communication = "Communication"
    /// Social media team ministry.
    case socialMedia = "Social Media"
    /// Setup/Breakdown team ministry.
    case setupBreakdown = "Setup/Breakdown"
    /// E-Church ministry.
    case eChurch = "E-Church"
    /// Parking ministry.
    case parking = "Parking"
    /// Usher/Host ministry.
    case usherHost = "Usher/Host"
    /// Hospitality ministry.
    case hospitality = "Hospitality"
    /// Security team ministry.
    case security = "Security"
    /// Other ministries.
    case others = "others"
    /// Photography ministry.
    case photography = "Photography"
    /// Welcome team ministry.
    case welcomeTeam = "Welcome Team"
    /// Salvation team ministry.
    case salvationTeam = "Salvation Team"
    /// Unknown or unspecified department.
    case unknown
    
    /// A user-friendly display name for the department.
    public var displayName: String { self.rawValue }
}

/// Represents the different Bible course modules available to members.
///
/// This enum defines the various Bible course modules that members can take
/// as part of their spiritual development and education.
///
/// ## Topics
///
/// ### Course Modules
/// - ``module1`` - Module 1
/// - ``module2`` - Module 2
/// - ``module3`` - Module 3
/// - ``module4`` - Module 4
/// - ``module5`` - Module 5
/// - ``module6`` - Module 6
///
/// ### Special Cases
/// - ``no`` - No Bible course participation
/// - ``unknown`` - Unknown or unspecified Bible course status
///
/// ### Display Properties
/// - ``displayName`` - User-friendly display name
///
/// ## Example Usage
/// ```swift
/// if let bibleCourse = member.bibleCourse {
///     switch bibleCourse {
///     case .module1:
///         print("Currently in Module 1")
///     case .module6:
///         print("Completed all modules")
///     case .no:
///         print("Not currently taking Bible course")
///     case .unknown:
///         print("Bible course status unknown")
///     default:
///         print("In \(bibleCourse.displayName)")
///     }
/// }
/// ```
public enum BibleCourse: String, Codable, CaseIterable, Sendable {
    /// Bible course Module 1.
    case module1 = "Module 1"
    /// Bible course Module 2.
    case module2 = "Module 2"
    /// Bible course Module 3.
    case module3 = "Module 3"
    /// Bible course Module 4.
    case module4 = "Module 4"
    /// Bible course Module 5.
    case module5 = "Module 5"
    /// Bible course Module 6.
    case module6 = "Module 6"
    /// No Bible course participation.
    case no = "No"
    /// Unknown or unspecified Bible course status.
    case unknown
    
    /// A user-friendly display name for the Bible course.
    public var displayName: String { self.rawValue }
}
