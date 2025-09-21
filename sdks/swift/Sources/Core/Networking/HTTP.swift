import Foundation

enum HTTP {
    enum Method: String, CaseIterable {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
        case head = "HEAD"
    }

    enum ContentType: String, CaseIterable {
        case applicationJson = "application/json"
        case applicationOctetStream = "application/octet-stream"
        case multipartFormData = "multipart/form-data"
    }

    enum RequestBody {
        case jsonEncodable(any Encodable)
        case data(Data)
        case multipartFormData(MultipartFormData)
    }

    /// Helper class for building multipart form data requests
    class MultipartFormData {
        private let boundary: String
        private var bodyData: Data
        let contentType: String

        init() {
            self.boundary = "Boundary-\(UUID().uuidString)"
            self.bodyData = Data()
            self.contentType = "\(ContentType.multipartFormData.rawValue); boundary=\(boundary)"
        }

        /// Append a file field to the form data
        func appendFile(
            _ data: Data, withName name: String, fileName: String? = nil
        ) {
            bodyData.appendUTF8String("--\(boundary)\r\n")
            var contentDisposition = "Content-Disposition: form-data; name=\"\(name)\""
            if let fileName {
                contentDisposition += "; filename=\"\(fileName)\""
            }
            contentDisposition += "\r\n"
            bodyData.appendUTF8String(contentDisposition)
            bodyData.appendUTF8String(
                "Content-Type: \(ContentType.applicationOctetStream.rawValue)\r\n\r\n")
            bodyData.append(data)
            bodyData.appendUTF8String("\r\n")
        }

        /// Append a text field to the form data
        func appendField(_ value: String, withName name: String) {
            bodyData.appendUTF8String("--\(boundary)\r\n")
            bodyData.appendUTF8String(
                "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            bodyData.appendUTF8String(value)
            bodyData.appendUTF8String("\r\n")
        }

        /// Get the final form data with closing boundary
        func getFinalData() -> Data {
            var finalData = bodyData
            finalData.appendUTF8String("--\(boundary)--\r\n")
            return finalData
        }
    }
}
