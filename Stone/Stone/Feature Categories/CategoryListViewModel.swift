import RxSwift
import RxCocoa

protocol CategoryListViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

final class CategoryListViewModel:  CategoryListViewModelType {
    
    var input: CategoryListViewModel.Input
    var output: CategoryListViewModel.Output
    var isFirst: Bool = true
    
    struct Input {
        let reload: PublishRelay<Void>
    }
    
    struct Output {
        let sectionItems: Driver<Item>
        var errorMessage: Driver<String>
    }
    
    struct Item {
        let catogories: [String]
        var pastSearch: [String]
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
                return Item(catogories: catogories, pastSearch: pastSearch)
        }
        .do(onError: { [errorRelay] error in
            errorRelay.accept((error as? ApiError)?.description ?? error.localizedDescription)
        })
        .asDriver(onErrorJustReturn: Item(catogories: [], pastSearch: []))
        
        self.input = Input(reload: reloadRelay)
        self.output = Output(sectionItems: sections,
                             errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
        
        if isFirst {
            self.updateData()
        }
    }
    
    private func updateData() {
        let errorRelay = PublishRelay<String>()
        
        worker.updateLocalDataFromApi()
            .subscribe(onCompleted: {
                self.isFirst = false
            }, onError: { error in
                errorRelay.accept((error as? ApiError)?.description ?? error.localizedDescription)
            }).disposed(by: disposeBag)
        
        self.output.errorMessage = errorRelay.asDriver(onErrorJustReturn: "An error happened")
    }
}
