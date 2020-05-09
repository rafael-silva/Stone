import RxSwift

protocol CategoriesWorkerDataSource: class {
    func fetch() -> Observable<[FactCategory]>
}

final class CategoriestWorker: CategoriesWorkerDataSource {
    
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
