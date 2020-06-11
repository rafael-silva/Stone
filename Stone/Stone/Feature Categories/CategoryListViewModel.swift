import RxSwift
import RxCocoa

protocol CategoryListViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input : Input { get }
    var output : Output { get }
}

final class CategoryListViewModel:  CategoryListViewModelType {
    
    var input: CategoryListViewModel.Input
    var output: CategoryListViewModel.Output
    
    struct Input {
        let reload: PublishRelay<Void>
    }
    let reload: PublishRelay<Void>
    
    struct Output {
        let sectionItems: Driver<Item>
    }
    
    struct Item {
        let catogories: [String]
        let pastSearch: [String]
    }
    
     enum SectionType: String {
        case suggestions = "Suggestions"
        case pastSearches = "Past Searches"
    }
    
     struct Section {
        let type: SectionType
        let items: [String]
    }
    
    private var worker: CategoryListWorkerRemoteDataSource
    private let disposeBag = DisposeBag()
    
    init(worker: CategoryListWorkerRemoteDataSource) {
        self.worker = worker
        
        let reloadRelay = PublishRelay<Void>()
        let errorRelay = PublishRelay<String>()
        
        let sections: Driver<Item> = Observable
            .combineLatest(reloadRelay.asObservable(), worker.fetchCategories(), worker.fetchPastSearches())
            .map { ($0.1, $0.2) }
            .map { catogories, pastSearch in
                print(catogories)
                print(pastSearch)
                return Item(catogories: catogories, pastSearch: pastSearch)
        }
        .do(onError: { [errorRelay] error in
            errorRelay.accept((error as? ApiError)?.description ?? error.localizedDescription)
        })
        
        self.input = Input(reload: reloadRelay)
        self.output = Output(sectionItems: sections)

     }
    
}
