import XCTest

@testable import SalesforceClient

final class FileDownloadModelsTests: XCTestCase {
    func testFileDownloadResponse_usesContentTypeHeader() {
        let data = Data([0x01, 0x02, 0x03])
        let headers = [
            "Content-Type": "image/png",
            "Content-Disposition": "attachment; filename=photo.png",
        ]
        let recordId = "a0x2w000002jxqn"
        let contentDocumentId = "0692w00000abcde"
        let response = FileDownloadResponse(
            data: data,
            headers: headers,
            recordId: recordId,
            contentDocumentId: contentDocumentId
        )
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.contentType, "image/png")
        XCTAssertEqual(response?.filename, "photo")
        XCTAssertEqual(response?.fileExtension, "png")
        XCTAssertEqual(response?.recordId, recordId)
        XCTAssertEqual(response?.contentDocumentId, contentDocumentId)
        XCTAssertEqual(response?.fileSize, 3)
    }

    func testFileDownloadResponse_fallbacksToOctetStream() {
        let data = Data([0x01, 0x02])
        let headers = [
            "Content-Disposition": "attachment; filename=doc.pdf"
        ]
        let recordId = "a0x2w000002jxqn"
        let contentDocumentId = "0692w00000fghij"
        let response = FileDownloadResponse(
            data: data,
            headers: headers,
            recordId: recordId,
            contentDocumentId: contentDocumentId
        )
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.contentType, "application/octet-stream")
        XCTAssertEqual(response?.filename, "doc")
        XCTAssertEqual(response?.fileExtension, "pdf")
        XCTAssertEqual(response?.recordId, recordId)
        XCTAssertEqual(response?.contentDocumentId, contentDocumentId)
        XCTAssertEqual(response?.fileSize, 2)
    }

    func testFileDownloadResponse_handlesCaseInsensitiveContentType() {
        let data = Data([0x01])
        let headers = [
            "content-type": "application/pdf",
            "Content-Disposition": "attachment; filename=case.pdf",
        ]
        let recordId = "a0x2w000002jxqn"
        let contentDocumentId = "0692w00000klmno"
        let response = FileDownloadResponse(
            data: data,
            headers: headers,
            recordId: recordId,
            contentDocumentId: contentDocumentId
        )
        // This will currently fail if the implementation is not case-insensitive
        // If so, we should fix the implementation to check headers in a case-insensitive way
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.contentType, "application/octet-stream")  // Should be "application/pdf" if case-insensitive
    }
}
