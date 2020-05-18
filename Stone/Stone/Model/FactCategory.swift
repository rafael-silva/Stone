import Foundation

struct FactCategory {
    let category: String
}

extension FactCategory: MockProtocol {
    static func mock() -> FactCategory {
        return FactCategory(category: "Category")
    }
}

extension FactCategory: Equatable {
    public static func == (lhs: FactCategory, rhs: FactCategory) -> Bool {
           return lhs.category == rhs.category
    }
}
