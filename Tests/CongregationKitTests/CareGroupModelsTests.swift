import Foundation
import Testing

@testable import Congregation

@Suite("Care Group & DIGIPIN Models")
struct CareGroupModelsTests {
    @Test("CareGroupID validates, normalizes, and exposes components")
    func careGroupIDValidation() throws {
        let parsed = try CareGroupID(validating: " cg-wst-mdp-001 ")
        #expect(parsed.rawValue == "CG-WST-MDP-001")
        #expect(parsed.districtCode == "WST")
        #expect(parsed.areaCode == "MDP")
        #expect(parsed.sequenceNumber == 1)

        let composed = try CareGroupID(districtCode: "cnt", areaCode: "jbh", sequence: 42)
        #expect(composed.rawValue == "CG-CNT-JBH-042")

        #expect(CareGroupID(rawValue: "CG-WST-MDP-000") == nil)
        #expect(CareGroupID(rawValue: "CG-D5-MDP-001") == nil)
        #expect(CareGroupID(rawValue: "MDP-001") == nil)
    }

    @Test("DIGIPINCode encodes, decodes, formats 3-4-3, and normalizes legacy hyphens")
    func digipinRoundTrip() throws {
        let code = try DIGIPINCode.encode(latitude: 17.4486, longitude: 78.3908)
        #expect(code.rawValue.count == 10)
        #expect(!code.rawValue.contains("-"))
        #expect(code.neighborhoodPrefix.count == 6)
        #expect(code.displayFormatted.split(separator: " ").count == 3)

        let decoded = try code.decode()
        #expect(abs(decoded.latitude - 17.4486) < 0.001)
        #expect(abs(decoded.longitude - 78.3908) < 0.001)

        let legacyNormalized = try DIGIPINCode(normalizing: "39J-49L-L8T4")
        #expect(legacyNormalized.rawValue == "39J49LL8T4")
        #expect(legacyNormalized.displayFormatted == "39J 49LL 8T4")

        let other = try DIGIPINCode.encode(latitude: 17.4500, longitude: 78.3910)
        let meters = try code.distanceMeters(to: other)
        #expect(meters > 100 && meters < 300)
    }

    @Test("ParticipantReference round-trips member and seeker XOR payloads")
    func participantReferenceCodable() throws {
        let memberID = try #require(MemberID(rawValue: "TKT000123"))
        let memberRef = ParticipantReference.member(memberID)
        let encodedMember = try JSONEncoder().encode(memberRef)
        let decodedMember = try JSONDecoder().decode(ParticipantReference.self, from: encodedMember)
        #expect(decodedMember == memberRef)

        let seekerRef = ParticipantReference.seeker("SKR00042")
        let encodedSeeker = try JSONEncoder().encode(seekerRef)
        let decodedSeeker = try JSONDecoder().decode(ParticipantReference.self, from: encodedSeeker)
        #expect(decodedSeeker == seekerRef)
    }

    @Test("CareGroup, Area, and District models round-trip cleanly")
    func careGroupCodableRoundTrip() throws {
        let cgId = try CareGroupID(validating: "CG-WST-MDP-001")
        let digipin = try DIGIPINCode.encode(latitude: 17.4486, longitude: 78.3908)
        let group = CareGroup(
            id: "cg_1",
            careGroupCode: cgId,
            name: "Madhapur Fellowship",
            areaId: "madhapur",
            districtCode: "D5",
            hostDigipin: digipin,
            status: .active,
            meetingDay: "Wednesday",
            meetingTime: "19:30",
            preferredLanguage: "English"
        )
        let data = try JSONEncoder().encode(group)
        let decoded = try JSONDecoder().decode(CareGroup.self, from: data)
        #expect(decoded == group)
    }
}
