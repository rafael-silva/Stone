import Foundation
import RealmSwift
import RxSwift
import Realm

final class RealmDataManager {
    
    //MARK: Properties
    
    private let realm: Realm?
    
    //MARK: Init
    
    init(_ realm: Realm?) {
        self.realm = realm
    }
}

extension RealmDataManager: DataManagerProtocol {
    
    func create<T>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws where T : Storable {
        guard let realm = realm, let model = model as? Object.Type else { throw RealmError.eitherRealmIsNilOrNotRealmSpecificModel }
        
        try realm.write  {
            let test = realm.create(model) as! T
            completion(test)
        }
    }
    
    func save(object: Storable) -> Completable {
        return Completable.create { observer in
            if let realm = self.realm, let object = object as? Object {
                do {
                    try realm.write {
                        realm.add(object, update: .modified)
                    }
                    observer(.completed)
                    
                } catch let error as NSError {
                    observer(.error(error))
                }
            } else  {
                observer(.error(RealmError.eitherRealmIsNilOrNotRealmSpecificModel))
            }
            return Disposables.create()
        }
    }
    
    func update(object: Storable) -> Completable {
        return Completable.create { observer in
            if let realm = self.realm, let object = object as? Object {
                do {
                    try realm.write {
                        realm.add(object, update: .all)
                    }
                    observer(.completed)
                    
                } catch let error as NSError {
                    observer(.error(error))
                }
            } else  {
                observer(.error(RealmError.eitherRealmIsNilOrNotRealmSpecificModel))
            }
            return Disposables.create()
        }
    }
    
    func delete(object: Storable) -> Completable {
        return Completable.create { observer in
            if let realm = self.realm, let object = object as? Object {
                do {
                    try realm.write {
                        realm.delete(object)
                    }
                    observer(.completed)
                    
                } catch let error as NSError {
                    observer(.error(error))
                }
            } else {
                observer(.error(RealmError.eitherRealmIsNilOrNotRealmSpecificModel))
            }
            return Disposables.create()
        }
    }
    
    func deleteAll<T>(_ object: T.Type) -> Completable where T : Storable {
        return Completable.create { observer in
            if let realm = self.realm, let object = object as? Object.Type {
                do {
                    try realm.write {
                        let objects = realm.objects(object)
                        for object in objects {
                            realm.delete(object)
                        }
                    }
                    observer(.completed)
                } catch let error as NSError {
                    observer(.error(error))
                }
            } else  {
                observer(.error(RealmError.eitherRealmIsNilOrNotRealmSpecificModel))
            }
            return Disposables.create()
        }
    }
    
    func fetch<T: Storable>(_ object: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> Observable<[T]> {
        return Observable<[T]>.create { observer in
            if let realm = self.realm, let model = object as? Object.Type {
                var objects = realm.objects(model)
                
                if let predicate = predicate {
                    objects = objects.filter(predicate)
                }
                
                if let sorted = sorted {
                    objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
                }
                observer.onNext(objects.compactMap { $0 as? T })
                observer.onCompleted()
            } else {
                observer.onError(RealmError.eitherRealmIsNilOrNotRealmSpecificModel)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func fetchById<T>(_ id: Int, _ object: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> Observable<T?> where T : Storable {
        return Observable<T?>.create { observer in
            if let realm = self.realm, let object = object as? Object.Type {
                let object = realm.object(ofType: object, forPrimaryKey: id) as? T
                observer.onNext(object)
                observer.onCompleted()
            } else {
                observer.onError(RealmError.eitherRealmIsNilOrNotRealmSpecificModel)
            }
            return Disposables.create()
        }
    }
    
    func objects<T>(ofType type: T.Type) -> Observable<[T]> where T: Object {
        return Observable
            .from(optional: self.realm)
            .objects(type)
    }
    
}
