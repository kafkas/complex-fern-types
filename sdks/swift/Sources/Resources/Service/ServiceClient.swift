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

    public func uploadSingleDocument(request: any Codable, requestOptions: RequestOptions? = nil) async throws -> Void {
        return try await httpClient.performRequest(
            method: .post,
            path: "/upload-single-document",
            body: request,
            requestOptions: requestOptions
        )
    }

    public func uploadListOfDocuments(request: any Codable, requestOptions: RequestOptions? = nil) async throws -> Void {
        return try await httpClient.performRequest(
            method: .post,
            path: "/upload-list-of-documents",
            body: request,
            requestOptions: requestOptions
        )
    }

    public func uploadMultipleDocumentsAndFields(request: any Codable, requestOptions: RequestOptions? = nil) async throws -> Void {
        return try await httpClient.performRequest(
            method: .post,
            path: "/upload-multiple-documents-and-fields",
            body: request,
            requestOptions: requestOptions
        )
    }
}