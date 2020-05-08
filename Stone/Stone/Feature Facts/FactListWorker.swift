import RxSwift

protocol FactListWorkerDataSource: class {
    func fetch(term: String) -> Observable<[Fact]>
}

final class FactListWorker: FactListWorkerDataSource {
    
    private let api: APIFactsProtocol
    
    init(api: APIFactsProtocol = API()) {
        self.api = api
    }
    
    func fetch(term: String) -> Observable<[Fact]> {
        return self.api.getFacts(term: term)
            .observeOn(MainScheduler.instance)
            .retry(2)
            .map({  payload in
                payload.result.map({ Fact(output: $0) })
            })
    }
}
