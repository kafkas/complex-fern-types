import Foundation

/// Represents a file with its data and optional metadata for multipart uploads
public struct FormFile {
    /// The file data
    public let data: Data
    /// Optional filename (recommended for server compatibility)
    public let filename: String?
    /// Optional MIME type (inferred if not provided)
    public let mimeType: String?

    /// Initialize a File with data and optional metadata
    /// - Parameters:
    ///   - data: The file data
    ///   - filename: Optional filename (recommended for better server compatibility)
    ///   - mimeType: Optional MIME type (e.g., "application/pdf", "image/jpeg")
    public init(data: Data, filename: String? = nil, mimeType: String? = nil) {
        self.data = data
        self.filename = filename
        self.mimeType = mimeType
    }
}

// MARK: - Convenience Initializers

extension FormFile {
    /// Create a FormFile from raw Data with no metadata
    /// - Parameter data: The file data
    public static func data(_ data: Data) -> FormFile {
        return FormFile(data: data)
    }

    /// Create a FormFile from Data with a filename
    /// - Parameters:
    ///   - data: The file data
    ///   - filename: The filename
    public static func named(_ data: Data, filename: String) -> FormFile {
        return FormFile(data: data, filename: filename)
    }

    /// Create a FormFile with data, filename and MIME type
    /// - Parameters:
    ///   - data: The file data
    ///   - filename: The filename
    ///   - mimeType: The MIME type
    public static func typed(_ data: Data, filename: String, mimeType: String) -> FormFile {
        return FormFile(data: data, filename: filename, mimeType: mimeType)
    }
}
