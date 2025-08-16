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

    public func downloadFile(requestOptions: RequestOptions? = nil) async throws -> JSONValue {
        return try await httpClient.performRequest(
            method: .post,
            path: "/download-file",
            requestOptions: requestOptions,
            responseType: JSONValue.self
        )
    }

    public func uploadFile(request: Data, requestOptions: RequestOptions? = nil) async throws -> String {
        return try await httpClient.performFileUpload(
            method: .post,
            path: "/upload-file",
            fileData: request,
            requestOptions: requestOptions,
            responseType: String.self
        )
    }
}