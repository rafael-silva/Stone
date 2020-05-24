import RxSwift
import RealmSwift

protocol CategoryListWorkerRemoteDataSource: class {
    func fetch() -> Observable<[FactCategory]>
    func updateLocalDataFromApi() -> Completable
}

final class CategoryListWorker: CategoryListWorkerRemoteDataSource {
    
    private let api: APICategoryProtocol
    private let dbManager: DataManagerProtocol
    
    init(api: APICategoryProtocol = API(), dbManager: DataManagerProtocol = RealmDataManager(RealmProvider.default)) {
        self.api = api
        self.dbManager = dbManager
    }
    
    func fetch() -> Observable<[FactCategory]> {
        return self.dbManager.objects(ofType: CategoryPayload.self)
            .observeOn(MainScheduler.instance)
            .map { $0.first?.category.map { FactCategory(category: $0) } ?? []}
    }
    
    func updateLocalDataFromApi() -> Completable {
        return self.api.getCategories()
            .observeOn(MainScheduler.instance)
            .flatMap({ payload in
                return self.dbManager.save(object: payload)
                    .observeOn(MainScheduler.instance)
            }).asCompletable()
    }

}
