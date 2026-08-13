import Foundation

/// Errors for framework-agnostic sync operations.
public enum SyncError: Error, LocalizedError, Sendable {
    case recordNotFound(String)
    case preconditionFailed(currentETag: String?)
    case writeDisabled
    case deleteDisabled
    case invalidArgument(String)
    case serverError(String)
    case decodingFailed(Error)

    public var errorDescription: String? {
        switch self {
        case .recordNotFound(let detail):
            return "Record not found: \(detail)"
        case .preconditionFailed(let etag):
            if let etag { return "ETag mismatch. Current etag: \(etag)" }
            return "ETag precondition failed"
        case .writeDisabled:
            return "API writes are disabled on the server (kill switch)"
        case .deleteDisabled:
            return "API deletes are disabled on the server (kill switch)"
        case .invalidArgument(let detail):
            return "Invalid argument: \(detail)"
        case .serverError(let detail):
            return "Server error: \(detail)"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

/// Options for delta sync pulls across any sync-capable handler.
public struct SyncPullOptions: Sendable, Equatable {
    public var pageSize: Int
    public var updatedAfter: Date

    public init(pageSize: Int = 200, updatedAfter: Date) {
        self.pageSize = pageSize
        self.updatedAfter = updatedAfter
    }
}
