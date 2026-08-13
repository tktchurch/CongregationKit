import Foundation

/// Spiritual discipleship Q&A row from `Spiritual_Information__c`.
public struct SpiritualRecord: Decodable, Identifiable, Sendable, SyncMetadataRepresentable {
    public let id: String?
    public let sync: SyncMetadata?
    public let displayName: String?
    public let memberId: MemberID?
    public let seekerId: SeekerID?
    public let attendeeId: String?
    public let spmId: String?
    public let question: String?
    public let answer: String?
    public let date: Date?

    public init(
        id: String? = nil,
        sync: SyncMetadata? = nil,
        displayName: String? = nil,
        memberId: MemberID? = nil,
        seekerId: SeekerID? = nil,
        attendeeId: String? = nil,
        spmId: String? = nil,
        question: String? = nil,
        answer: String? = nil,
        date: Date? = nil
    ) {
        self.id = id
        self.sync = sync
        self.displayName = displayName
        self.memberId = memberId
        self.seekerId = seekerId
        self.attendeeId = attendeeId
        self.spmId = spmId
        self.question = question
        self.answer = answer
        self.date = date
    }

    enum CodingKeys: String, CodingKey {
        case id, memberId, seekerId, attendeeId, spmId, question, answer, date
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
        question = try container.decodeIfPresent(String.self, forKey: .question)
        answer = try container.decodeIfPresent(String.self, forKey: .answer)
        date = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .date))
        sync = SyncMetadata(
            name: nil,
            etag: try container.decodeIfPresent(String.self, forKey: .etag),
            createTime: SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .createTime)),
            updateTime: SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .updateTime))
        )
    }
}
