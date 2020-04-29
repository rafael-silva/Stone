import Foundation

struct ResponsePayload: Decodable {
    let total: Int
    let result: [FactPayload]
}

extension ResponsePayload {
    struct FactPayload: Decodable {
        let created_at: String
        let icon_url: URL
        let id: String
        let updated_at: String
        let url: URL
        let value: String
        let categories: [String]
    }
}
