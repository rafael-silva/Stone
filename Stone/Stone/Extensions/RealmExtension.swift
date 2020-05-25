import RxSwift
import RealmSwift

extension ObservableType where Element == Realm {
    
    func objects<T>(_ type: T.Type, _ completion: @escaping (Results<T>) -> (Results<T>) = { $0 }) -> Observable<[T]> where T: Object {
        return flatMap { realm in
            return Observable.create { observer in
                let token: NotificationToken?
                let results = completion(realm.objects(type))
                
                token = results.observe { change in
                    switch change {
                    case .initial(let collection):
                        observer.onNext(collection.map { $0 })
                    case .update(let collection, _, _, _):
                        observer.onNext(collection.map { $0 })
                    case .error(let error):
                        observer.on(.error(error))
                    }
                }
                
                return Disposables.create {
                    token?.invalidate()
                }
            }
        }
    }
}
