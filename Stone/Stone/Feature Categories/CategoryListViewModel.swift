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
        var categories: Driver<[FactCategory]>
        var errorMessage: Driver<String>
    }
    
    private var worker: CategoryListWorkerRemoteDataSource
    private let reloadRelay = PublishRelay<Void>()
    private let errorRelay = PublishRelay<String>()
    private var categories = Driver<[FactCategory]>.just([])
    private let disposeBag = DisposeBag()

    init(worker: CategoryListWorkerRemoteDataSource) {
        self.worker = worker
        
        self.input = Input(reload: reloadRelay)
        self.output = Output(categories: categories,
                             errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
        
        updateData()
        loadData()
    }
    
    private func updateData() {
        worker.updateLocalDataFromApi()
            .subscribe(onCompleted: {
            }, onError: { error in
                self.errorRelay.accept((error as? ApiError)?.description ?? error.localizedDescription)
            }).disposed(by: disposeBag)
       
        self.output.errorMessage = errorRelay.asDriver(onErrorJustReturn: "An error happened")
    }
    
    private func loadData() {
        categories = reloadRelay
            .asObservable()
            .flatMap{ return self.worker.fetch() }
            .asDriver { (error) -> Driver<[FactCategory]> in
                self.errorRelay.accept((error as? ApiError)?.description ?? error.localizedDescription)
                return Driver.just([])
        }
        
        self.output.categories = categories
        self.output.errorMessage = errorRelay.asDriver(onErrorJustReturn: "An error happened")
    }
}
