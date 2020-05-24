import Foundation
import RealmSwift


@objcMembers
final class CategoryPayload: Object {
    dynamic var id = 0
    dynamic var category = List<String>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension CategoryPayload: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.singleValueContainer()
        category = try values.decode(List<String>.self)
    }
}

extension CategoryPayload: MockProtocol {
    static func mock() -> CategoryPayload {
        return CategoryPayload(value: ["Category 1"])
    }
}
