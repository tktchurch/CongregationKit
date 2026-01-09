import Foundation

/// Request model for creating a new seeker in Salesforce.
///
/// This model is used internally to format the request payload for the Salesforce API.
/// The public API accepts a `Seeker` object which is transformed into this request format.
public struct SeekerCreateRequest: Codable, Sendable {
    let typeOfEntry: String
    let name: String
    let contactNumberMobile: String
    let age: String
    let preferredLanguage: String
    let maritalStatus: String
    let presentResidingArea: String
    let comments: String?
    let attendedCampus: String?
    let emailId: String?

    enum CodingKeys: String, CodingKey {
        case typeOfEntry
        case name
        case contactNumberMobile = "phoneNumber"
        case age
        case preferredLanguage
        case maritalStatus
        case presentResidingArea
        case comments
        case attendedCampus
        case emailId
    }

    /// Creates a SeekerCreateRequest from a Seeker instance.
    ///
    /// - Parameter seeker: The seeker to create a request from
    /// - Throws: SeekerError if required fields are missing or invalid
    public init(from seeker: Seeker) throws {
        guard let typeOfEntry = seeker.typeOfEntry?.rawValue else {
            throw SeekerError.invalidSeekerData
        }
        guard let name = seeker.fullName else {
            throw SeekerError.invalidSeekerData
        }
        guard let phoneNumber = seeker.phone else {
            throw SeekerError.invalidSeekerData
        }

        guard let preferredLanguage = seeker.preferredLanguage?.rawValue else {
            throw SeekerError.invalidSeekerData
        }

        guard let maritalStatusEnum = seeker.maritalStatus else {
            throw SeekerError.invalidSeekerData
        }

        // Validate marital status for Salesforce seeker picklist
        // Valid values: Married, Separated, Widowed, Unmarried, Engaged
        guard maritalStatusEnum.isValidForSeeker else {
            throw SeekerError.invalidMaritalStatus(maritalStatusEnum.rawValue)
        }

        let maritalStatus = maritalStatusEnum.rawValue

        // Convert age from Int or ageGroup string
        let ageString: String
        if let age = seeker.age {
            ageString = String(age)
        } else if let ageGroup = seeker.ageGroup {
            ageString = ageGroup
        } else {
            throw SeekerError.invalidSeekerData
        }

        self.typeOfEntry = typeOfEntry
        self.name = name
        self.contactNumberMobile = phoneNumber
        self.age = ageString
        self.preferredLanguage = preferredLanguage
        self.maritalStatus = maritalStatus
        self.presentResidingArea = seeker.area ?? ""
        self.comments = nil
        self.attendedCampus = nil
        self.emailId = seeker.email
    }
}

/// Response model for seeker creation from Salesforce.
///
/// This is the raw response from the Salesforce API which gets transformed
/// into a SeekerResponse with a Seeker object.
public struct SeekerCreateResponse: Codable, Sendable {
    let success: Bool
    let message: String
    let seeker: SeekerCreateDTO?

    /// Transforms this response into a SeekerResponse with a full Seeker object.
    public func toSeekerResponse() -> SeekerResponse {
        if success, let dto = seeker {
            let dateFormatter = ISO8601DateFormatter()
            let createdDate = dto.createdDate != nil ? dateFormatter.date(from: dto.createdDate!) : nil
            
            let typeOfEntry = dto.typeOfEntry != nil ? TypeOfEntry(rawValue: dto.typeOfEntry!) : nil
            
            // Handle lead creation - only create lead if we have meaningful data
            let lead: Lead?
            if dto.leadId != nil || dto.leadStatus != nil {
                lead = Lead(id: dto.leadId, status: dto.leadStatus)
            } else {
                lead = nil
            }
            
            // Use nameLocal if available, fallback to name
            let fullName = dto.nameLocal ?? dto.name
            
            let seeker = Seeker(
                id: dto.id,
                lead: lead,
                fullName: fullName,
                email: dto.emailId,
                phone: dto.phoneNumber,
                dateOfBirth: nil,
                ageGroup: dto.age,
                area: dto.presentResidingArea,
                typeOfEntry: typeOfEntry,
                maritalStatus: dto.maritalStatus,
                preferredLanguage: dto.preferredLanguage,
                createdDate: createdDate
            )
            return SeekerResponse(seekers: [seeker])
        } else {
            return SeekerResponse(errorMessage: message)
        }
    }
}

public struct SeekerCreateDTO: Codable, Sendable {
    public let id: String
    public let seekerId: String?
    public let leadId: String?
    public let name: String?  // Added name field from Salesforce response
    public let nameLocal: String?
    public let phoneNumber: String?
    public let age: String?  // note: String, not Int
    public let preferredLanguage: PreferredLanguage?
    public let maritalStatus: MaritalStatus?
    public let presentResidingArea: String?
    public let comments: String?
    public let attendedCampus: Campus?
    public let emailId: String?
    public let leadStatus: LeadStatus?
    public let createdDate: String?
    public let typeOfEntry: String?
}
