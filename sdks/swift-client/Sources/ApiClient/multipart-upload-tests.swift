import Api
import Foundation

func runMultipartUploadTests() async throws {
    print("=== Testing Multipart File Upload ===")
    
    let apiClient = ComplexFernTypesClient(baseURL: "http://localhost:8080")
    
    // Create test file data
    let testFileContent = "Test content for multipart upload - Swift SDK".data(using: .utf8)!
    let testFileContent2 = "Second test file content - Swift SDK".data(using: .utf8)!
    let testFileContent3 = "Third test file content - Swift SDK".data(using: .utf8)!
    
    print("Created test file data:")
    print("  📄 File 1 size: \(testFileContent.count) bytes")
    print("  📄 File 2 size: \(testFileContent2.count) bytes")
    print("  📄 File 3 size: \(testFileContent3.count) bytes")
    
    // Test 1: Upload Single Document
    print("\n--- Testing uploadSingleDocument ---")
    do {
        let documentFile = FormFile(data: testFileContent, filename: "test-document.txt")
        let singleDocRequest = Requests.UploadSingleDocument(documentFile: documentFile)
        try await apiClient.service.uploadSingleDocument(request: singleDocRequest)
        print("  ✅ Single document upload successful!")
    } catch {
        print("  ❌ Single document upload failed: \(error)")
        throw error
    }
    
    // Test 2: Upload List of Documents
    print("\n--- Testing uploadListOfDocuments ---")
    do {
        let documentFile1 = FormFile(data: testFileContent, filename: "document1.txt")
        let documentFile2 = FormFile(data: testFileContent2, filename: "document2.txt") 
        let documentFile3 = FormFile(data: testFileContent3, filename: "document3.txt")
        
        let listDocsRequest = Requests.UploadListOfDocuments(
            documentFile1: documentFile1,
            documentFile2: documentFile2,
            documentFiles: [documentFile3]
        )
        try await apiClient.service.uploadListOfDocuments(request: listDocsRequest)
        print("  ✅ List of documents upload successful!")
    } catch {
        print("  ❌ List of documents upload failed: \(error)")
        throw error
    }
    
    // Test 3: Upload Multiple Documents and Fields
    print("\n--- Testing uploadMultipleDocumentsAndFields ---")
    do {
        let documentFile1 = FormFile(data: testFileContent, filename: "multi-doc1.txt")
        let documentFile2 = FormFile(data: testFileContent2, filename: "multi-doc2.txt")
        let documentFile3 = FormFile(data: testFileContent3, filename: "multi-doc3.txt")
        
        let multipleDocsRequest = Requests.UploadMultipleDocumentsAndFields(
            documentFile1: documentFile1,
            documentFile2: documentFile2,
            documentFiles: [documentFile3],
            someString: "Swift SDK Test String",
            someInteger: 42,
            someBoolean: true
        )
        try await apiClient.service.uploadMultipleDocumentsAndFields(request: multipleDocsRequest)
        print("  ✅ Multiple documents and fields upload successful!")
    } catch {
        print("  ❌ Multiple documents and fields upload failed: \(error)")
        throw error
    }
    
    print("\n🎉 All multipart upload tests passed successfully!")
    print()
}
