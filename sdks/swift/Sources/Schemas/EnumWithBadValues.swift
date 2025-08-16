import Foundation

public enum EnumWithBadValues: String, Codable, Hashable, CaseIterable, Sendable {
    case badValue1
    case badValue2
    case badValue3
}