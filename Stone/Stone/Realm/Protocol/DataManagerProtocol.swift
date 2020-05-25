import Foundation
import RxSwift
import RealmSwift

protocol DataManagerProtocol {
    
    /// Create new object
    /// - Parameters:
    ///   - model: model to be persisted
    ///   - completion: completion that will be called after the operation be concluded
    func create<T: Storable>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws
    
    /// Save object
    /// - Parameter object: object to be saved
    func save(object: Storable) -> Completable
    
    /// Update object
    /// - Parameter object: update all object
    func update(object: Storable) -> Completable
    
    /// Delete object
    /// - Parameter object: object to be deleted
    func delete(object: Storable) -> Completable
    
    /// Delete all data from a specific model
    /// - Parameter model: model type to be deleted
    func deleteAll<T: Storable>(_ modal: T.Type) -> Completable
    
    /// Fetch all data from a model
    /// - Parameters:
    ///   - object: object type
    ///   - predicate: query predicate to filter result
    ///   - sorted: sort type
    ///   - completion: completion that will be called after the operation be concluded
    func fetch<T: Storable>(_ object: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> Observable<[T]>
   
    /// Fetch value by id from model
    /// - Parameters:
    ///   - id: id value
    ///   - object: object type
    ///   - completion: completion that will be called after the operation be concluded
    func fetchById<T: Storable>(_ id: Int, _ object: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> Observable<T?>

    /// Fetch model after operations called on Realm
    /// - Parameters:
    ///   - model: model type
    ///   - completion: completion that will be called after the operation be concluded
    func objects<T>(_ model: T.Type) -> Observable<[T]> where T: Object
}
