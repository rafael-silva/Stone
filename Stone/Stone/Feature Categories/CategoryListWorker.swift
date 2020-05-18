import RxSwift

protocol CategoryListWorkerRemoteDataSource: class {
    func fetch() -> Observable<[FactCategory]>
}

final class CategoryListWorker: CategoryListWorkerRemoteDataSource {
    
    private let api: APICategoryProtocol
    
    init(api: APICategoryProtocol = API()) {
        self.api = api
    }
    
    func fetch() -> Observable<[FactCategory]> {
        return self.api.getCategories()
            .observeOn(MainScheduler.instance)
            .map({  payload in
                    payload.category.map({ FactCategory(category: $0) })
        })
    }
    
}
