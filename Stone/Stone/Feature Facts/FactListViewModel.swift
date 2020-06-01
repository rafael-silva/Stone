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
        var facts: Driver<[Fact]>
        var errorMessage: Driver<String>
    }
    
    private var worker: FactListWorkerDataSource
    private let reloadRelay = PublishRelay<Void>()
    private let errorRelay = PublishRelay<String>()
    private let textRelay = BehaviorRelay<String?>(value: nil)
    private var facts = Driver<[Fact]>.just([])
    private let disposeBag = DisposeBag()
    
    init(worker: FactListWorkerDataSource) {
        self.worker = worker
        
        self.input = Input(reload: reloadRelay, textInput: textRelay)
        self.output = Output(facts: facts,
                             errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
        seatchFacts()
        saveSearch()
    }
    
    private func seatchFacts() {
        facts = self.textRelay
            .asObservable()
            .flatMap{ (text) -> Observable<[Fact]> in
                guard let text = text else {
                    return Observable<[Fact]>.empty()
                }
                return self.worker.fetch(term: text)
        }.asDriver { (error) -> Driver<[Fact]> in
            self.errorRelay.accept((error as? ApiError)?.description ?? "An error happened")
            return Driver.just([])
        }
        
        self.output.facts = facts
        self.output.errorMessage = errorRelay.asDriver(onErrorJustReturn: "An error happened")
    }
    
    private func saveSearch() {
        textRelay.subscribe(onNext: { text in
            guard let text = text else { return }
            self.worker.saveSearch(text: text)
                .subscribe(onError: { error in
                    self.errorRelay.accept(error.localizedDescription)
                }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        self.output.errorMessage = errorRelay.asDriver(onErrorJustReturn: "An error happened")
        
    }
}
