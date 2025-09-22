import Foundation

extension Requests {
    public struct UploadMultipleDocumentsAndFields {
        public let documentFile1: FormFile
        public let documentFile2: FormFile
        public let documentFiles: [FormFile]
        public let someString: String
        public let someInteger: Int
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
    var multipartFormFields: [MultipartFormField] {
        [
            .file(documentFile1, fieldName: "documentFile1"),
            .file(documentFile2, fieldName: "documentFile2"),
            .fileArray(documentFiles, fieldName: "documentFiles"),
            .field(someString, fieldName: "someString"),
            .field(someInteger, fieldName: "someInteger"),
            .field(someBoolean, fieldName: "someBoolean")
        ]
    }
}