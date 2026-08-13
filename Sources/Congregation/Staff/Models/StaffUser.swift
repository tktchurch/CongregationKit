import Foundation

/// Church ops staff grouping on Salesforce `User.Group__c`.
public enum StaffUserGroup: String, Codable, Sendable, CaseIterable {
    case teen = "Teen"
    case adult = "Adult"
    case unknown

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).trimmingCharacters(in: .whitespacesAndNewlines)
        self = StaffUserGroup(rawValue: value) ?? .unknown
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self == .unknown ? "" : rawValue)
    }
}

/// Church operations staff from Salesforce `User` — **not** a congregation member.
///
/// ## Overview
///
/// Ops staff own follow-up tasks, appear in `/v2/users`, and authenticate to Salesforce.
/// Use ``StaffUser`` for callers/coordinators; use ``Member`` for congregation people.
///
/// ## Example Usage
///
/// ```swift
/// let me = try await congregation.users.fetchMe()
/// print(me.username ?? "", me.group ?? "")
/// ```
public struct StaffUser: Decodable, Identifiable, Sendable, SyncMetadataRepresentable {
    public let id: String?
    public let sync: SyncMetadata?
    public let username: String?
    public let email: String?
    public let isActive: Bool?
    public let group: StaffUserGroup?
    public let profileName: String?
    public let userRoleName: String?
    public let phone: String?
    public let title: String?
    public let department: String?

    public init(
        id: String? = nil,
        sync: SyncMetadata? = nil,
        username: String? = nil,
        email: String? = nil,
        isActive: Bool? = nil,
        group: StaffUserGroup? = nil,
        profileName: String? = nil,
        userRoleName: String? = nil,
        phone: String? = nil,
        title: String? = nil,
        department: String? = nil
    ) {
        self.id = id
        self.sync = sync
        self.username = username
        self.email = email
        self.isActive = isActive
        self.group = group
        self.profileName = profileName
        self.userRoleName = userRoleName
        self.phone = phone
        self.title = title
        self.department = department
    }

    enum CodingKeys: String, CodingKey {
        case id, username, email, isActive, group, profileName, userRoleName, phone, title, department
        case name, etag, createTime, updateTime
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)
        group = try container.decodeIfPresent(StaffUserGroup.self, forKey: .group)
        profileName = try container.decodeIfPresent(String.self, forKey: .profileName)
        userRoleName = try container.decodeIfPresent(String.self, forKey: .userRoleName)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        department = try container.decodeIfPresent(String.self, forKey: .department)
        sync = SyncMetadata(
            name: try container.decodeIfPresent(String.self, forKey: .name),
            etag: try container.decodeIfPresent(String.self, forKey: .etag),
            createTime: SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .createTime)),
            updateTime: SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .updateTime))
        )
    }
}
