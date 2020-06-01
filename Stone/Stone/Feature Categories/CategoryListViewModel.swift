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
    
    struct Output {
        let categories: Driver<[FactCategory]>
        let pastSearches: Driver<[PastSearch]>
        var categoryDictionary: Driver<[String: Any]>

        var errorMessage: Driver<String>
    }
    
    private var worker: CategoryListWorkerRemoteDataSource
    private let disposeBag = DisposeBag()

    init(worker: CategoryListWorkerRemoteDataSource) {
        self.worker = worker
        
        let reloadRelay = PublishRelay<Void>()
        let errorRelay = PublishRelay<String>()
        var categoryDictionary = Driver<[String: Any]>.just([:])
        let dictionary = BehaviorRelay<[String: Any]>.init(value: [:])

        let categories: Driver<[FactCategory]> = reloadRelay
             .asObservable()
            .flatMap { return worker.fetchCategories() }
             .asDriver { (error) -> Driver<[FactCategory]> in
                 errorRelay.accept((error as? ApiError)?.description ?? error.localizedDescription)
                 return Driver.just([])
         }
         
         let pastSearches: Driver<[PastSearch]> = reloadRelay
                    .asObservable()
                    .flatMap{ return worker.fetchPastSearches() }
                    .asDriver { (error) -> Driver<[PastSearch]> in
                        errorRelay.accept((error as? ApiError)?.description ?? error.localizedDescription)
                        return Driver.just([])
                }

//        dictionary.accept(dictionary.value.merging(["Categories": categories]){ (_, new) in new })
//        dictionary.accept(dictionary.value.merging(["Past Search": pastSearches]){ (_, new) in new })
//        categoryDictionary = dictionary.asObservable().asSharedSequence(onErrorJustReturn: [:])

        dictionary.accept(["Suggestions": categories])

        self.input = Input(reload: reloadRelay)
        self.output = Output(categories: categories, pastSearches: pastSearches, categoryDictionary: dictionary.asDriver(),
                             errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
        
        updateData()
    }
    
    private func updateData() {
        let errorRelay = PublishRelay<String>()

        worker.updateLocalDataFromApi()
            .subscribe(onCompleted: {
            }, onError: { error in
                errorRelay.accept((error as? ApiError)?.description ?? error.localizedDescription)
            }).disposed(by: disposeBag)
       
        self.output.errorMessage = errorRelay.asDriver(onErrorJustReturn: "An error happened")
    }
    
}
