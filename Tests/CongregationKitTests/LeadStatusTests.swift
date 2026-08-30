import Congregation
import Testing

@Suite("LeadStatus Path")
struct LeadStatusTests {
    @Test("parses Salesforce Path labels and API names")
    func parsesLabels() {
        #expect(LeadStatus.parse("Follow-up") == .followUp)
        #expect(LeadStatus.parse("1st Follow up") == .followUp)
        #expect(LeadStatus.parse("2nd Follow up") == .secondFollowUp)
        #expect(LeadStatus.parse("") == .unknown)
    }

    @Test("Path keeps a label on every completed stage")
    func pathLabels() {
        let steps = LeadStatus.path(current: .secondFollowUp)
        #expect(
            steps.map(\.label) == [
                "Attempted", "1st Follow up", "2nd Follow up", "3rd Follow up",
                "4th Follow up", "Repeated", "Lost", "Converted",
            ])
        #expect(steps[0].state == .completed)
        #expect(steps[1].state == .completed)
        #expect(steps[1].label == "1st Follow up")
        #expect(steps[2].state == .current)
        #expect(steps[2].label == "2nd Follow up")
        #expect(steps[3].state == .upcoming)
    }

    @Test("Mark complete advances to the next Path stage")
    func nextOnPath() {
        #expect(LeadStatus.followUp.nextOnPath == .secondFollowUp)
        #expect(LeadStatus.secondFollowUp.nextOnPath == .thirdFollowUp)
        #expect(LeadStatus.lost.nextOnPath == .converted)
        #expect(LeadStatus.converted.nextOnPath == nil)
    }
}
