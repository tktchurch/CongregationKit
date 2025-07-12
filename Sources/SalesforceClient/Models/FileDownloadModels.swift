import Foundation

/// A response wrapper for file download data from Salesforce.
///
/// Contains the file data, metadata, and content information for downloaded files.
/// This struct encapsulates all the information needed to handle file downloads
/// from Salesforce's ContentDocument system.
public struct FileDownloadResponse: Codable, Sendable {
    /// The binary file data
    public let data: Data
    /// The filename of the downloaded file
    public let filename: String
    /// The file extension
    public let fileExtension: String
    /// The MIME content type of the file
    public let contentType: String
    /// The size of the file in bytes
    public let fileSize: Int
    /// The record ID that was used to download the file
    public let recordId: String
    /// The ContentDocument ID from Salesforce
    public let contentDocumentId: String

    /// Creates a new FileDownloadResponse instance
    /// - Parameters:
    ///   - data: The binary file data
    ///   - filename: The filename of the downloaded file
    ///   - fileExtension: The file extension
    ///   - contentType: The MIME content type of the file
    ///   - fileSize: The size of the file in bytes
    ///   - recordId: The record ID that was used to download the file
    ///   - contentDocumentId: The ContentDocument ID from Salesforce
    public init(
        data: Data,
        filename: String,
        fileExtension: String,
        contentType: String,
        fileSize: Int,
        recordId: String,
        contentDocumentId: String
    ) {
        self.data = data
        self.filename = filename
        self.fileExtension = fileExtension
        self.contentType = contentType
        self.fileSize = fileSize
        self.recordId = recordId
        self.contentDocumentId = contentDocumentId
    }

    /// The full filename with extension
    public var fullFilename: String {
        return "\(filename).\(fileExtension)"
    }

    /// Convenience initializer for creating from HTTP response
    /// - Parameters:
    ///   - data: The binary file data
    ///   - headers: The HTTP response headers
    ///   - recordId: The record ID that was used to download the file
    ///   - contentDocumentId: The ContentDocument ID from Salesforce
    /// - Returns: A new FileDownloadResponse instance
    public init?(
        data: Data,
        headers: [String: String],
        recordId: String,
        contentDocumentId: String
    ) {
        self.data = data
        self.fileSize = data.count
        self.recordId = recordId
        self.contentDocumentId = contentDocumentId

        // Extract filename from Content-Disposition header (case-insensitive)
        var extractedFilename = "download"
        let contentDispositionKey = headers.keys.first { $0.lowercased() == "content-disposition" }
        if let contentDisposition = contentDispositionKey.flatMap({ headers[$0] }) {
            let pattern = "filename=\"([^\"]+)\""
            if let regex = try? NSRegularExpression(pattern: pattern),
                let match = regex.firstMatch(
                    in: contentDisposition, range: NSRange(contentDisposition.startIndex..., in: contentDisposition)),
                let range = Range(match.range(at: 1), in: contentDisposition)
            {
                let filename = String(contentDisposition[range])
                // URL decode the filename (e.g., "WhatsApp+Image+2024-06-09+at+8.39.03+PM.jpeg")
                // First replace + with spaces, then remove percent encoding
                let decodedFilename = filename
                    .replacingOccurrences(of: "+", with: " ")
                    .removingPercentEncoding ?? filename
                extractedFilename = decodedFilename
            }
        }

        // Extract file extension from filename
        if let lastDotIndex = extractedFilename.lastIndex(of: "."), lastDotIndex != extractedFilename.startIndex {
            self.filename = String(extractedFilename[..<lastDotIndex])
            let extensionStart = extractedFilename.index(after: lastDotIndex)
            self.fileExtension = String(extractedFilename[extensionStart...])
        } else {
            self.filename = extractedFilename
            self.fileExtension = ""
        }

        // Extract content type from headers (case-insensitive)
        let contentTypeKey = headers.keys.first { $0.lowercased() == "content-type" }
        self.contentType = contentTypeKey.flatMap { headers[$0] } ?? "application/octet-stream"
    }
}

/// Errors specific to file download operations
public enum FileDownloadError: Error, LocalizedError, Sendable {
    /// The requested file was not found for the given record ID
    case fileNotFound
    /// The record ID format is invalid
    case invalidRecordId
    /// The file data received is corrupted or invalid
    case invalidFileData
    /// The API request to download the file failed
    case downloadFailed(Error)
    /// No files are associated with the given record ID
    case noFilesAssociated
    /// The file content version could not be found
    case contentVersionNotFound
    /// Network error during file download
    case networkError(Error)
    /// Server error from Salesforce
    case serverError(String)

    /// A user-friendly, localized description of the error
    public var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "File not found"
        case .invalidRecordId:
            return "Invalid record ID format"
        case .invalidFileData:
            return "Invalid file data received"
        case .downloadFailed(let error):
            return "Failed to download file: \(error.localizedDescription)"
        case .noFilesAssociated:
            return "No files are associated with this record"
        case .contentVersionNotFound:
            return "File content version not found"
        case .networkError(let error):
            return "Network error during file download: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}
