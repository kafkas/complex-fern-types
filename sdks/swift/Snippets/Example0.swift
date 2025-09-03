import Foundation
import Api

private func main() async throws {
    let client = ComplexFernTypesClient()

    try await client.service.simple()
}

try await main()
