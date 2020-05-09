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

extension ResponsePayload: MockProtocol {
   
    static func mock() -> ResponsePayload {
        return ResponsePayload(total: 308, result: [ResponsePayload.FactPayload.mock()])
    }
}

extension ResponsePayload.FactPayload: MockProtocol {
    static func mock() -> ResponsePayload.FactPayload {
        return ResponsePayload.FactPayload(created_at: "2020-01-05 13:42:18.823766", icon_url: URL(string: "https://assets.chucknorris.host/img/avatar/chuck-norris.png")!, id: "13dfd2342352d", updated_at: "2020-01-05 13:42:18.823766", url:  URL(string: "https://assets.chucknorris.host")!, value: "Chuck Norris let the dogs out Chuck Norris wants some more", categories: [])
    }
}
