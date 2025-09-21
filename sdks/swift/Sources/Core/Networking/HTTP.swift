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
        private var boundary: String
        private var contentType: String
        private var bodyData: Data

        init() {
            self.boundary = "Boundary-\(UUID().uuidString)"
            self.contentType = "\(ContentType.multipartFormData.rawValue); boundary=\(boundary)"
            self.bodyData = Data()
        }

        /// Append a file field to the form data
        func appendFile(
            _ data: Data, withName name: String, fileName: String? = nil
        ) {
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)

            var contentDisposition = "Content-Disposition: form-data; name=\"\(name)\""
            if let fileName {
                contentDisposition += "; filename=\"\(fileName)\""
            }
            contentDisposition += "\r\n"

            bodyData.append(contentDisposition.data(using: .utf8)!)
            bodyData.append(
                "Content-Type: \(ContentType.applicationOctetStream.rawValue)\r\n\r\n".data(
                    using: .utf8)!)
            bodyData.append(data)
            bodyData.append("\r\n".data(using: .utf8)!)
        }

        /// Append a text field to the form data
        func appendField(_ value: String, withName name: String) {
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append(
                "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            bodyData.append(value.data(using: .utf8)!)
            bodyData.append("\r\n".data(using: .utf8)!)
        }

        /// Get the final form data with closing boundary
        func getFinalData() -> Data {
            var finalData = bodyData
            finalData.append("--\(boundary)--\r\n".data(using: .utf8)!)
            return finalData
        }
    }
}
