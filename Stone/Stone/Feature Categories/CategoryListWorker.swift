import RxSwift
import RealmSwift

protocol CategoryListWorkerRemoteDataSource: class {
    func fetchCategories() -> Observable<[FactCategory]>
    func fetchPastSearches() -> Observable<[PastSearch]>
    func updateLocalDataFromApi() -> Completable
}

final class CategoryListWorker: CategoryListWorkerRemoteDataSource {
    
    private let api: APICategoryProtocol
    private let dbManager: DataManagerProtocol
    
    init(api: APICategoryProtocol = API(), dbManager: DataManagerProtocol = RealmDataManager(RealmProvider.default)) {
        self.api = api
        self.dbManager = dbManager
    }
    
    func fetchCategories() -> Observable<[FactCategory]> {
        return self.dbManager.objects(CategoryPayload.self)
            .observeOn(MainScheduler.instance)
            .map { $0.first?.category.map { FactCategory(category: $0) } ?? []}
    }
    
    func fetchPastSearches() -> Observable<[PastSearch]> {
        return self.dbManager.objects(PastSearchPayload.self)
            .observeOn(MainScheduler.instance)
            .map{ $0.map { PastSearch(term: $0.term)}}
    }
    
    func updateLocalDataFromApi() -> Completable {
        return self.api.getCategories()
            .observeOn(MainScheduler.instance)
            .flatMap({ payload in
                self.dbManager.update(object: payload)
            }).asCompletable()
    }
}
