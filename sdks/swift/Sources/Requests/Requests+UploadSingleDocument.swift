import Foundation

extension Requests {
    public struct UploadSingleDocument {
        public let documentFile: FormFile

        public init(
            documentFile: FormFile
        ) {
            self.documentFile = documentFile
        }
    }
}

extension Requests.UploadSingleDocument: MultipartFormDataConvertible {
    var multipartFormFields: [MultipartFormField] {
        [
            .file(documentFile, fieldName: "documentFile")
        ]
    }
}