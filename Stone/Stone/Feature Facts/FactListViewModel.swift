import RxSwift
import RxCocoa

final class FactListViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        let reload: PublishRelay<Void>
        let textInput: BehaviorRelay<String?>
    }
    
    struct Output {
        let facts: Driver<[Fact]>
        let errorMessage: Driver<String>
    }
    
    
    private var worker: FactListWorkerDataSource
    private let disposeBag = DisposeBag()
    
    init(worker: FactListWorkerDataSource) {
        self.worker = worker
        
        let errorRelay = PublishRelay<String>()
        let reloadRelay = PublishRelay<Void>()
        let textRelay = BehaviorRelay<String?>(value: nil)
        
        let facts: Driver<[Fact]> = reloadRelay
            .asObservable()
            .flatMap({ return textRelay.asObservable() })
            .flatMap { (text) -> Observable<[Fact]> in
                guard let text = text else {
                    return Observable<[Fact]>.empty()
                }
                return worker.fetch(term: text)
        }
        .asDriver { (error) -> Driver<[Fact]> in
            errorRelay.accept((error as! ApiError).description)
            return Driver.just([])
        }
        
        self.input = Input(reload: reloadRelay, textInput: textRelay)
        self.output = Output(facts: facts,
                             errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
    }
}
