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
    /// A text field with JSON-encoded value (for strings, numbers, booleans, dates, etc.)
    case field(_ value: EncodableValue, fieldName: String)

    /// Create a text field from any Encodable value
    static func field<T: Encodable>(_ value: T, fieldName: String) -> MultipartField {
        return .field(.init(value), fieldName: fieldName)
    }
}

extension MultipartFormDataConvertible {
    /// Builds multipart form data from the fields
    func buildMultipartFormData() -> MultipartFormData {
        let multipartData = MultipartFormData()
        let jsonEncoder = Serde.jsonEncoder

        for field in multipartFields {
            switch field {
            case .file(let file, let fieldName):
                multipartData.appendFile(file.data, withName: fieldName, fileName: file.filename)
            case .fileArray(let files, let fieldName):
                for file in files {
                    multipartData.appendFile(
                        file.data,
                        withName: fieldName,
                        fileName: file.filename
                    )
                }
            case .field(let encodableValue, let fieldName):
                do {
                    let encodedData = try jsonEncoder.encode(value: encodableValue)
                    if let encodedString = String(data: encodedData, encoding: .utf8) {
                        // Remove quotes from simple JSON values (strings, numbers, booleans)
                        let finalValue: String = encodedString.trimmingCharacters(
                            in: CharacterSet(charactersIn: "\"")
                        )
                        multipartData.appendField(finalValue, withName: fieldName)
                    }
                } catch {
                    // Fallback - this should rarely happen with well-formed Encodable types
                    multipartData.appendField("", withName: fieldName)
                }
            }
        }

        return multipartData
    }
}
