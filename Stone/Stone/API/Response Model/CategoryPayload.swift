import Foundation

struct CategoryPayload {
    let category: [String]
}

extension CategoryPayload: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        category = try values.decode([String].self)
    }
}

extension CategoryPayload: MockProtocol {
    static func mock() -> CategoryPayload {
        return CategoryPayload(category: ["Category 1", "Category 2", "Category 3", "Category 4"])
    }
}
