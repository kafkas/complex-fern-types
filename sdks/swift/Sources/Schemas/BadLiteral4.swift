import Foundation

public enum BadLiteral4: String, Codable, Hashable, CaseIterable, Sendable {
    case someBadValue32 = "-%()_=--#-_-- some bad value --_$32--"
}