import DIGIPIN
import Foundation

/// Errors thrown when validating or encoding Care Group identifiers and DIGIPIN codes.
public enum CareGroupError: Error, Equatable, Sendable {
    /// The string does not match the `CG-[DIST]-[AREA]-[SEQ]` format.
    case invalidCareGroupID(String)
    /// The string is not a valid 10-character India Post DIGIPIN code.
    case invalidDIGIPIN(String)
    /// The coordinate falls outside the supported DIGIPIN bounding box.
    case coordinateOutOfBounds(latitude: Double, longitude: Double)
}

/// A strongly-typed Care Group identifier following `CG-[DIST]-[AREA]-[SEQ]`.
///
/// Care Group IDs identify a pastoral group independently of its current coordinator
/// or host home, similar to a classroom number.
///
/// Example: `CG-WST-MDP-001`.
public struct CareGroupID: RawRepresentable, Codable, Hashable, Sendable, CustomStringConvertible {
    /// The canonical uppercase identifier (e.g. `CG-WST-MDP-001`).
    public let rawValue: String

    /// The 3-letter district code segment (`[DIST]`).
    public var districtCode: String {
        String(rawValue.split(separator: "-")[1])
    }

    /// The 3-letter area code segment (`[AREA]`).
    public var areaCode: String {
        String(rawValue.split(separator: "-")[2])
    }

    /// The 3-digit sequence segment (`[SEQ]`), e.g. `1` for `001`.
    public var sequenceNumber: Int {
        Int(rawValue.split(separator: "-")[3]) ?? 0
    }

    public var description: String { rawValue }

    /// Creates a `CareGroupID` from a raw string, returning `nil` if invalid.
    public init?(rawValue: String) {
        let normalized = rawValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let parts = normalized.split(separator: "-", omittingEmptySubsequences: false)
        guard parts.count == 4,
            parts[0] == "CG",
            parts[1].count == 3, parts[1].allSatisfy({ $0.isASCII && $0.isUppercase }),
            parts[2].count == 3, parts[2].allSatisfy({ $0.isASCII && $0.isUppercase }),
            parts[3].count == 3, parts[3].allSatisfy({ $0.isASCII && $0.isNumber }),
            let seq = Int(parts[3]), seq >= 1
        else {
            return nil
        }
        self.rawValue = normalized
    }

    /// Creates a validated `CareGroupID`, throwing ``CareGroupError/invalidCareGroupID(_:)`` if invalid.
    public init(validating value: String) throws {
        guard let parsed = CareGroupID(rawValue: value) else {
            throw CareGroupError.invalidCareGroupID(value)
        }
        self = parsed
    }

    /// Composes a `CareGroupID` from district code, area code, and sequence number (`1...999`).
    public init(districtCode: String, areaCode: String, sequence: Int) throws {
        let dist = districtCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let area = areaCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard (1...999).contains(sequence) else {
            throw CareGroupError.invalidCareGroupID("CG-\(dist)-\(area)-\(sequence)")
        }
        let formattedSeq = String(format: "%03d", sequence)
        try self.init(validating: "CG-\(dist)-\(area)-\(formattedSeq)")
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        try self.init(validating: raw)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

/// A validated, canonical 10-character India Post DIGIPIN code backed by `vamsii777/DIGIPIN` v3.0.0.
///
/// Follows the May 2026 India Post DIGIPIN Standard v2.0.0:
/// - **Storage / API format (`rawValue`):** continuous 10 uppercase characters (e.g. `39J49LL8T4`).
/// - **Display format (`displayFormatted`):** `3-4-3` space grouping (e.g. `39J 49LL 8T4`).
/// - **Proximity prefix (`neighborhoodPrefix`):** first 6 characters (~1 km × 1 km grid cell).
public struct DIGIPINCode: RawRepresentable, Codable, Hashable, Sendable, CustomStringConvertible {
    /// Canonical 10-character uppercase DIGIPIN without hyphens or spaces.
    public let rawValue: String

    public var description: String { rawValue }

    /// Official May 2026 `3-4-3` space-grouped display string (e.g. `39J 49LL 8T4`).
    public var displayFormatted: String {
        (try? DIGIPIN.formatForDisplay(rawValue)) ?? rawValue
    }

    /// First 6 characters representing an approximately 1 km × 1 km neighborhood cell.
    public var neighborhoodPrefix: String {
        String(rawValue.prefix(6))
    }

    /// Creates a `DIGIPINCode` from a strict canonical 10-character DIGIPIN string.
    public init?(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard DIGIPIN.isValid(trimmed) else { return nil }
        self.rawValue = trimmed
    }

    /// Normalizes a canonical, space-grouped (`3-4-3`), or legacy hyphenated (`3-3-4`) DIGIPIN string.
    public init(normalizing value: String) throws {
        do {
            let canonical = try DIGIPIN.normalize(value)
            guard DIGIPIN.isValid(canonical) else {
                throw CareGroupError.invalidDIGIPIN(value)
            }
            self.rawValue = canonical
        } catch {
            throw CareGroupError.invalidDIGIPIN(value)
        }
    }

    /// Encodes a latitude/longitude pair offline into a canonical `DIGIPINCode`.
    public static func encode(latitude: Double, longitude: Double) throws -> DIGIPINCode {
        let engine = DIGIPIN()
        do {
            let code = try engine.generateDIGIPIN(for: Coordinate(latitude: latitude, longitude: longitude))
            guard let wrapped = DIGIPINCode(rawValue: code) else {
                throw CareGroupError.invalidDIGIPIN(code)
            }
            return wrapped
        } catch let err as CareGroupError {
            throw err
        } catch {
            throw CareGroupError.coordinateOutOfBounds(latitude: latitude, longitude: longitude)
        }
    }

    /// Decodes this DIGIPIN offline into its center latitude and longitude.
    public func decode() throws -> (latitude: Double, longitude: Double) {
        let engine = DIGIPIN()
        do {
            let coord = try engine.coordinate(from: rawValue)
            return (coord.latitude, coord.longitude)
        } catch {
            throw CareGroupError.invalidDIGIPIN(rawValue)
        }
    }

    /// Computes the geodesic distance in kilometers to another `DIGIPINCode` offline.
    public func distanceKilometers(to other: DIGIPINCode) throws -> Double {
        let engine = DIGIPIN()
        do {
            return try engine.distance(from: rawValue, to: other.rawValue)
        } catch {
            throw CareGroupError.invalidDIGIPIN(rawValue)
        }
    }

    /// Computes the geodesic distance in meters to another `DIGIPINCode` offline.
    public func distanceMeters(to other: DIGIPINCode) throws -> Double {
        try distanceKilometers(to: other) * 1000.0
    }

    /// Direct Google Maps URL for doorstep navigation to the decoded center coordinate.
    public var googleMapsURL: URL? {
        guard let coord = try? decode() else { return nil }
        return URL(string: "https://www.google.com/maps/search/?api=1&query=\(coord.latitude),\(coord.longitude)")
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        try self.init(normalizing: raw)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

/// Compile-time-safe XOR participant reference for Care Group rosters.
///
/// A participant is either a registered church ``MemberID`` or a Seeker identifier, never both.
public enum ParticipantReference: Codable, Hashable, Sendable {
    case member(MemberID)
    case seeker(String)

    private enum CodingKeys: String, CodingKey {
        case participantType
        case memberId
        case seekerId
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .participantType)
        switch type {
        case "member":
            let memberId = try container.decode(MemberID.self, forKey: .memberId)
            self = .member(memberId)
        case "seeker":
            let seekerId = try container.decode(String.self, forKey: .seekerId)
            self = .seeker(seekerId)
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .participantType,
                in: container,
                debugDescription: "Unknown participantType '\(type)'"
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .member(let memberId):
            try container.encode("member", forKey: .participantType)
            try container.encode(memberId, forKey: .memberId)
        case .seeker(let seekerId):
            try container.encode("seeker", forKey: .participantType)
            try container.encode(seekerId, forKey: .seekerId)
        }
    }
}
