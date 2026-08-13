import Foundation

/// A course enrollment/completion record linked to a member, attendee, or SPM.
public struct Course: Decodable, Identifiable, Sendable, SyncMetadataRepresentable {
    public let id: String?
    public let sync: SyncMetadata?
    public let name: String?
    public let startDate: Date?
    public let endDate: Date?
    public let score: Double?
    public let memberId: MemberID?
    public let attendeeId: String?
    public let spmId: String?
    public let description: String?

    public init(
        id: String? = nil,
        sync: SyncMetadata? = nil,
        name: String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        score: Double? = nil,
        memberId: MemberID? = nil,
        attendeeId: String? = nil,
        spmId: String? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.sync = sync
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.score = score
        self.memberId = memberId
        self.attendeeId = attendeeId
        self.spmId = spmId
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case id, name, startDate, endDate, score, memberId, attendeeId, spmId, description
        case etag, createTime, updateTime
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        startDate = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .startDate))
        endDate = SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .endDate))
        score = try container.decodeIfPresent(Double.self, forKey: .score)
        memberId = (try container.decodeIfPresent(String.self, forKey: .memberId)).flatMap(MemberID.init(rawValue:))
        attendeeId = try container.decodeIfPresent(String.self, forKey: .attendeeId)
        spmId = try container.decodeIfPresent(String.self, forKey: .spmId)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        sync = SyncMetadata(
            name: nil,
            etag: try container.decodeIfPresent(String.self, forKey: .etag),
            createTime: SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .createTime)),
            updateTime: SyncDateCoding.decode(from: try container.decodeIfPresent(String.self, forKey: .updateTime))
        )
    }
}
