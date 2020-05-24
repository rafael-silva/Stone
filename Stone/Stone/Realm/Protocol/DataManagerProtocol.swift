import Foundation
import RxSwift
import RealmSwift

protocol DataManagerProtocol {
    
    func create<T: Storable>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws
    func save(object: Storable) -> Completable
    func update(object: Storable) -> Completable
    func delete(object: Storable) -> Completable 
    func deleteAll<T: Storable>(_ object: T.Type) -> Completable
    func fetch<T: Storable>(_ object: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> Observable<[T]>
    func fetchById<T: Storable>(_ id: Int, _ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> Observable<T?>

    func objects<T>(ofType type: T.Type) -> Observable<[T]> where T: Object
}
