import Foundation
import Api

private func main() async throws {
    let client = ComplexFernTypesClient(baseURL: "https://api.fern.com")

    try await client.service.simple()
}

try await main()
