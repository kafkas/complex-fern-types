import Foundation

extension Requests {
    public struct UploadListOfDocuments {
        public let documentFile1: FormFile
        public let documentFile2: FormFile
        public let documentFiles: [FormFile]

        public init(
            documentFile1: FormFile,
            documentFile2: FormFile,
            documentFiles: [FormFile]
        ) {
            self.documentFile1 = documentFile1
            self.documentFile2 = documentFile2
            self.documentFiles = documentFiles
        }
    }
}

extension Requests.UploadListOfDocuments: MultipartFormDataConvertible {
    var multipartFormFields: [MultipartFormField] {
        [
            .file(documentFile1, fieldName: "documentFile1"),
            .file(documentFile2, fieldName: "documentFile2"),
            .fileArray(documentFiles, fieldName: "documentFiles")
        ]
    }
}