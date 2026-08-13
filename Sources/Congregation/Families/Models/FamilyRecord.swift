import Foundation

/// A person/dependent row from Salesforce `Family_Information__c` (v2 `/families`).
///
/// ## Overview
///
/// This is **not** a household graph and **not** an RFID card. It is a named person
/// linked optionally to a member, seeker, attendee, or SPM.
///
/// ``cardIssued`` is a Salesforce boolean snapshot (“has a card been issued?”). It
/// does not include tag number, status, or lifecycle. Use ``RFID`` and ``RFIDsHandler``
/// for full card identity and lifecycle in the Congregation domain. Use ``Family`` /
/// ``FamilyTree`` for household relationships.
///
/// ## Example Usage
///
/// ```swift
/// let record = try await congregation.familyRecords.fetch(id: familyId, query: nil)
/// if record.cardIssued == true { /* Salesforce reports a card was issued */ }
/// ```
public struct FamilyRecord: Decodable, Identifiable, Sendable, SyncMetadataRepresentable {
    public let id: String?
    public let sync: SyncMetadata?
    public let displayName: String?
    public let memberId: MemberID?
    public let seekerId: SeekerID?
    public let attendeeId: String?
    public let spmId: String?
    public let dateOfBirth: Date?
    public let age: String?
    public let profession: String?
    public let cardIssued: Bool?

    public init(
        id: String? = nil,
        sync: SyncMetadata? = nil,
        displayName: String? = nil,
        memberId: MemberID? = nil,
        seekerId: SeekerID? = nil,
        attendeeId: String? = nil,
        spmId: String? = nil,
        dateOfBirth: Date? = nil,
        age: String? = nil,
        profession: String? = nil,
        cardIssued: Bool? = nil
    ) {
        self.id = id
        self.sync = sync
        self.displayName = displayName
        self.memberId = memberId
        self.seekerId = seekerId
        self.attendeeId = attendeeId
        self.spmId = spmId
        self.dateOfBirth = dateOfBirth
        self.age = age
        self.profession = profession
        self.cardIssued = cardIssued
    }

    enum CodingKeys: String, CodingKey {
        case id, memberId, seekerId, attendeeId, spmId, dateOfBirth, age, profession, cardIssued
        case displayName = "name"
        case etag, createTime, updateTime
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        memberId = (try container.decodeIfPresent(String.self, forKey: .memberId)).flatMap(MemberID.init(rawValue:))
        seekerId = (try container.decodeIfPresent(String.self, forKey: .seekerId)).flatMap(SeekerID.init(rawValue:))
        attendeeId = try container.decodeIfPresent(String.self, forKey: .attendeeId)
        spmId = try container.decodeIfPresent(String.self, forKey: .spmId)
        dateOfBirth = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .dateOfBirth))
        age = try container.decodeIfPresent(String.self, forKey: .age)
        profession = try container.decodeIfPresent(String.self, forKey: .profession)
        cardIssued = try container.decodeIfPresent(Bool.self, forKey: .cardIssued)
        sync = SyncMetadata(
            name: nil,
            etag: try container.decodeIfPresent(String.self, forKey: .etag),
            createTime: SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .createTime)),
            updateTime: SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .updateTime))
        )
    }
}
