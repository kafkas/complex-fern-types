import Foundation

extension Requests {
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
}

extension Requests.UploadListOfDocuments: MultipartFormDataConvertible {
    var multipartFields: [MultipartField] {
        return [
            .file(data: documentFile1, fieldName: "documentFile1"),
            .file(data: documentFile2, fieldName: "documentFile2"),
            .fileArray(data: documentFiles, fieldName: "documentFiles"),
        ]
    }
}
