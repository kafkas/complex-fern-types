import Api
import Foundation

func runCircularTests() throws {
    print("=== Testing Circular/Recursive Types (BinaryTreeNode with Indirect) ===")

    // 1) Leaf node
    let leaf = BinaryTreeNode(name: "leaf")
    try testRoundTrip(leaf, description: "BinaryTreeNode (leaf)")

    // 2) Single left child
    let leftOnly = BinaryTreeNode(
        name: "root",
        leftChild: BinaryTreeNode(name: "L")
    )
    try testRoundTrip(leftOnly, description: "BinaryTreeNode (single left child)")

    // 3) Single right child
    let rightOnly = BinaryTreeNode(
        name: "root",
        rightChild: (BinaryTreeNode(name: "R"))
    )
    try testRoundTrip(rightOnly, description: "BinaryTreeNode (single right child)")

    // 4) Full two-level tree
    let full = BinaryTreeNode(
        name: "root",
        leftChild:
            BinaryTreeNode(
                name: "L",
                leftChild: BinaryTreeNode(name: "LL"),
                rightChild: BinaryTreeNode(name: "LR")
            ),
        rightChild:
            BinaryTreeNode(
                name: "R",
                leftChild: BinaryTreeNode(name: "RL"),
                rightChild: BinaryTreeNode(name: "RR")
            )
    )
    try testRoundTrip(full, description: "BinaryTreeNode (full 2-level tree)")

    // 5) JSON decoding: verify Indirect is transparent in the wire format
    print("--- Test: JSON Decoding ---")
    let json = """
        {
            "name": "root",
            "leftChild": {
                "name": "L",
                "leftChild": { "name": "LL" }
            },
            "rightChild": {
                "name": "R"
            }
        }
        """
    let decoded = try testJSONDecoding(
        json, as: BinaryTreeNode.self, description: "BinaryTreeNode from JSON")

    // Spot‑check structure
    if decoded.name != "root" {
        throw TestError.unexpectedResult("root name mismatch")
    }
    if decoded.leftChild?.value.name != "L" {
        throw TestError.unexpectedResult("left child name mismatch")
    }
    if decoded.leftChild?.value.leftChild?.value.name != "LL" {
        throw TestError.unexpectedResult("left-left child name mismatch")
    }
    if decoded.leftChild?.value.rightChild != nil {
        throw TestError.unexpectedResult("left-right should be nil")
    }
    if decoded.rightChild?.value.name != "R" {
        throw TestError.unexpectedResult("right child name mismatch")
    }

    // 6) Encode the decoded value and ensure it round‑trips too
    try testRoundTrip(decoded, description: "BinaryTreeNode (decoded round trip)")

    print("✅ BinaryTreeNode indirect encode/decode tests passed!")
    print()
}
