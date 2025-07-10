import Foundation

/// Represents the authentication response from Salesforce OAuth 2.0 with comprehensive security information.
///
/// The `SalesforceAuthResponse` struct encapsulates all the authentication data returned
/// by Salesforce after successful OAuth 2.0 authentication. This includes access tokens,
/// instance information, and security signatures for secure API communication.
///
/// ## Overview
///
/// This struct contains all necessary information for authenticated API calls:
/// - **Access Token:** Primary authentication credential for API requests
/// - **Instance URL:** Salesforce instance endpoint for API calls
/// - **Identity Information:** User identification and metadata
/// - **Security Data:** Token type, issuance time, and signature verification
///
/// ## Key Features
///
/// - **Complete OAuth 2.0 Support:** Full OAuth 2.0 response handling
/// - **Security Verification:** Signature and timestamp validation
/// - **Instance Management:** Dynamic instance URL handling
/// - **Token Management:** Access token for API authentication
/// - **Identity Tracking:** User identification and metadata
///
/// ## Example Usage
///
/// ```swift
/// // After successful OAuth authentication
/// let authResponse = SalesforceAuthResponse(
///     accessToken: "00D...",
///     instanceUrl: "https://your-instance.salesforce.com",
///     id: "https://login.salesforce.com/id/00D.../005...",
///     tokenType: "Bearer",
///     issuedAt: "1234567890",
///     signature: "base64-encoded-signature"
/// )
///
/// // Use for API calls
/// let headers = [
///     "Authorization": "\(authResponse.tokenType) \(authResponse.accessToken)",
///     "Content-Type": "application/json"
/// ]
///
/// // Access instance information
/// print("Instance URL: \(authResponse.instanceUrl)")
/// print("User ID: \(authResponse.id)")
/// ```
///
/// ## Topics
///
/// ### Authentication Data
/// - ``accessToken`` - Access token for API authentication
/// - ``instanceUrl`` - Salesforce instance URL for API calls
/// - ``id`` - Identity URL for user identification
///
/// ### Security Information
/// - ``tokenType`` - Token type (typically "Bearer")
/// - ``issuedAt`` - When the signature was created
/// - ``signature`` - Base64-encoded HMAC-SHA256 signature
///
/// ## Security Considerations
///
/// ### Token Security
/// - **Secure Storage:** Store access tokens securely, never in plain text
/// - **Token Expiration:** Monitor token expiration and refresh as needed
/// - **Scope Limitation:** Use minimal required OAuth scopes
/// - **HTTPS Only:** Always use HTTPS for token transmission
///
/// ### Signature Verification
/// - **Timestamp Validation:** Verify `issuedAt` timestamp is recent
/// - **Signature Verification:** Validate HMAC-SHA256 signature when possible
/// - **Replay Protection:** Check for duplicate requests using timestamps
///
/// ## Integration with CongregationKit
///
/// ```swift
/// // Initialize CongregationKit with auth response
/// let congregation = CongregationKit(
///     httpClient: httpClient,
///     authResponse: authResponse
/// )
///
/// // The auth response is automatically used for all API calls
/// let members = try await congregation.members.fetchAll()
/// ```
///
/// ## Data Validation
///
/// - **Required Fields:** All fields are required for valid authentication
/// - **URL Validation:** Instance URL must be valid HTTPS URL
/// - **Token Format:** Access token must be non-empty string
/// - **Timestamp Format:** Issued at timestamp must be valid Unix timestamp
public struct SalesforceAuthResponse: Codable, Sendable {
    /// Access token that acts as a session ID for making API requests
    ///
    /// This is the primary authentication credential used for all Salesforce API calls.
    /// The token should be treated as sensitive data and stored securely.
    public let accessToken: String

    /// Identifies the Salesforce instance for API calls
    ///
    /// The base URL for all Salesforce API endpoints. This is specific to your
    /// Salesforce organization and may change between environments.
    public let instanceUrl: String

    /// Identity URL for user identification and information queries
    ///
    /// Contains user and organization identification information that can be
    /// used to retrieve additional user metadata and permissions.
    public let id: String

    /// Token type (typically "Bearer")
    ///
    /// Indicates the type of authentication token. For Salesforce OAuth 2.0,
    /// this is typically "Bearer" and is used in Authorization headers.
    public let tokenType: String

    /// When the signature was created (Unix epoch seconds)
    ///
    /// Timestamp indicating when the authentication response was created.
    /// Used for security validation and replay protection.
    public let issuedAt: String

    /// Base64-encoded HMAC-SHA256 signature
    ///
    /// Cryptographic signature for verifying the authenticity of the response.
    /// Used for security validation and preventing tampering.
    public let signature: String

    /// Coding keys for mapping API fields to struct properties
    ///
    /// These keys handle the mapping between Salesforce OAuth response field names
    /// and the struct properties, following OAuth 2.0 standard naming conventions.
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case instanceUrl = "instance_url"
        case id
        case tokenType = "token_type"
        case issuedAt = "issued_at"
        case signature
    }
}

/// Represents authentication credentials for Salesforce with secure credential management.
///
/// The `SalesforceCredentials` struct encapsulates the OAuth 2.0 credentials needed
/// to authenticate with Salesforce. This includes client credentials and user credentials
/// for password-based OAuth flow.
///
/// ## Overview
///
/// This struct contains all credentials needed for Salesforce authentication:
/// - **Client Credentials:** OAuth 2.0 client ID and secret
/// - **User Credentials:** Salesforce username and password
/// - **Secure Handling:** Designed for secure credential management
///
/// ## Key Features
///
/// - **OAuth 2.0 Support:** Complete OAuth 2.0 credential management
/// - **Secure Design:** Structured for secure credential handling
/// - **Client Management:** Support for multiple OAuth clients
/// - **User Authentication:** Username/password authentication flow
/// - **Production Ready:** Designed for production church applications
///
/// ## Example Usage
///
/// ```swift
/// // Create credentials for authentication
/// let credentials = SalesforceCredentials(
///     clientId: "your_oauth_client_id",
///     clientSecret: "your_oauth_client_secret",
///     username: "your_salesforce_username",
///     password: "your_salesforce_password"
/// )
///
/// // Use with CongregationKit
/// let congregation = try await CongregationKit(
///     httpClient: httpClient,
///     credentials: credentials
/// )
/// ```
///
/// ## Topics
///
/// ### OAuth Credentials
/// - ``clientId`` - OAuth client ID
/// - ``clientSecret`` - OAuth client secret
///
/// ### User Credentials
/// - ``username`` - Salesforce username
/// - ``password`` - Salesforce password
///
/// ## Security Best Practices
///
/// ### Credential Storage
/// - **Environment Variables:** Store credentials in environment variables
/// - **Secure Keychain:** Use iOS/macOS keychain for mobile apps
/// - **Encrypted Storage:** Encrypt credentials in persistent storage
/// - **No Hardcoding:** Never hardcode credentials in source code
///
/// ### OAuth Configuration
/// - **Minimal Scopes:** Request only necessary OAuth scopes
/// - **Client Security:** Keep client secrets secure and rotate regularly
/// - **User Permissions:** Use dedicated service account when possible
/// - **Network Security:** Always use HTTPS for credential transmission
///
/// ## Integration Patterns
///
/// ### Environment-Based Configuration
/// ```swift
/// let credentials = SalesforceCredentials(
///     clientId: ProcessInfo.processInfo.environment["SALESFORCE_CLIENT_ID"] ?? "",
///     clientSecret: ProcessInfo.processInfo.environment["SALESFORCE_CLIENT_SECRET"] ?? "",
///     username: ProcessInfo.processInfo.environment["SALESFORCE_USERNAME"] ?? "",
///     password: ProcessInfo.processInfo.environment["SALESFORCE_PASSWORD"] ?? ""
/// )
/// ```
///
/// ### Keychain Integration (iOS/macOS)
/// ```swift
/// // Store credentials securely
/// let query: [String: Any] = [
///     kSecClass as String: kSecClassGenericPassword,
///     kSecAttrAccount as String: "SalesforceCredentials",
///     kSecValueData as String: try JSONEncoder().encode(credentials)
/// ]
/// SecItemAdd(query as CFDictionary, nil)
/// ```
///
/// ## Data Validation
///
/// - **Required Fields:** All fields are required for valid authentication
/// - **Format Validation:** Client ID and username should be non-empty strings
/// - **Password Security:** Password should meet Salesforce security requirements
/// - **Client Validation:** Client ID and secret should be valid OAuth credentials
public struct SalesforceCredentials: Sendable {
    /// OAuth client ID
    ///
    /// The client identifier issued by Salesforce for your OAuth application.
    /// This identifies your application to Salesforce during authentication.
    public let clientId: String

    /// OAuth client secret
    ///
    /// The client secret issued by Salesforce for your OAuth application.
    /// This should be kept secure and never exposed in client-side code.
    public let clientSecret: String

    /// Salesforce username
    ///
    /// The username for the Salesforce user account that will be used for
    /// API authentication. This should be a dedicated service account when possible.
    public let username: String

    /// Salesforce password
    ///
    /// The password for the Salesforce user account. This should meet
    /// Salesforce security requirements and be stored securely.
    public let password: String

    /// Creates a new SalesforceCredentials instance
    ///
    /// - Parameters:
    ///   - clientId: The OAuth client ID
    ///   - clientSecret: The OAuth client secret
    ///   - username: The Salesforce username
    ///   - password: The Salesforce password
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

/// Represents authentication errors with comprehensive error handling and localized descriptions.
///
/// The `SalesforceAuthError` enum provides detailed error information for authentication
/// failures, including network issues, credential problems, and server errors.
///
/// ## Overview
///
/// This enum covers all common authentication failure scenarios:
/// - **Credential Errors:** Invalid or expired credentials
/// - **Network Issues:** Connectivity and communication problems
/// - **Server Errors:** Salesforce server-side issues
/// - **Rate Limiting:** API rate limit exceeded
/// - **Response Errors:** Invalid or corrupted response data
///
/// ## Key Features
///
/// - **Comprehensive Coverage:** All major authentication error scenarios
/// - **Localized Messages:** User-friendly error descriptions
/// - **Detailed Information:** Specific error context and underlying causes
/// - **Recovery Guidance:** Error types that suggest recovery actions
/// - **Production Ready:** Designed for production error handling
///
/// ## Example Usage
///
/// ```swift
/// do {
///     let congregation = try await CongregationKit(
///         httpClient: httpClient,
///         credentials: credentials
///     )
///     // Use congregation
/// } catch SalesforceAuthError.invalidCredentials {
///     print("Please check your Salesforce credentials")
/// } catch SalesforceAuthError.networkError(let underlyingError) {
///     print("Network error: \(underlyingError.localizedDescription)")
/// } catch SalesforceAuthError.rateLimitExceeded {
///     print("Too many requests, please wait before retrying")
/// } catch {
///     print("Unexpected error: \(error)")
/// }
/// ```
///
/// ## Topics
///
/// ### Error Cases
/// - ``invalidCredentials`` - Invalid Salesforce credentials
/// - ``networkError`` - Network connectivity issues
/// - ``invalidResponse`` - Invalid response from Salesforce
/// - ``serverError`` - Salesforce server-side errors
/// - ``rateLimitExceeded`` - API rate limit exceeded
///
/// ### Error Information
/// - ``errorDescription`` - User-friendly error description
///
/// ## Error Handling Strategies
///
/// ### Credential Errors
/// - **Invalid Credentials:** Prompt user to verify credentials
/// - **Expired Tokens:** Implement automatic token refresh
/// - **Permission Issues:** Check user permissions and roles
///
/// ### Network Errors
/// - **Connectivity Issues:** Implement retry logic with exponential backoff
/// - **Timeout Errors:** Increase timeout values for slow connections
/// - **DNS Issues:** Check network configuration and DNS settings
///
/// ### Server Errors
/// - **Temporary Issues:** Implement retry logic for transient errors
/// - **Maintenance Windows:** Check Salesforce status page
/// - **Service Unavailable:** Implement graceful degradation
///
/// ### Rate Limiting
/// - **Exponential Backoff:** Implement progressive retry delays
/// - **Request Queuing:** Queue requests when approaching limits
/// - **Load Balancing:** Distribute requests across time periods
///
/// ## Integration with Error Handling
///
/// ```swift
/// func authenticateWithRetry(credentials: SalesforceCredentials, maxRetries: Int = 3) async throws -> CongregationKit {
///     var lastError: Error?
///
///     for attempt in 1...maxRetries {
///         do {
///             return try await CongregationKit(httpClient: httpClient, credentials: credentials)
///         } catch SalesforceAuthError.networkError {
///             lastError = error
///             if attempt < maxRetries {
///                 try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt))) * 1_000_000_000)
///                 continue
///             }
///         } catch {
///             throw error
///         }
///     }
///
///     throw lastError ?? SalesforceAuthError.networkError(NSError(domain: "Unknown", code: -1))
/// }
/// ```
///
/// ## Localized Error Messages
///
/// All errors provide user-friendly, localized descriptions suitable for
/// display in user interfaces or logging systems.
public enum SalesforceAuthError: Error, LocalizedError, Sendable {
    /// Invalid Salesforce credentials
    ///
    /// This error occurs when the provided credentials (client ID, client secret,
    /// username, or password) are incorrect or have expired.
    case invalidCredentials

    /// Network error during authentication
    ///
    /// This error occurs when there are connectivity issues, timeouts, or other
    /// network-related problems during the authentication process.
    case networkError(Error)

    /// Invalid response from Salesforce
    ///
    /// This error occurs when Salesforce returns a response that cannot be parsed
    /// or contains unexpected data format.
    case invalidResponse

    /// Salesforce server error
    ///
    /// This error occurs when Salesforce returns a server-side error with a
    /// specific error message from their system.
    case serverError(String)

    /// Salesforce API rate limit exceeded
    ///
    /// This error occurs when the application has exceeded Salesforce API rate limits
    /// and needs to wait before making additional requests.
    case rateLimitExceeded

    /// A user-friendly, localized description of the error
    ///
    /// This property provides human-readable error messages suitable for
    /// display in user interfaces or logging systems.
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
