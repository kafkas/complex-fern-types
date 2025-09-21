import Foundation

public final class ServiceClient: Sendable {
    private let httpClient: HTTPClient

    public init(config: ClientConfig) {
        self.httpClient = HTTPClient(config: config)
    }

    public func simple(requestOptions: RequestOptions? = nil) async throws -> Void {
        return try await httpClient.performRequest(
            method: .post,
            path: "/snippet",
            requestOptions: requestOptions
        )
    }

    public func downloadFile(requestOptions: RequestOptions? = nil) async throws -> Data {
        return try await httpClient.performRequest(
            method: .post,
            path: "/download-file",
            requestOptions: requestOptions,
            responseType: Data.self
        )
    }

    public func uploadFile(request: Data, requestOptions: RequestOptions? = nil) async throws -> String {
        return try await httpClient.performRequest(
            method: .post,
            path: "/upload-file",
            contentType: .applicationOctetStream,
            body: request,
            requestOptions: requestOptions,
            responseType: String.self
        )
    }

    public func uploadSingleDocument(request: Requests.UploadSingleDocument, requestOptions: RequestOptions? = nil) async throws -> Void {
        let multipartData = HTTP.MultipartFormData()
        multipartData.appendFile(request.documentFile, withName: "documentFile", fileName: "file.txt")
        
        return try await httpClient.performRequest(
            method: .post,
            path: "/upload-single-document",
            contentType: .multipartFormData,
            body: multipartData,
            requestOptions: requestOptions
        )
    }

    public func uploadListOfDocuments(request: Requests.UploadListOfDocuments, requestOptions: RequestOptions? = nil) async throws -> Void {
        let multipartData = HTTP.MultipartFormData()
        multipartData.appendFile(request.documentFile1, withName: "documentFile1", fileName: "file1.txt")
        multipartData.appendFile(request.documentFile2, withName: "documentFile2", fileName: "file2.txt")
        
        // Append multiple files with the same field name
        for (index, documentFile) in request.documentFiles.enumerated() {
            multipartData.appendFile(documentFile, withName: "documentFiles", fileName: "file\(index + 3).txt")
        }
        
        return try await httpClient.performRequest(
            method: .post,
            path: "/upload-list-of-documents",
            contentType: .multipartFormData,
            body: multipartData,
            requestOptions: requestOptions
        )
    }

    public func uploadMultipleDocumentsAndFields(request: Requests.UploadMultipleDocumentsAndFields, requestOptions: RequestOptions? = nil) async throws -> Void {
        let multipartData = HTTP.MultipartFormData()
        
        // Append files
        multipartData.appendFile(request.documentFile1, withName: "documentFile1", fileName: "file1.txt")
        multipartData.appendFile(request.documentFile2, withName: "documentFile2", fileName: "file2.txt")
        
        for (index, documentFile) in request.documentFiles.enumerated() {
            multipartData.appendFile(documentFile, withName: "documentFiles", fileName: "file\(index + 3).txt")
        }
        
        // Append other form fields
        multipartData.appendField(request.someString, withName: "someString")
        multipartData.appendField(String(request.someInteger), withName: "someInteger")
        multipartData.appendField(String(request.someBoolean), withName: "someBoolean")
        
        return try await httpClient.performRequest(
            method: .post,
            path: "/upload-multiple-documents-and-fields",
            contentType: .multipartFormData,
            body: multipartData,
            requestOptions: requestOptions
        )
    }
}