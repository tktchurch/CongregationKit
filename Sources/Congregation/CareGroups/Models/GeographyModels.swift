import Foundation

/// A top-level pastoral district (e.g. one of the 7 city districts).
public struct District: Codable, Hashable, Sendable, Identifiable {
    public let id: String
    /// Reporting code (e.g. `D1`–`D7`, `OUT`).
    public let code: String
    /// 3-letter Care Group ID code segment (e.g. `WST`, `CNT`).
    public let shortCode: String
    public let name: String
    public let city: String
    public let isActive: Bool

    public init(
        id: String,
        code: String,
        shortCode: String,
        name: String,
        city: String = "",
        isActive: Bool = true
    ) {
        self.id = id
        self.code = code
        self.shortCode = shortCode
        self.name = name
        self.city = city
        self.isActive = isActive
    }
}

/// A normalized neighborhood/locality belonging to a ``District``.
public struct Area: Codable, Hashable, Sendable, Identifiable {
    public let id: String
    public let districtId: String
    /// 3-letter Care Group ID code segment (e.g. `MDP`, `GCB`).
    public let code: String
    public let name: String
    public let pincode: String?
    public let digipinPrefix: String?
    public let isActive: Bool

    public init(
        id: String,
        districtId: String,
        code: String,
        name: String,
        pincode: String? = nil,
        digipinPrefix: String? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.districtId = districtId
        self.code = code
        self.name = name
        self.pincode = pincode
        self.digipinPrefix = digipinPrefix
        self.isActive = isActive
    }
}

/// An effective-dated Area Leader assignment overseeing all Care Groups in an ``Area``.
public struct AreaLeader: Codable, Hashable, Sendable, Identifiable {
    public let id: String
    public let areaId: String
    public let memberId: MemberID
    public let isPrimary: Bool
    public let startDate: Date
    public let endDate: Date?

    public init(
        id: String,
        areaId: String,
        memberId: MemberID,
        isPrimary: Bool = true,
        startDate: Date,
        endDate: Date? = nil
    ) {
        self.id = id
        self.areaId = areaId
        self.memberId = memberId
        self.isPrimary = isPrimary
        self.startDate = startDate
        self.endDate = endDate
    }
}

/// A physical church venue where members attend services, independent of residential district.
public struct CampusVenue: Codable, Hashable, Sendable, Identifiable {
    public let id: String
    public let code: String
    public let name: String
    public let address: String?
    public let digipin: DIGIPINCode?
    public let isActive: Bool

    public init(
        id: String,
        code: String,
        name: String,
        address: String? = nil,
        digipin: DIGIPINCode? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.code = code
        self.name = name
        self.address = address
        self.digipin = digipin
        self.isActive = isActive
    }
}

/// A standardized church service option independent of residential district.
public struct ChurchService: Codable, Hashable, Sendable, Identifiable {
    public let id: String
    public let code: String
    public let name: String
    public let serviceCategory: String
    public let campusId: String?
    public let isActive: Bool

    public init(
        id: String,
        code: String,
        name: String,
        serviceCategory: String,
        campusId: String? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.code = code
        self.name = name
        self.serviceCategory = serviceCategory
        self.campusId = campusId
        self.isActive = isActive
    }
}
