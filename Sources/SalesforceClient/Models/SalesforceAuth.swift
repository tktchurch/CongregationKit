import Foundation

/// Represents the authentication response from Salesforce OAuth 2.0
public struct SalesforceAuthResponse: Codable, Sendable {
    /// Access token that acts as a session ID for making API requests
    public let accessToken: String
    
    /// Identifies the Salesforce instance for API calls
    public let instanceUrl: String
    
    /// Identity URL for user identification and information queries
    public let id: String
    
    /// Token type (typically "Bearer")
    public let tokenType: String
    
    /// When the signature was created (Unix epoch seconds)
    public let issuedAt: String
    
    /// Base64-encoded HMAC-SHA256 signature
    public let signature: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case instanceUrl = "instance_url"
        case id
        case tokenType = "token_type"
        case issuedAt = "issued_at"
        case signature
    }
}

/// Represents authentication credentials for Salesforce
public struct SalesforceCredentials: Sendable {
    /// OAuth client ID
    public let clientId: String
    
    /// OAuth client secret
    public let clientSecret: String
    
    /// Salesforce username
    public let username: String
    
    /// Salesforce password
    public let password: String
    
    public init(
        clientId: String,
        clientSecret: String,
        username: String,
        password: String
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.username = username
        self.password = password
    }
}

/// Represents authentication errors
public enum SalesforceAuthError: Error, LocalizedError, Sendable {
    case invalidCredentials
    case networkError(Error)
    case invalidResponse
    case serverError(String)
    case rateLimitExceeded
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid Salesforce credentials"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from Salesforce"
        case .serverError(let message):
            return "Salesforce server error: \(message)"
        case .rateLimitExceeded:
            return "Salesforce API rate limit exceeded"
        }
    }
} 
