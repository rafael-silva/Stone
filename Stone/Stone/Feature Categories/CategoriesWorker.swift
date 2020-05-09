import RxSwift

protocol CategoriesWorkerDataSource: class {
    func fetch() -> Observable<[Category]>
}

final class CategoriestWorker: CategoriesWorkerDataSource {
    
    private let api: APICategoryProtocol
    
    init(api: APICategoryProtocol = API()) {
        self.api = api
    }
    
    func fetch() -> Observable<[Category]> {
        return self.api.getCategories()
            .observeOn(MainScheduler.instance)
            .map({  payload in
                    payload.category.map({ Category(category: $0) })
        })
    }
    
}
