import Foundation
import Api

let client = ComplexFernTypesClient(baseURL: "String")

private func main() async throws {
    let uuid = UUID()
    try await client.service.simple()
}

try await main()
