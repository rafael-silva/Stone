import Foundation

struct Response {
    let total: Int
    let facts: [Fact]
    
    init(output: ResponsePayload) {
        total = output.total
        facts = output.result.map { Fact(output: $0) }
    }
}
