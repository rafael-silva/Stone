import Foundation

struct Fact {
     let createdAt: String
     let iconUrl: URL
     let id: String
     let updatedAt: String
     let url: URL
     let value: String
     let categories: [String]
 }

extension Fact {
    init(output: ResponsePayload.FactPayload) {
        createdAt = output.created_at
        iconUrl = output.icon_url
        id = output.id
        updatedAt = output.updated_at
        url = output.url
        value =  output.value
        categories = output.categories
    }
}

extension Fact: MockProtocol {
    static func mock() -> Fact {
        return Fact(createdAt: "2020-01-05 13:42:18.823766", iconUrl: URL(string: "https://assets.chucknorris.host/img/avatar/chuck-norris.png")!, id: "13dfd2342352d", updatedAt: "2020-01-05 13:42:18.823766", url:  URL(string: "https://assets.chucknorris.host")!, value: "Chuck Norris let the dogs out Chuck Norris wants some more", categories: [])
    }
}

extension Fact: Equatable {
    public static func == (lhs: Fact, rhs: Fact) -> Bool {
           return lhs.id == rhs.id
    }
}
