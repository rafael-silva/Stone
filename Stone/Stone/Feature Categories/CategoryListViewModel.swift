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
        let errorMessage: Driver<String>
    }
    
    private var worker: CategoryListWorkerRemoteDataSource
    private let disposeBag = DisposeBag()
    
    init(worker: CategoryListWorkerRemoteDataSource) {
        self.worker = worker
        
        worker.updateLocalDataFromApi()
            .subscribe { event in
                print(event)
        }.disposed(by: disposeBag)

        
        let errorRelay = PublishRelay<String>()
        let reloadRelay = PublishRelay<Void>()
        
        let categories: Driver<[FactCategory]> = reloadRelay
            .asObservable()
            .flatMap{ return worker.fetch() }.asDriver { (error) -> Driver<[FactCategory]> in
                errorRelay.accept((error as? ApiError)?.description ?? error.localizedDescription)
                return Driver.just([])
        }
        
        self.input = Input(reload: reloadRelay)
        self.output = Output(categories: categories,
                             errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
    }

}
