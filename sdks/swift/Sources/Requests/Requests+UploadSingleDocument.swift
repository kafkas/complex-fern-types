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
    var multipartFields: [MultipartField] {
        return [
            .file(documentFile, fieldName: "documentFile")
        ]
    }
}
