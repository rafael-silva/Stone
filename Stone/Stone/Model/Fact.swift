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
