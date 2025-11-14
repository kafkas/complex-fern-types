import Foundation
import Api

private func main() async throws {
    let client = ComplexFernTypesClient(baseURL: "https://api.fern.com")

    _ = try await client.service.sendInlinedRequest(request: .init(
        someString: "someString",
        someInt: 1
    ))
}

try await main()
