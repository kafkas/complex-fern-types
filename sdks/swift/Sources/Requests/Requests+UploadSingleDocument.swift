import Foundation

extension Requests {
    public struct UploadSingleDocument {
        /// The document file to upload
        public let documentFile: Data

        public init(documentFile: Data) {
            self.documentFile = documentFile
        }
    }
}

extension Requests.UploadSingleDocument: MultipartFormDataConvertible {
    var multipartFields: [MultipartField] {
        return [
            .file(data: documentFile, fieldName: "documentFile")
        ]
    }
}
