import Foundation

/// Enum for employment sector values from Salesforce
public enum Sector: String, Codable, CaseIterable, Sendable {
    case governmentPublic = "Government/Public"
    case privateSector = "Private"
    case business = "Business"
    case privateAndBusiness = "Private & Business"
    case govPublicAndBusiness = "Gov/Public & Business"
    case notApplicable = "Not Applicable"
    
    public var displayName: String {
        switch self {
        case .governmentPublic: return "Government/Public"
        case .privateSector: return "Private"
        case .business: return "Business"
        case .privateAndBusiness: return "Private & Business"
        case .govPublicAndBusiness: return "Gov/Public & Business"
        case .notApplicable: return "Not Applicable"
        }
    }
    
    public var shortDisplay: String {
        switch self {
        case .governmentPublic: return "Gov/Pub"
        case .privateSector: return "Private"
        case .business: return "Business"
        case .privateAndBusiness: return "Priv+Biz"
        case .govPublicAndBusiness: return "Gov+Biz"
        case .notApplicable: return "N/A"
        }
    }
    
    public var internationalFormat: String {
        switch self {
        case .governmentPublic: return "GOV_PUB"
        case .privateSector: return "PRIVATE"
        case .business: return "BUSINESS"
        case .privateAndBusiness: return "PRIV_BIZ"
        case .govPublicAndBusiness: return "GOV_BIZ"
        case .notApplicable: return "NA"
        }
    }
}

/// A type representing a member's employment information, including status, organization, occupation, and subcategory.
///
/// - Note: This struct supports hierarchical occupation modeling. Use `occupationCategory` and `occupationSubCategoryEnum` for safe access to category and subcategory.
public struct EmploymentInformation: Codable, Equatable, Sendable, EmploymentInformationRepresentable {
    /// The member's employment status (e.g., employed, student, retired).
    public let employmentStatus: EmploymentStatus?
    /// The name of the organization where the member is employed.
    public let nameOfTheOrganization: String?
    /// The member's occupation category (e.g., IT, Education).
    public let occupation: Occupation?
    /// The member's employment sector (e.g., Government/Public, Private, Business).
    public let sector: Sector?
    private let subCategoryRawValue: String?
    /// The member's occupation subcategory, if available (e.g., Doctor, Teacher).
    public var occupationSubCategoryEnum: OccupationSubCategory? {
        guard let raw = subCategoryRawValue else { return nil }
        return OccupationSubCategory(rawValue: raw)
    }
    /// The occupation category, inferred from the subcategory if not directly provided.
    public var occupationCategory: Occupation? {
        if let occupation = occupation { return occupation }
        guard let sub = occupationSubCategoryEnum else { return nil }
        return Occupation.allCases.first(where: { $0.subcategories.contains(sub) })
    }
    /// Creates a new EmploymentInformation instance.
    /// - Parameters:
    ///   - employmentStatus: The member's employment status.
    ///   - nameOfTheOrganization: The name of the organization.
    ///   - occupation: The occupation category.
    ///   - sector: The employment sector.
    ///   - occupationSubCategoryRaw: The raw value for the occupation subcategory.
    public init(
        employmentStatus: EmploymentStatus?, nameOfTheOrganization: String?, occupation: Occupation?, sector: Sector?, occupationSubCategoryRaw: String?
    ) {
        self.employmentStatus = employmentStatus
        self.nameOfTheOrganization = nameOfTheOrganization
        self.occupation = occupation
        self.sector = sector
        self.subCategoryRawValue = occupationSubCategoryRaw
    }
    enum CodingKeys: String, CodingKey {
        case employmentStatus, nameOfTheOrganization, occupation, sector, occupationSubCategory
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.employmentStatus = try container.decodeIfPresent(EmploymentStatus.self, forKey: .employmentStatus)
        self.nameOfTheOrganization = try container.decodeIfPresent(String.self, forKey: .nameOfTheOrganization)
        self.occupation = try container.decodeIfPresent(Occupation.self, forKey: .occupation)
        self.sector = try container.decodeIfPresent(Sector.self, forKey: .sector)
        self.subCategoryRawValue = try container.decodeIfPresent(String.self, forKey: .occupationSubCategory)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(employmentStatus, forKey: .employmentStatus)
        try container.encodeIfPresent(nameOfTheOrganization, forKey: .nameOfTheOrganization)
        try container.encodeIfPresent(occupation, forKey: .occupation)
        try container.encodeIfPresent(sector, forKey: .sector)
        try container.encodeIfPresent(subCategoryRawValue, forKey: .occupationSubCategory)
    }
}

public enum EmploymentStatus: String, Codable, CaseIterable, Sendable {
    case employed = "Employed"
    case employedAndBusiness = "Employed & Business"
    case unemployed = "Unemployed"
    case student = "Student"
    case homemaker = "Homemaker"
    case retired = "Retired"
    case selfEmployed = "Self Employed"
    case businessPrincipal = "Business/Principal"
    case privateEmployed = "Private"
    case government = "Government"
    case notApplicable = "Not Applicable"
    case other
    public var displayName: String {
        switch self {
        case .employed: return "Employed"
        case .employedAndBusiness: return "Employed & Business"
        case .unemployed: return "Unemployed"
        case .student: return "Student"
        case .homemaker: return "Homemaker"
        case .retired: return "Retired"
        case .selfEmployed: return "Self Employed"
        case .businessPrincipal: return "Business/Principal"
        case .privateEmployed: return "Private"
        case .government: return "Government"
        case .notApplicable: return "Not Applicable"
        case .other: return "Other"
        }
    }
    public var shortDisplay: String {
        switch self {
        case .employed: return "Emp"
        case .employedAndBusiness: return "Emp+Biz"
        case .unemployed: return "Unemp"
        case .student: return "Stud"
        case .homemaker: return "Home"
        case .retired: return "Ret"
        case .selfEmployed: return "SelfEmp"
        case .businessPrincipal: return "BizPrin"
        case .privateEmployed: return "Priv"
        case .government: return "Gov"
        case .notApplicable: return "N/A"
        case .other: return "Other"
        }
    }
    public var internationalFormat: String {
        switch self {
        case .employed: return "EMP"
        case .employedAndBusiness: return "EMP_BIZ"
        case .unemployed: return "UNEMP"
        case .student: return "STUD"
        case .homemaker: return "HOME"
        case .retired: return "RET"
        case .selfEmployed: return "SELFEMP"
        case .businessPrincipal: return "BIZPRIN"
        case .privateEmployed: return "PRIV"
        case .government: return "GOV"
        case .notApplicable: return "NA"
        case .other: return "OTHER"
        }
    }
}

public enum Occupation: String, Codable, CaseIterable, Sendable {
    case ministry = "Ministry"
    case healthCare = "Health Care"
    case defence = "Defence"
    case police = "Police"
    case corporate = "Corporate"
    case education = "Education"
    case realEstate = "Real Estate"
    case media = "Media"
    case it = "IT/ITES"
    case humanResource = "Human Resource"
    case banking = "Banking"
    case others = "Others"
    case notApplicable = "Not Applicable"
    case government = "Government"
    case other
    public var displayName: String { self.rawValue }
    public var shortDisplay: String {
        switch self {
        case .ministry: return "Min"
        case .healthCare: return "HC"
        case .defence: return "Def"
        case .police: return "Pol"
        case .corporate: return "Corp"
        case .education: return "Edu"
        case .realEstate: return "RE"
        case .media: return "Med"
        case .it: return "IT"
        case .humanResource: return "HR"
        case .banking: return "Bank"
        case .others: return "Oth"
        case .notApplicable: return "N/A"
        case .other: return "Other"
        case .government: return "Govt"
        }
    }
    public var internationalFormat: String {
        switch self {
        case .ministry: return "MIN"
        case .healthCare: return "HC"
        case .defence: return "DEF"
        case .police: return "POL"
        case .corporate: return "CORP"
        case .education: return "EDU"
        case .realEstate: return "RE"
        case .media: return "MED"
        case .it: return "IT"
        case .humanResource: return "HR"
        case .banking: return "BANK"
        case .others: return "OTH"
        case .notApplicable: return "NA"
        case .other: return "OTHER"
        case .government: return "GOVT"
        }
    }
    public var subcategories: [OccupationSubCategory] {
        switch self {
        case .healthCare:
            return [.doctor, .nurse, .pharmacist, .dentist, .labourer, .others]
        case .education:
            return [.teacher, .principal, .librarian, .others]
        case .it:
            return [.softwareDeveloper, .technician, .engineer, .others]
        case .corporate:
            return [.accountant, .consultant, .banker, .humanResource, .others]
        case .media:
            return [.journalist, .photographer, .designer, .model, .others]
        case .realEstate:
            return [.estateAgent, .others]
        case .ministry:
            return [.pastor, .pastoralCareAsst, .lifeCoaches, .others]
        case .defence:
            return [.soldier, .policeOfficer, .others]
        case .police:
            return [.policeOfficer, .others]
        case .humanResource:
            return [.recruiter, .trainerCoach, .others]
        case .banking:
            return [.banker, .cashier, .others]
        case .others, .notApplicable, .other, .government:
            return OccupationSubCategory.allCases
        }
    }
}

public enum OccupationSubCategory: String, Codable, CaseIterable, Sendable {
    case doctor = "Doctor"
    case architect = "Architect"
    case teacher = "Teacher"
    case dentist = "Dentist"
    case accountant = "Accountant"
    case chef = "Chef"
    case electrician = "Electrician"
    case technician = "Technician"
    case scientist = "Scientist"
    case engineer = "Engineer"
    case artist = "Artist"
    case lawyer = "Lawyer"
    case waitingStaff = "Waiting staff"
    case pharmacist = "Pharmacist"
    case labourer = "Labourer"
    case nurse = "Nurse"
    case gardener = "Gardener"
    case mechanic = "Mechanic"
    case librarian = "Librarian"
    case tailor = "Tailor"
    case mailCarrier = "Mail carrier"
    case policeOfficer = "Police officer"
    case veterinarian = "Veterinarian"
    case designer = "Designer"
    case painterAndDecorator = "Painter and decorator"
    case firefighter = "Firefighter"
    case butcher = "Butcher"
    case aviator = "Aviator"
    case businessperson = "Businessperson"
    case farmer = "Farmer"
    case plumber = "Plumber"
    case secretary = "Secretary"
    case hairdresser = "Hairdresser"
    case journalist = "Journalist"
    case soldier = "Soldier"
    case bakers = "Bakers"
    case lifeguard = "Lifeguard"
    case judge = "Judge"
    case estateAgent = "Estate agent"
    case driver = "Driver"
    case fisherman = "Fisherman"
    case politician = "Politician"
    case cashier = "Cashier"
    case softwareDeveloper = "Software Developer"
    case optician = "Optician"
    case actor = "Actor"
    case consultant = "Consultant"
    case translator = "Translator"
    case model = "Model"
    case photographer = "Photographer"
    case salesperson = "Salesperson"
    case principal = "Principal"
    case lifeCoaches = "Life Coaches"
    case banker = "Banker"
    case trainerCoach = "Trainer/Coach"
    case others = "Others"
    case pastor = "Pastor"
    case pastoralCareAsst = "Pastoral care asst."
    case it = "IT/ITES"
    case education = "Education"
    case humanResource = "Human Resource"
    case healthCare = "Health Care"
    case corporate = "Corporate"
    case ministry = "Ministry"
    case rbDepartment = "R&B Department"
    case electronics = "Electronics"
    case construction = "Construction"
    case na = "NA"
    case realEstate = "Real Estate"
    case homemaker = "Homemaker"
    case police = "Police"
    case recruiter = "Recruiter"
    case retailClothes = "Retail- Clothes"
    case machanic = "Machanic"
    case notApplicable = "Not Applicable"
    case other
    public var displayName: String { self.rawValue }
    public var shortDisplay: String {
        switch self {
        case .doctor: return "Dr"
        case .architect: return "Arch"
        case .teacher: return "Teach"
        case .dentist: return "Dent"
        case .accountant: return "Acct"
        case .chef: return "Chef"
        case .electrician: return "Elec"
        case .technician: return "Tech"
        case .scientist: return "Sci"
        case .engineer: return "Eng"
        case .artist: return "Art"
        case .lawyer: return "Law"
        case .waitingStaff: return "Wait"
        case .pharmacist: return "Pharm"
        case .labourer: return "Lab"
        case .nurse: return "Nurse"
        case .gardener: return "Gard"
        case .mechanic: return "Mech"
        case .librarian: return "Lib"
        case .tailor: return "Tail"
        case .mailCarrier: return "Mail"
        case .policeOfficer: return "Police"
        case .veterinarian: return "Vet"
        case .designer: return "Des"
        case .painterAndDecorator: return "Paint"
        case .firefighter: return "Fire"
        case .butcher: return "Butch"
        case .aviator: return "Av"
        case .businessperson: return "Biz"
        case .farmer: return "Farm"
        case .plumber: return "Plumb"
        case .secretary: return "Sec"
        case .hairdresser: return "Hair"
        case .journalist: return "Jour"
        case .soldier: return "Sold"
        case .bakers: return "Bake"
        case .lifeguard: return "LGuard"
        case .judge: return "Judge"
        case .estateAgent: return "EstAgt"
        case .driver: return "Drv"
        case .fisherman: return "Fish"
        case .politician: return "Pol"
        case .cashier: return "Cash"
        case .softwareDeveloper: return "Dev"
        case .optician: return "Opt"
        case .actor: return "Act"
        case .consultant: return "Cons"
        case .translator: return "Trans"
        case .model: return "Mod"
        case .photographer: return "Photo"
        case .salesperson: return "Sales"
        case .principal: return "Prin"
        case .lifeCoaches: return "Coach"
        case .banker: return "Bank"
        case .trainerCoach: return "TCoach"
        case .others: return "Oth"
        case .pastor: return "Past"
        case .pastoralCareAsst: return "PCA"
        case .it: return "IT"
        case .education: return "Edu"
        case .humanResource: return "HR"
        case .healthCare: return "HC"
        case .corporate: return "Corp"
        case .ministry: return "Min"
        case .rbDepartment: return "R&B"
        case .electronics: return "Elec"
        case .construction: return "Constr"
        case .na: return "NA"
        case .realEstate: return "RE"
        case .homemaker: return "Home"
        case .police: return "Pol"
        case .recruiter: return "Rec"
        case .retailClothes: return "Retail"
        case .machanic: return "Mech"
        case .notApplicable: return "N/A"
        case .other: return "Other"
        }
    }
    public var internationalFormat: String {
        switch self {
        case .doctor: return "DR"
        case .architect: return "ARCH"
        case .teacher: return "TEACH"
        case .dentist: return "DENT"
        case .accountant: return "ACCT"
        case .chef: return "CHEF"
        case .electrician: return "ELEC"
        case .technician: return "TECH"
        case .scientist: return "SCI"
        case .engineer: return "ENG"
        case .artist: return "ART"
        case .lawyer: return "LAW"
        case .waitingStaff: return "WAIT"
        case .pharmacist: return "PHARM"
        case .labourer: return "LAB"
        case .nurse: return "NURSE"
        case .gardener: return "GARD"
        case .mechanic: return "MECH"
        case .librarian: return "LIB"
        case .tailor: return "TAIL"
        case .mailCarrier: return "MAIL"
        case .policeOfficer: return "POLICE"
        case .veterinarian: return "VET"
        case .designer: return "DES"
        case .painterAndDecorator: return "PAINT"
        case .firefighter: return "FIRE"
        case .butcher: return "BUTCH"
        case .aviator: return "AV"
        case .businessperson: return "BIZ"
        case .farmer: return "FARM"
        case .plumber: return "PLUMB"
        case .secretary: return "SEC"
        case .hairdresser: return "HAIR"
        case .journalist: return "JOUR"
        case .soldier: return "SOLD"
        case .bakers: return "BAKE"
        case .lifeguard: return "LGRD"
        case .judge: return "JUDGE"
        case .estateAgent: return "ESTAGT"
        case .driver: return "DRV"
        case .fisherman: return "FISH"
        case .politician: return "POL"
        case .cashier: return "CASH"
        case .softwareDeveloper: return "DEV"
        case .optician: return "OPT"
        case .actor: return "ACT"
        case .consultant: return "CONS"
        case .translator: return "TRANS"
        case .model: return "MOD"
        case .photographer: return "PHOTO"
        case .salesperson: return "SALES"
        case .principal: return "PRIN"
        case .lifeCoaches: return "COACH"
        case .banker: return "BANK"
        case .trainerCoach: return "TCOACH"
        case .others: return "OTH"
        case .pastor: return "PAST"
        case .pastoralCareAsst: return "PCA"
        case .it: return "IT"
        case .education: return "EDU"
        case .humanResource: return "HR"
        case .healthCare: return "HC"
        case .corporate: return "CORP"
        case .ministry: return "MIN"
        case .rbDepartment: return "R&B"
        case .electronics: return "ELEC"
        case .construction: return "CONSTR"
        case .na: return "NA"
        case .realEstate: return "RE"
        case .homemaker: return "HOME"
        case .police: return "POL"
        case .recruiter: return "REC"
        case .retailClothes: return "RETAIL"
        case .machanic: return "MECH"
        case .notApplicable: return "NA"
        case .other: return "OTHER"
        }
    }
}
