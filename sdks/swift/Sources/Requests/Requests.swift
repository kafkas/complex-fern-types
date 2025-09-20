import Foundation

/// Container for all inline request types used throughout the SDK.
///
/// This enum serves as a namespace to organize request types that are defined inline within endpoint specifications.
public enum Requests {
    /// Request type for uploading a single document file.
    public struct UploadSingleDocument {
        /// The document file to upload
        public let documentFile: Data
        
        public init(documentFile: Data) {
            self.documentFile = documentFile
        }
    }
    
    /// Request type for uploading a list of document files.
    public struct UploadListOfDocuments {
        /// The first document file to upload
        public let documentFile1: Data
        /// The second document file to upload
        public let documentFile2: Data
        /// Additional document files to upload
        public let documentFiles: [Data]
        
        public init(documentFile1: Data, documentFile2: Data, documentFiles: [Data]) {
            self.documentFile1 = documentFile1
            self.documentFile2 = documentFile2
            self.documentFiles = documentFiles
        }
    }
    
    /// Request type for uploading multiple documents along with additional form fields.
    public struct UploadMultipleDocumentsAndFields {
        /// The first document file to upload
        public let documentFile1: Data
        /// The second document file to upload
        public let documentFile2: Data
        /// Additional document files to upload
        public let documentFiles: [Data]
        /// A string field
        public let someString: String
        /// An integer field
        public let someInteger: Int
        /// A boolean field
        public let someBoolean: Bool
        
        public init(
            documentFile1: Data,
            documentFile2: Data,
            documentFiles: [Data],
            someString: String,
            someInteger: Int,
            someBoolean: Bool
        ) {
            self.documentFile1 = documentFile1
            self.documentFile2 = documentFile2
            self.documentFiles = documentFiles
            self.someString = someString
            self.someInteger = someInteger
            self.someBoolean = someBoolean
        }
    }
}