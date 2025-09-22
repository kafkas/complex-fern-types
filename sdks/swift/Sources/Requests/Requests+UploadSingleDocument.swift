import Foundation

extension Requests {
    public struct UploadSingleDocument {
        /// The document file to upload
        public let documentFile: FormFile

        public init(documentFile: FormFile) {
            self.documentFile = documentFile
        }
    }
}

extension Requests.UploadSingleDocument: MultipartFormDataConvertible {
    var multipartFormFields: [MultipartFormField] {
        return [
            .file(documentFile, fieldName: "documentFile")
        ]
    }
}
