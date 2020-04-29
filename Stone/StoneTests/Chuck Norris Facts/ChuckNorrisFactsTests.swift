import XCTest
import RxTest
import RxSwift
import RxBlocking

@testable import Stone

class ChuckNorrisFactsTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    fileprivate var worker: FactListWorkerInputSpy!
    fileprivate var api : APIFactsSpy!
    
    override func setUp() {
        super.setUp()
        
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.api = APIFactsSpy()
        self.worker = FactListWorkerInputSpy()
        
    }
    
    override func tearDown() {
        self.api = nil
        super.tearDown()
    }
    
    func testBlocking(){
        let observableToTest = Observable.of(10, 20, 30)
        do{
            let result = try observableToTest.toBlocking().first()
            XCTAssertEqual(result, 10)
        } catch {
        }
    }
    
    func testFetchWithError() {
        // create scheduler
        let response = scheduler.createObserver(ResponsePayload.self)
        let errorMessage = scheduler.createObserver(String.self)
        
        // giving a service with no currencies
        api.response = nil
    }
    
}

private class APIFactsSpy: APIFactsProtocol {
    
    var response: ResponsePayload?
    
    func getFacts(term: String) -> Observable<ResponsePayload> {
        if let response = response {
            return Observable.just(response)
        } else {
            return Observable.error(ApiError.notFound)
        }
    }
    
}


fileprivate class FactListWorkerInputSpy: FactListWorkerInput {
    
    var output: FactListWorkerOutput?
    
    func fetchFacts(term: String) {
        
    }
}

fileprivate class FactListWorkerOutputSpy: FactListWorkerOutput {
    
    var errorPassed: String?
    var factListPassed: [Fact]?
    
    func workerFailed(error: String) {
        errorPassed = error
    }
    
    func workerSucceeded(factList: [Fact]) {
        factListPassed = factList
    }
}


let expectedfacts: [ResponsePayload.FactPayload] =
    [ResponsePayload.FactPayload(created_at: "2020-01-05 13:42:18.823766",
                                 icon_url: URL(fileURLWithPath: "https://assets.chucknorris.host/img/avatar/chuck-norris.png"),
                                 id: "13dfd2342352d",
                                 updated_at: "2020-01-05 13:42:18.823766",
                                 url: URL(fileURLWithPath: "https://assets.chucknorris.host/img/avatar/chuck-norris.png"),
                                 value: "Chuck Norris let the dogs out Chuck Norris wants some more",
                                 categories: [])]

let expectedResponse: ResponsePayload = ResponsePayload(total: 308, result: expectedfacts)

