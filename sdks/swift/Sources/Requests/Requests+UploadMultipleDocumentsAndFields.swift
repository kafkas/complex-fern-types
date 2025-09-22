import Foundation

extension Requests {
    public struct UploadMultipleDocumentsAndFields {
        /// The first document file to upload
        public let documentFile1: FormFile
        /// The second document file to upload
        public let documentFile2: FormFile
        /// Additional document files to upload
        public let documentFiles: [FormFile]
        /// A string field
        public let someString: String
        /// An integer field
        public let someInteger: Int
        /// A boolean field
        public let someBoolean: Bool

        public init(
            documentFile1: FormFile,
            documentFile2: FormFile,
            documentFiles: [FormFile],
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

extension Requests.UploadMultipleDocumentsAndFields: MultipartFormDataConvertible {
    var multipartFields: [MultipartField] {
        return [
            .file(documentFile1, fieldName: "documentFile1"),
            .file(documentFile2, fieldName: "documentFile2"),
            .fileArray(documentFiles, fieldName: "documentFiles"),
            .field(someString, fieldName: "someString"),
            .field(someInteger, fieldName: "someInteger"),
            .field(someBoolean, fieldName: "someBoolean"),
        ]
    }
}
