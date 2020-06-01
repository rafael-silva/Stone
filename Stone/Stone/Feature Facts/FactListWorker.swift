import RxSwift

protocol FactListWorkerDataSource: class {
    func fetch(term: String) -> Observable<[Fact]>
    func saveSearch(text: String) -> Completable
}

final class FactListWorker: FactListWorkerDataSource {
    
    private let api: APIFactsProtocol
    private let dbManager: DataManagerProtocol

    init(api: APIFactsProtocol = API(), dbManager: DataManagerProtocol = RealmDataManager(RealmProvider.default)) {
        self.api = api
        self.dbManager = dbManager
    }
    
    func fetch(term: String) -> Observable<[Fact]> {
        return self.api.getFacts(term: term)
            .observeOn(MainScheduler.instance)
            .retry(2)
            .map({  payload in
                payload.result.map({ Fact(output: $0) })
            })
    }
    
    func saveSearch(text: String) -> Completable {
        return self.dbManager.save(object: PastSearchPayload.init(term: text))            .observeOn(MainScheduler.instance)
    }
    
}
