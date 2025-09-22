import Foundation

/// Protocol for types that can be converted to multipart form data
protocol MultipartFormDataConvertible {
    /// The multipart fields that represent this request
    var multipartFields: [MultipartField] { get }
}

/// Represents a field in multipart form data
enum MultipartField {
    /// A single file field
    case file(_ file: FormFile, fieldName: String)
    /// An array of files with the same field name
    case fileArray(_ files: [FormFile], fieldName: String)
    /// A text field (for strings, numbers, booleans, etc.)
    case text(value: String, fieldName: String)
}

extension MultipartFormDataConvertible {
    /// Builds multipart form data from the fields
    func buildMultipartFormData() -> MultipartFormData {
        let multipartData = MultipartFormData()

        for field in multipartFields {
            switch field {
            case .file(let file, let fieldName):
                multipartData.appendFile(file.data, withName: fieldName, fileName: file.filename)
            case .fileArray(let files, let fieldName):
                for file in files {
                    multipartData.appendFile(
                        file.data, withName: fieldName, fileName: file.filename)
                }
            case .text(let value, let fieldName):
                multipartData.appendField(value, withName: fieldName)
            }
        }

        return multipartData
    }
}
