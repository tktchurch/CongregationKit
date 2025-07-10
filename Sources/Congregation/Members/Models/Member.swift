import Foundation

/// Represents a church member from Salesforce
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
        discipleshipInformation: DiscipleshipInformation? = nil
    ) {
        self.id = id
        self.memberId = memberId.flatMap { MemberID(rawValue: $0) }
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate
        self.memberName = memberName
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        if let firstName = firstName, let middleName = middleName, let lastName = lastName {
            self.memberName = firstName + " " + middleName + " " + lastName
        } else {
            self.memberName = memberName
        }
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
        discipleshipInformation: DiscipleshipInformation? = nil
    ) {
        self.id = id
        self.memberId = memberId
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate
        self.memberName = memberName
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        if let firstName = firstName, let middleName = middleName, let lastName = lastName {
            self.memberName = firstName + " " + middleName + " " + lastName
        } else {
            self.memberName = memberName
        }
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
    }
}

extension Member {
    public init(from decoder: Decoder) throws {
        enum CodingKeys: String, CodingKey {
            case id, memberId, createdDate, lastModifiedDate, memberName, firstName, middleName, lastName, gender, phone, email, lifeGroupName, area, address, dateOfBirth,
                title, memberType, bloodGroup, preferredLanguage, attendingCampus, serviceCampus, partOfLifeGroup, status, campus, spm, attendingService
            // API alternate keys
            case currentAddress, contactNumberMobile, lifeGroupLeaderName
            case profession, location, whatsappNo, alternateNumber
            case employmentStatus, nameOfTheOrganization, occupationSubCategory, occupation
            case martialStatus, weddingAnniversaryDdMmYyyy, spouseName, numberOfChildren
            case sector
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
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        let middleName = try container.decodeIfPresent(String.self, forKey: .middleName)
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        let memberName = try container.decodeIfPresent(String.self, forKey: .memberName)
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
        let maritalStatus = try container.decodeIfPresent(MaritalStatus.self, forKey: .martialStatus)
        let weddingAnniversary = try container.decodeIfPresent(String.self, forKey: .weddingAnniversaryDdMmYyyy)
        let spouseName = try container.decodeIfPresent(String.self, forKey: .spouseName)
        let numberOfChildren = try container.decodeIfPresent(Int.self, forKey: .numberOfChildren)
        let maritalInformation = MaritalInformation(
            maritalStatus: maritalStatus,
            weddingAnniversary: weddingAnniversary.flatMap { MaritalInformation.dateFormatter.date(from: $0) },
            spouseName: spouseName,
            numberOfChildren: numberOfChildren
        )
        let discipleshipInformation = try DiscipleshipInformation(from: decoder)
        self.init(
            id: id,
            memberId: memberId,
            createdDate: createdDate, // This will be set by the decoder
            lastModifiedDate: lastModifiedDate, // This will be set by the decoder
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
            discipleshipInformation: discipleshipInformation
        )
    }
}

public struct MemberID: RawRepresentable, Codable, Sendable, Equatable, Hashable {
    public let rawValue: String

    /// Failable initializer for RawRepresentable conformance
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
public enum MemberError: Error, LocalizedError, Sendable {
    case memberNotFound
    case invalidMemberData
    case fetchFailed(Error)
    case invalidMemberID

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
            discipleshipInformation: expanded.contains(.discipleshipInformation) ? discipleshipInformation : nil
        )
    }
}
