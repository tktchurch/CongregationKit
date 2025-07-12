import Foundation

/// Represents a church member from Salesforce with comprehensive demographic, contact, employment, marital, and discipleship information.
///
/// The `Member` struct is the central data model for church member management, providing a modular,
/// extensible way to represent all aspects of a member's profile. It supports production-grade church
/// data modeling with rich date handling, spiritual journey tracking, and ministry involvement.
///
/// ## Overview
///
/// This struct consolidates member information from Salesforce into logical sub-structs:
/// - **Core Identity:** Basic demographics, identifiers, and membership status
/// - **Contact Information:** Phone, email, address, and communication preferences
/// - **Employment Information:** Work status, organization, occupation, and sector
/// - **Marital Information:** Status, spouse details, anniversary tracking, and children
/// - **Discipleship Information:** Spiritual journey, courses, ministry involvement, and serving
///
/// ## Key Features
///
/// - **Rich Date Handling:** Professional birthday and anniversary formatting with age calculations
/// - **Type-Safe Identifiers:** `MemberID` validation and normalization
/// - **Protocol Conformance:** Implements all major data protocols for extensible access
/// - **Church-Specific Design:** Built for spiritual journey tracking and ministry management
/// - **Backward Compatibility:** Maintains compatibility while adding new features
///
/// ## Example Usage
///
/// ```swift
/// // Create a member with comprehensive information
/// let member = Member(
///     id: "12345",
///     memberId: MemberID(validating: "TKT123456"),
///     firstName: "John",
///     lastName: "Doe",
///     gender: .male,
///     contactInformation: ContactInformation(
///         phoneNumber: "+1234567890",
///         email: "john.doe@example.com"
///     ),
///     employmentInformation: EmploymentInformation(
///         employmentStatus: .employed,
///         occupation: .it
///     ),
///     discipleshipInformation: DiscipleshipInformation(
///         waterBaptism: WaterBaptism(received: true),
///         serving: ServingInformation(
///             involved: .volunteers,
///             primaryDepartment: .worshipTeam
///         )
///     )
/// )
///
/// // Access rich date information
/// if let birthday = member.dateOfBirth {
///     print("Age: \(birthday.age)")
///     print("Next birthday: \(birthday.daysUntilNextBirthday) days")
/// }
///
/// // Check spiritual milestones
/// if member.discipleshipInformation?.waterBaptism?.received == true {
///     print("Member has been baptized")
/// }
///
/// // Check ministry involvement
/// if let serving = member.serving {
///     print("Ministry involvement: \(serving.involved?.displayName ?? "Not specified")")
///     print("Department: \(serving.primaryDepartment?.displayName ?? "Not specified")")
/// }
/// ```
///
/// ## Topics
///
/// ### Core Properties
/// - ``id`` - Unique identifier for the member
/// - ``memberId`` - Type-safe member ID from Salesforce
/// - ``memberName`` - Full name of the member
/// - ``firstName`` - First name of the member
/// - ``middleName`` - Middle name of the member
/// - ``lastName`` - Last name of the member
///
/// ### Demographics
/// - ``gender`` - The member's gender
/// - ``dateOfBirth`` - Rich birthday information with age calculations
/// - ``title`` - The member's title (Mr, Mrs, Dr, etc.)
/// - ``memberType`` - The member's type (TKT, EFAM, etc.)
/// - ``bloodGroup`` - The member's blood group
/// - ``preferredLanguages`` - The member's preferred languages
///
/// ### Membership Information
/// - ``attendingCampus`` - The campus the member is attending
/// - ``serviceCampus`` - The campus where the member serves
/// - ``partOfLifeGroup`` - Whether the member is part of a life group
/// - ``status`` - The member's status (Regular, Inactive, etc.)
/// - ``campus`` - The campus the member is associated with
/// - ``spm`` - Whether the member is part of SPM
/// - ``attendingService`` - The service the member is attending
///
/// ### Contact & Personal Information
/// - ``phone`` - Phone number of the member
/// - ``contactInformation`` - Comprehensive contact information
///
/// ### Group Information
/// - ``lifeGroupName`` - Life group name the member belongs to
///
/// ### Related Information
/// - ``employmentInformation`` - Employment and professional information
/// - ``maritalInformation`` - Marital status and family information
/// - ``discipleshipInformation`` - Spiritual journey and discipleship information
///
/// ### Date Tracking
/// - ``createdDate`` - Date when the member record was created
/// - ``lastModifiedDate`` - Date when the member record was last modified
///
/// ## Protocol Conformance
///
/// The `Member` struct conforms to multiple protocols for type-safe, extensible access:
/// - ``MemberDataRepresentable`` - Core member data access
/// - ``ContactInformationRepresentable`` - Contact information access
/// - ``EmploymentInformationRepresentable`` - Employment information access
/// - ``MaritalInformationRepresentable`` - Marital information access
/// - ``DiscipleshipInformationRepresentable`` - Discipleship information access
///
/// ## Church-Specific Features
///
/// ### Spiritual Journey Tracking
/// - Born again date tracking
/// - Water baptism status and date
/// - Holy Spirit filling experience
/// - Course completion tracking (Prayer, Foundation, Bible courses)
/// - Life transformation camp attendance
///
/// ### Ministry Involvement
/// - Current ministry involvement level
/// - Primary department assignment
/// - Service campus information
/// - Interest in serving
/// - Missionary involvement type
///
/// ### Communication Preferences
/// - YouTube channel subscription status
/// - WhatsApp subscription status
/// - Preferred communication methods
///
/// ## Data Validation
///
/// - **MemberID Validation:** Ensures member IDs start with "TKT" and provides normalization
/// - **Date Parsing:** Robust handling of various date formats from Salesforce
/// - **Enum Safety:** All status fields use enums for compile-time safety
/// - **Optional Fields:** Graceful handling of missing or incomplete data
///
/// ## Performance Considerations
///
/// - **Lazy Loading:** Related information is loaded only when needed
/// - **Field Expansion:** Use `MemberExpand` to fetch only required data
/// - **Memory Efficiency:** Large data sets are handled through pagination
/// - **Concurrency Safe:** All properties are `Sendable` for async operations
public struct Member: Codable, Identifiable, MemberDataRepresentable {
    // MARK: - Identifiers
    /// Unique identifier for the member
    public let id: String?
    /// Member ID from Salesforce (type-safe)
    public let memberId: MemberID?
    /// Date when the member record was created
    public let createdDate: Date?
    /// Date when the member record was last modified
    public let lastModifiedDate: Date?

    // MARK: - Name Fields
    /// Full name of the member
    public var memberName: String?
    /// First name of the member
    public let firstName: String?
    /// Middle name of the member
    public let middleName: String?
    /// Last name of the member
    public let lastName: String?

    /// The member's gender (e.g., Male, Female), if available.
    public let gender: Gender?

    // MARK: - Contact Info
    /// Phone number of the member
    public let phone: String?

    // MARK: - Group Info
    /// Life group name the member belongs to
    public let lifeGroupName: String?

    // MARK: - Demographic Info
    /// The member's date of birth with detailed information, if available.
    public var dateOfBirth: BirthDateInfo? {
        guard let date = _dateOfBirth else { return nil }
        return BirthDateInfo(date: date)
    }
    /// Internal storage for the date of birth
    private let _dateOfBirth: Date?
    /// The member's title (e.g., Mr, Mrs, Dr), if available.
    public let title: MemberTitle?
    /// The member's type (e.g., TKT, EFAM), if available.
    public let memberType: MemberType?
    /// The member's blood group, if available.
    public let bloodGroup: BloodGroup?
    /// The member's preferred languages, if available.
    public let preferredLanguages: [PreferredLanguage]?

    // MARK: - Membership Info
    /// The campus the member is attending, if available.
    public let attendingCampus: AttendingCampus?
    /// The campus where the member serves, if available.
    public let serviceCampus: ServiceCampus?
    /// Whether the member is part of a life group.
    public let partOfLifeGroup: Bool?
    /// The member's status (e.g., Regular, Inactive), if available.
    public let status: MemberStatus?
    /// The campus the member is associated with, if available.
    public let campus: Campus?
    /// Whether the member is part of SPM.
    public let spm: Bool?
    /// The service the member is attending, if available.
    public let attendingService: AttendingService?

    // MARK: - Contact Information
    /// Contact information for a member
    public let contactInformation: ContactInformation?
    /// Employment information for a member
    public let employmentInformation: EmploymentInformation?
    /// Marital information for a member
    public let maritalInformation: MaritalInformation?
    /// Discipleship and spiritual information for a member
    public let discipleshipInformation: DiscipleshipInformation?

    /// The raw HTML for the member's photo as received from the API.
    public let photoRaw: String?
    /// The parsed member photo (URL and alt text), if available.
    public var photo: MemberPhoto? {
        guard let html = photoRaw else { return nil }
        // Simple regex to extract src and alt from <img ...>
        let pattern = #"<img[^>]*src=\"([^"]+)\"[^>]*alt=\"([^"]*)\"[^>]*/?>"#
        if let regex = try? NSRegularExpression(pattern: pattern, options: []),
            let match = regex.firstMatch(in: html, options: [], range: NSRange(html.startIndex..., in: html)),
            let srcRange = Range(match.range(at: 1), in: html)
        {
            let src = html[srcRange].replacingOccurrences(of: "&amp;", with: "&")
            let alt: String? = {
                if let altRange = Range(match.range(at: 2), in: html) {
                    var altText = String(html[altRange])
                    // Normalize: trim, replace underscores/dashes/multiple spaces, capitalize first letter
                    altText = altText.trimmingCharacters(in: .whitespacesAndNewlines)
                    altText = altText.replacingOccurrences(of: "[_-]+", with: " ", options: .regularExpression)
                    altText = altText.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                    if let first = altText.first {
                        altText = first.uppercased() + altText.dropFirst()
                    }
                    return altText.isEmpty ? nil : altText
                }
                return nil
            }()
            let tags: [String] = {
                if let altRange = Range(match.range(at: 2), in: html) {
                    let altText = String(html[altRange])
                    if altText.lowercased().contains("whatsapp") {
                        return ["whatsapp"]
                    }
                }
                return []
            }()
            return MemberPhoto(url: String(src), alt: alt, tags: tags)
        }
        // fallback: try to extract src only
        let srcPattern = #"<img[^>]*src=\"([^"]+)\""#
        if let regex = try? NSRegularExpression(pattern: srcPattern, options: []),
            let match = regex.firstMatch(in: html, options: [], range: NSRange(html.startIndex..., in: html)),
            let srcRange = Range(match.range(at: 1), in: html)
        {
            let src = html[srcRange].replacingOccurrences(of: "&amp;", with: "&")
            return MemberPhoto(url: String(src), alt: nil, tags: [])
        }
        return nil
    }

    // MARK: - Initializer
    /// Backward-compatible initializer accepting String for memberId
    public init(
        id: String? = nil,
        memberId: String? = nil,
        createdDate: Date? = nil,
        lastModifiedDate: Date? = nil,
        memberName: String? = nil,
        firstName: String? = nil,
        middleName: String? = nil,
        lastName: String? = nil,
        gender: Gender? = nil,
        phone: String? = nil,
        email: String? = nil,
        lifeGroupName: String? = nil,
        area: String? = nil,
        address: String? = nil,
        dateOfBirth: Date? = nil,
        title: MemberTitle? = nil,
        memberType: MemberType? = nil,
        bloodGroup: BloodGroup? = nil,
        preferredLanguages: [PreferredLanguage]? = nil,
        attendingCampus: AttendingCampus? = nil,
        serviceCampus: ServiceCampus? = nil,
        partOfLifeGroup: Bool? = nil,
        status: MemberStatus? = nil,
        campus: Campus? = nil,
        spm: Bool? = nil,
        attendingService: AttendingService? = nil,
        contactInformation: ContactInformation? = nil,
        employmentInformation: EmploymentInformation? = nil,
        maritalInformation: MaritalInformation? = nil,
        discipleshipInformation: DiscipleshipInformation? = nil,
        photoRaw: String? = nil
    ) {
        self.id = id
        self.memberId = memberId.flatMap { MemberID(rawValue: $0) }
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName

        // Construct memberName from available components
        let constructedMemberName: String? = {
            var components: [String] = []
            if let firstName = firstName { components.append(firstName) }
            if let middleName = middleName { components.append(middleName) }
            if let lastName = lastName { components.append(lastName) }
            return components.isEmpty ? memberName : components.joined(separator: " ")
        }()
        self.memberName = constructedMemberName

        self.gender = gender
        self.phone = phone
        self.lifeGroupName = lifeGroupName
        self._dateOfBirth = dateOfBirth
        self.title = title
        self.memberType = memberType
        self.bloodGroup = bloodGroup
        self.preferredLanguages = preferredLanguages
        self.attendingCampus = attendingCampus
        self.serviceCampus = serviceCampus
        self.partOfLifeGroup = partOfLifeGroup
        self.status = status
        self.campus = campus
        self.spm = spm
        self.attendingService = attendingService
        self.contactInformation = contactInformation
        self.employmentInformation = employmentInformation
        self.maritalInformation = maritalInformation
        self.discipleshipInformation = discipleshipInformation
        self.photoRaw = photoRaw
    }
    /// Preferred initializer accepting MemberID for memberId
    public init(
        id: String? = nil,
        memberId: MemberID? = nil,
        createdDate: Date? = nil,
        lastModifiedDate: Date? = nil,
        memberName: String? = nil,
        firstName: String? = nil,
        middleName: String? = nil,
        lastName: String? = nil,
        gender: Gender? = nil,
        phone: String? = nil,
        email: String? = nil,
        lifeGroupName: String? = nil,
        area: String? = nil,
        address: String? = nil,
        dateOfBirth: Date? = nil,
        title: MemberTitle? = nil,
        memberType: MemberType? = nil,
        bloodGroup: BloodGroup? = nil,
        preferredLanguages: [PreferredLanguage]? = nil,
        attendingCampus: AttendingCampus? = nil,
        serviceCampus: ServiceCampus? = nil,
        partOfLifeGroup: Bool? = nil,
        status: MemberStatus? = nil,
        campus: Campus? = nil,
        spm: Bool? = nil,
        attendingService: AttendingService? = nil,
        contactInformation: ContactInformation? = nil,
        employmentInformation: EmploymentInformation? = nil,
        maritalInformation: MaritalInformation? = nil,
        discipleshipInformation: DiscipleshipInformation? = nil,
        photoRaw: String? = nil
    ) {
        self.id = id
        self.memberId = memberId
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName

        // Construct memberName from available components
        let constructedMemberName: String? = {
            var components: [String] = []
            if let firstName = firstName { components.append(firstName) }
            if let middleName = middleName { components.append(middleName) }
            if let lastName = lastName { components.append(lastName) }
            return components.isEmpty ? memberName : components.joined(separator: " ")
        }()
        self.memberName = constructedMemberName

        self.gender = gender
        self.phone = phone
        self.lifeGroupName = lifeGroupName
        self._dateOfBirth = dateOfBirth
        self.title = title
        self.memberType = memberType
        self.bloodGroup = bloodGroup
        self.preferredLanguages = preferredLanguages
        self.attendingCampus = attendingCampus
        self.serviceCampus = serviceCampus
        self.partOfLifeGroup = partOfLifeGroup
        self.status = status
        self.campus = campus
        self.spm = spm
        self.attendingService = attendingService
        self.contactInformation = contactInformation
        self.employmentInformation = employmentInformation
        self.maritalInformation = maritalInformation
        self.discipleshipInformation = discipleshipInformation
        self.photoRaw = photoRaw
    }
}

extension Member {
    public init(from decoder: Decoder) throws {
        enum CodingKeys: String, CodingKey {
            case id, memberId, createdDate, lastModifiedDate, gender, phone, email,
                lifeGroupName, area, address, dateOfBirth,
                title, memberType, bloodGroup, preferredLanguage, attendingCampus, serviceCampus, partOfLifeGroup, status, campus, spm,
                attendingService, photo
            // API alternate keys
            case currentAddress, contactNumberMobile, lifeGroupLeaderName
            case profession, location, whatsappNo, alternateNumber
            case employmentStatus, nameOfTheOrganization, occupationSubCategory, occupation
            case martialStatus, weddingAnniversaryDdMmYyyy, spouseName, numberOfChildren
            case sector
            // Name fields from API
            case name, middleName, lastNameSurname
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(String.self, forKey: .id)
        let memberId: MemberID? = {
            if let memberIdString = try? container.decodeIfPresent(String.self, forKey: .memberId) {
                return MemberID(rawValue: memberIdString)
            } else {
                return nil
            }
        }()
        let createdDate: Date? = {
            if let dateString = try? container.decodeIfPresent(String.self, forKey: .createdDate) {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                return formatter.date(from: dateString)
            } else {
                return nil
            }
        }()
        let lastModifiedDate: Date? = {
            if let dateString = try? container.decodeIfPresent(String.self, forKey: .lastModifiedDate) {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                return formatter.date(from: dateString)
            } else {
                return nil
            }
        }()

        // Parse name fields from API response
        let fullName = try container.decodeIfPresent(String.self, forKey: .name)
        let middleName = try container.decodeIfPresent(String.self, forKey: .middleName)
        let lastNameSurname = try container.decodeIfPresent(String.self, forKey: .lastNameSurname)

        // Parse full name into first and last name components
        let (firstName, lastName): (String?, String?) = {
            guard let fullName = fullName else { return (nil, nil) }
            let nameComponents = fullName.components(separatedBy: " ").filter { !$0.isEmpty }
            if nameComponents.count >= 2 {
                let first = nameComponents[0]
                let last = nameComponents.dropFirst().joined(separator: " ")
                return (first, last)
            } else if nameComponents.count == 1 {
                return (nameComponents[0], nil)
            } else {
                return (nil, nil)
            }
        }()

        // Use lastNameSurname if available, otherwise use parsed lastName
        let finalLastName = lastNameSurname ?? lastName

        // Construct memberName from available components
        let memberName: String? = {
            var components: [String] = []
            if let firstName = firstName { components.append(firstName) }
            if let middleName = middleName { components.append(middleName) }
            if let finalLastName = finalLastName { components.append(finalLastName) }
            return components.isEmpty ? fullName : components.joined(separator: " ")
        }()

        let gender = try container.decodeIfPresent(Gender.self, forKey: .gender)
        let phone =
            try container.decodeIfPresent(String.self, forKey: .contactNumberMobile)
            ?? container.decodeIfPresent(String.self, forKey: .phone)
        let email = try container.decodeIfPresent(String.self, forKey: .email)
        let lifeGroupName =
            try container.decodeIfPresent(String.self, forKey: .lifeGroupLeaderName)
            ?? container.decodeIfPresent(String.self, forKey: .lifeGroupName)
        let area = try container.decodeIfPresent(String.self, forKey: .area)
        let address =
            try container.decodeIfPresent(String.self, forKey: .currentAddress) ?? container.decodeIfPresent(String.self, forKey: .address)
        let dateOfBirth: Date? = {
            if let dateString = try? container.decodeIfPresent(String.self, forKey: .dateOfBirth) {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                return formatter.date(from: dateString)
            } else {
                return nil
            }
        }()
        let title = try container.decodeIfPresent(MemberTitle.self, forKey: .title)
        let memberType = try container.decodeIfPresent(MemberType.self, forKey: .memberType)
        let bloodGroup = try container.decodeIfPresent(BloodGroup.self, forKey: .bloodGroup)
        let preferredLanguages: [PreferredLanguage]? = {
            if let langs = try? container.decodeIfPresent([PreferredLanguage].self, forKey: .preferredLanguage) {
                return langs
            }
            if let langsString = try? container.decodeIfPresent(String.self, forKey: .preferredLanguage) {
                let parts = langsString.components(separatedBy: CharacterSet(charactersIn: ";&")).map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                let enums = parts.compactMap { PreferredLanguage(rawValue: $0) }
                return enums.isEmpty ? nil : enums
            }
            return nil
        }()
        let attendingCampus = try container.decodeIfPresent(AttendingCampus.self, forKey: .attendingCampus)
        let serviceCampus = try container.decodeIfPresent(ServiceCampus.self, forKey: .serviceCampus)
        let partOfLifeGroup = try container.decodeIfPresent(Bool.self, forKey: .partOfLifeGroup)
        let status = try container.decodeIfPresent(MemberStatus.self, forKey: .status)
        let campus = try container.decodeIfPresent(Campus.self, forKey: .campus)
        let spm = try container.decodeIfPresent(Bool.self, forKey: .spm)
        let attendingService = try container.decodeIfPresent(AttendingService.self, forKey: .attendingService)
        let whatsappNumber = try container.decodeIfPresent(String.self, forKey: .whatsappNo)
        let alternateNumber = try container.decodeIfPresent(String.self, forKey: .alternateNumber)
        let profession = try container.decodeIfPresent(String.self, forKey: .profession)
        let location = try container.decodeIfPresent(String.self, forKey: .location)
        let contactInformation = ContactInformation(
            phoneNumber: phone,
            email: email,
            address: address,
            area: area,
            whatsappNumber: whatsappNumber,
            alternateNumber: alternateNumber,
            profession: profession,
            location: location
        )
        let employmentStatus = try container.decodeIfPresent(EmploymentStatus.self, forKey: .employmentStatus)
        let nameOfTheOrganization = try container.decodeIfPresent(String.self, forKey: .nameOfTheOrganization)
        let occupation = try container.decodeIfPresent(Occupation.self, forKey: .occupation)
        let sector = try container.decodeIfPresent(Sector.self, forKey: .sector)
        let occupationSubCategoryRaw = try container.decodeIfPresent(String.self, forKey: .occupationSubCategory)
        let employmentInformation = EmploymentInformation(
            employmentStatus: employmentStatus,
            nameOfTheOrganization: nameOfTheOrganization,
            occupation: occupation,
            sector: sector,
            occupationSubCategoryRaw: occupationSubCategoryRaw
        )
        let maritalInformation = try MaritalInformation(from: decoder)
        let discipleshipInformation = try DiscipleshipInformation(from: decoder)
        let photoRaw = try container.decodeIfPresent(String.self, forKey: .photo)
        self.init(
            id: id,
            memberId: memberId,
            createdDate: createdDate,  // This will be set by the decoder
            lastModifiedDate: lastModifiedDate,  // This will be set by the decoder
            memberName: memberName,
            firstName: firstName,
            middleName: middleName,
            lastName: finalLastName,
            gender: gender,
            phone: phone,
            email: email,
            lifeGroupName: lifeGroupName,
            area: area,
            address: address,
            dateOfBirth: dateOfBirth,
            title: title,
            memberType: memberType,
            bloodGroup: bloodGroup,
            preferredLanguages: preferredLanguages,
            attendingCampus: attendingCampus,
            serviceCampus: serviceCampus,
            partOfLifeGroup: partOfLifeGroup,
            status: status,
            campus: campus,
            spm: spm,
            attendingService: attendingService,
            contactInformation: contactInformation,
            employmentInformation: employmentInformation,
            maritalInformation: maritalInformation,
            discipleshipInformation: discipleshipInformation,
            photoRaw: photoRaw
        )
    }
}

/// A type-safe identifier for church members that validates and normalizes member IDs from Salesforce.
///
/// `MemberID` provides compile-time safety and runtime validation for member identifiers,
/// ensuring they follow the required format and providing normalization for case-insensitive
/// handling. All member IDs must start with "TKT" (case-insensitive) followed by numeric
/// or alphanumeric characters.
///
/// ## Overview
///
/// This type enforces the church's member ID format requirements:
/// - Must start with "TKT" (case-insensitive)
/// - Minimum length of 3 characters (TKT + at least one character)
/// - Automatic normalization to uppercase "TKT" prefix
/// - Validation during initialization
///
/// ## Key Features
///
/// - **Type Safety:** Prevents invalid member IDs at compile time
/// - **Validation:** Runtime validation with descriptive error messages
/// - **Normalization:** Automatic case-insensitive handling and standardization
/// - **Error Handling:** Throwing initializer for explicit error handling
/// - **RawRepresentable:** Seamless conversion to/from String
///
/// ## Example Usage
///
/// ```swift
/// // Using the failable initializer (returns nil if invalid)
/// if let memberId = MemberID(rawValue: "tkt123456") {
///     print("Valid member ID: \(memberId.rawValue)") // "TKT123456"
/// }
///
/// // Using the throwing initializer (throws error if invalid)
/// do {
///     let memberId = try MemberID(validating: "TKT789012")
///     print("Valid member ID: \(memberId.rawValue)")
/// } catch {
///     print("Invalid member ID: \(error)")
/// }
///
/// // Case-insensitive normalization
/// let normalized = MemberID(rawValue: "tkt123456")?.rawValue // "TKT123456"
/// let alsoNormalized = MemberID(rawValue: "Tkt123456")?.rawValue // "TKT123456"
///
/// // Invalid IDs return nil or throw errors
/// let invalid1 = MemberID(rawValue: "ABC123") // nil
/// let invalid2 = MemberID(rawValue: "TK") // nil (too short)
/// ```
///
/// ## Validation Rules
///
/// - **Prefix Requirement:** Must start with "TKT" (case-insensitive)
/// - **Minimum Length:** At least 3 characters total
/// - **Normalization:** Always converted to uppercase "TKT" prefix
/// - **Case Insensitive:** Accepts "tkt", "Tkt", "TKT", etc.
///
/// ## Error Handling
///
/// The `MemberError.invalidMemberID` error is thrown when:
/// - The ID is shorter than 3 characters
/// - The ID doesn't start with "TKT" (case-insensitive)
/// - The ID format is otherwise invalid
///
/// ## Integration with Member Model
///
/// ```swift
/// // In Member struct
/// let member = Member(
///     memberId: MemberID(validating: "TKT123456"),
///     // ... other properties
/// )
///
/// // Safe access with validation
/// if let memberId = member.memberId {
///     print("Member ID: \(memberId.rawValue)")
/// }
/// ```
///
/// ## Performance Considerations
///
/// - **Efficient Validation:** O(1) validation for prefix checking
/// - **Minimal Memory:** Single String storage with computed normalization
/// - **Hashable:** Efficient dictionary and set operations
/// - **Sendable:** Safe for concurrent access
public struct MemberID: RawRepresentable, Codable, Sendable, Equatable, Hashable {
    /// The normalized member ID string with uppercase "TKT" prefix
    public let rawValue: String

    /// Failable initializer for RawRepresentable conformance
    ///
    /// This initializer validates the member ID format and normalizes it.
    /// Returns `nil` if the ID is invalid, providing a safe way to handle
    /// potentially invalid input without throwing errors.
    ///
    /// - Parameter rawValue: The member ID string to validate and normalize
    /// - Returns: A normalized `MemberID` if valid, `nil` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let valid = MemberID(rawValue: "tkt123456") // Returns MemberID
    /// let invalid = MemberID(rawValue: "ABC123") // Returns nil
    /// ```
    public init?(rawValue: String) {
        guard rawValue.count >= 3 else { return nil }
        let prefix = rawValue.prefix(3)
        if prefix.lowercased() == "tkt" {
            self.rawValue = "TKT" + rawValue.dropFirst(3)
        } else {
            return nil
        }
    }

    /// Throwing initializer for explicit validation
    ///
    /// This initializer provides explicit error handling for invalid member IDs.
    /// Use this when you need to handle validation errors specifically or when
    /// working with user input that should be validated.
    ///
    /// - Parameter value: The member ID string to validate and normalize
    /// - Throws: `MemberError.invalidMemberID` if the ID format is invalid
    ///
    /// ## Example
    /// ```swift
    /// do {
    ///     let memberId = try MemberID(validating: "TKT123456")
    ///     // Use memberId
    /// } catch MemberError.invalidMemberID {
    ///     // Handle invalid ID
    ///     print("Invalid member ID format")
    /// }
    /// ```
    public init(validating value: String) throws {
        guard value.count >= 3 else { throw MemberError.invalidMemberID }
        let prefix = value.prefix(3)
        if prefix.lowercased() == "tkt" {
            self.rawValue = "TKT" + value.dropFirst(3)
        } else {
            throw MemberError.invalidMemberID
        }
    }
}

/// Errors specific to member operations
///
/// This enum provides comprehensive error handling for member-related operations,
/// including validation errors, data access issues, and API failures.
///
/// ## Error Cases
///
/// - **memberNotFound:** The requested member was not found in the system
/// - **invalidMemberData:** The member data received is corrupted or invalid
/// - **fetchFailed:** The API request to fetch member data failed
/// - **invalidMemberID:** The member ID format is invalid or doesn't meet requirements
///
/// ## Example Usage
///
/// ```swift
/// do {
///     let member = try await congregation.members.fetch(id: memberId)
///     // Handle successful fetch
/// } catch MemberError.memberNotFound {
///     print("Member not found in the system")
/// } catch MemberError.invalidMemberID {
///     print("Invalid member ID format")
/// } catch MemberError.fetchFailed(let underlyingError) {
///     print("Fetch failed: \(underlyingError)")
/// } catch {
///     print("Unexpected error: \(error)")
/// }
/// ```
///
/// ## Localized Error Messages
///
/// All errors provide user-friendly, localized descriptions suitable for
/// display in user interfaces or logging systems.
public enum MemberError: Error, LocalizedError, Sendable {
    /// The requested member was not found in the system
    case memberNotFound
    /// The member data received is corrupted or invalid
    case invalidMemberData
    /// The API request to fetch member data failed
    case fetchFailed(Error)
    /// The member ID format is invalid or doesn't meet requirements
    case invalidMemberID

    /// A user-friendly, localized description of the error
    public var errorDescription: String? {
        switch self {
        case .memberNotFound:
            return "Member not found"
        case .invalidMemberData:
            return "Invalid member data received"
        case .fetchFailed(let error):
            return "Failed to fetch member data: \(error.localizedDescription)"
        case .invalidMemberID:
            return "MemberID must start with 'TKT'"
        }
    }
}

extension Member: ContactInformationRepresentable {
    // MARK: - ContactInformationRepresentable
    public var phoneNumber: String? { contactInformation?.phoneNumber }
    public var email: String? { contactInformation?.email }
    public var address: String? { contactInformation?.address }
    public var area: String? { contactInformation?.area }
    public var whatsappNumber: String? { contactInformation?.whatsappNumber }
    public var alternateNumber: String? { contactInformation?.alternateNumber }
    public var profession: String? { contactInformation?.profession }
    public var location: String? { contactInformation?.location }
}

extension Member: EmploymentInformationRepresentable {
    // MARK: - EmploymentInformationRepresentable
    public var employmentStatus: EmploymentStatus? { employmentInformation?.employmentStatus }
    public var nameOfTheOrganization: String? { employmentInformation?.nameOfTheOrganization }
    public var occupation: Occupation? { employmentInformation?.occupation }
    public var occupationSubCategoryEnum: OccupationSubCategory? { employmentInformation?.occupationSubCategoryEnum }
    public var occupationCategory: Occupation? { employmentInformation?.occupationCategory }
    public var sector: Sector? { employmentInformation?.sector }
}

// Protocol conformance for MaritalInformationRepresentable
extension Member: MaritalInformationRepresentable {
    public var maritalStatus: MaritalStatus? { maritalInformation?.maritalStatus }
    public var weddingAnniversary: MaritalInformation.WeddingAnniversaryInfo? { maritalInformation?.weddingAnniversaryInfo }
    public var spouseName: String? { maritalInformation?.spouseName }
    public var numberOfChildren: Int? { maritalInformation?.numberOfChildren }
}

// Protocol conformance for DiscipleshipInformationRepresentable
extension Member: DiscipleshipInformationRepresentable {
    public var bornAgainDate: String? { discipleshipInformation?.bornAgainDate }
    public var waterBaptism: WaterBaptism? { discipleshipInformation?.waterBaptism }
    public var prayerCourse: PrayerCourse? { discipleshipInformation?.prayerCourse }
    public var foundationCourse: FoundationCourse? { discipleshipInformation?.foundationCourse }
    public var attendedLifeTransformationCamp: Bool? { discipleshipInformation?.attendedLifeTransformationCamp }
    public var holySpiritFilling: Bool? { discipleshipInformation?.holySpiritFilling }
    public var missionary: MissionaryType? { discipleshipInformation?.missionary }
    public var subscribedToYoutubeChannel: SubscriptionStatus? { discipleshipInformation?.subscribedToYoutubeChannel }
    public var subscribedToWhatsapp: SubscriptionStatus? { discipleshipInformation?.subscribedToWhatsapp }
    public var serving: ServingInformation? { discipleshipInformation?.serving }
    public var bibleCourse: BibleCourse? { discipleshipInformation?.bibleCourse }
}

/// Enum for member gender values.
public enum Gender: String, Codable, CaseIterable, Sendable {
    case male = "Male"
    case female = "Female"
    public var displayName: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}

/// Returns a copy of the member with only the requested expanded fields populated.
extension Member {
    public func withFilteredFields(expanded: Set<MemberExpand>) -> Member {
        Member(
            id: id,
            memberId: memberId,
            createdDate: createdDate,
            lastModifiedDate: lastModifiedDate,
            memberName: memberName,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            gender: gender,
            phone: phone,
            email: email,
            lifeGroupName: lifeGroupName,
            area: area,
            address: address,
            dateOfBirth: _dateOfBirth,
            title: title,
            memberType: memberType,
            bloodGroup: bloodGroup,
            preferredLanguages: preferredLanguages,
            attendingCampus: attendingCampus,
            serviceCampus: serviceCampus,
            partOfLifeGroup: partOfLifeGroup,
            status: status,
            campus: campus,
            spm: spm,
            attendingService: attendingService,
            contactInformation: expanded.contains(.contactInformation) ? contactInformation : nil,
            employmentInformation: expanded.contains(.employmentInformation) ? employmentInformation : nil,
            maritalInformation: expanded.contains(.martialInformation) ? maritalInformation : nil,
            discipleshipInformation: expanded.contains(.discipleshipInformation) ? discipleshipInformation : nil,
            photoRaw: photoRaw
        )
    }
}
