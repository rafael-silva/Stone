import RxSwift

final class FactListWorker: FactListWorkerInput {
    
    var output: FactListWorkerOutput?
    let disposeBag = DisposeBag()
    let api: APIFactsProtocol
    
    init(api: APIFactsProtocol = API()) {
        self.api = api
    }
    
    func fetchFacts(term: String) {
        api.getFacts(term: term)
            .observeOn(MainScheduler.instance)
            .retry(2)
            .subscribe(onNext: { response in
                let facts = response.result.map { Fact(output: $0) }
                self.output?.workerSucceeded(factList: facts)
            }, onError: { error in
                switch error {
                case ApiError.conflict:
                    self.output?.workerFailed(error: ApiError.conflict.description)
                case ApiError.forbidden:
                    self.output?.workerFailed(error: ApiError.forbidden.description)
                case ApiError.notFound:
                    self.output?.workerFailed(error: ApiError.notFound.description)
                default:
                    self.output?.workerFailed(error: "Unknown error: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
}
