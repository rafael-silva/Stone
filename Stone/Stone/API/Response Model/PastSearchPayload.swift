import RealmSwift

@objcMembers
final class PastSearchPayload: Object {
    dynamic var term: String = ""

    convenience init(term: String) {
        self.init()
        
        self.term = term
    }
}
