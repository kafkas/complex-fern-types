import ApiTarget

// Example usage of the Api library
print("ApiClient started")

// Create an instance of the ApiClient from the dependency
let client = ApiClient(
    baseURL: "https://api.example.com",
    apiKey: "your-api-key"
)

print("Created ApiClient with types support")

// You can now use the client and its types
// For example, accessing the types client:
// client.types.someMethod()

// Example with Shape types (uncomment if you want to use them):
// let circle = Circle(radius: 5.0)
// let square = Square(side: 10.0)
// print("Created shapes: circle and square")

print("ApiClient setup completed")