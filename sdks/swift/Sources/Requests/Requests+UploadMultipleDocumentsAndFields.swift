import Foundation

extension Requests {
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

extension Requests.UploadMultipleDocumentsAndFields: MultipartFormDataConvertible {
    var multipartFields: [MultipartField] {
        return [
            .file(data: documentFile1, fieldName: "documentFile1"),
            .file(data: documentFile2, fieldName: "documentFile2"),
            .fileArray(data: documentFiles, fieldName: "documentFiles"),
            .text(value: someString, fieldName: "someString"),
            .text(value: String(someInteger), fieldName: "someInteger"),
            .text(value: String(someBoolean), fieldName: "someBoolean"),
        ]
    }
}
