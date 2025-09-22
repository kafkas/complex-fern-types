import Foundation

/// Protocol for types that can be converted to multipart form data
protocol MultipartFormDataConvertible {
    /// The multipart fields that represent this request
    var multipartFields: [MultipartField] { get }
}

/// Represents a field in multipart form data
enum MultipartField {
    /// A single file field
    case file(data: Data, fieldName: String, fileName: String? = nil)
    /// An array of files with the same field name
    case fileArray(data: [Data], fieldName: String)
    /// A text field (for strings, numbers, booleans, etc.)
    case text(value: String, fieldName: String)
}

extension MultipartFormDataConvertible {
    /// Builds multipart form data from the fields
    func buildMultipartFormData() -> HTTP.MultipartFormData {
        let multipartData = HTTP.MultipartFormData()
        
        for field in multipartFields {
            switch field {
            case .file(let data, let fieldName, let fileName):
                multipartData.appendFile(data, withName: fieldName, fileName: fileName)
            case .fileArray(let dataArray, let fieldName):
                for data in dataArray {
                    multipartData.appendFile(data, withName: fieldName)
                }
            case .text(let value, let fieldName):
                multipartData.appendField(value, withName: fieldName)
            }
        }

        return multipartData
    }
}
