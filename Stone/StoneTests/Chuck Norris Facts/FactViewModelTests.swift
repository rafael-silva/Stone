import XCTest
import RxTest
import RxSwift
import RxBlocking

@testable import Stone

private let expectedfacts: [Fact] =
    [Fact(createdAt: "2020-01-05 13:42:18.823766",
          iconUrl: URL(fileURLWithPath: "https://assets.chucknorris.host/img/avatar/chuck-norris.png"),
          id: "13dfd2342352d",
          updatedAt: "2020-01-05 13:42:18.823766",
          url: URL(fileURLWithPath: "https://assets.chucknorris.host/img/avatar/chuck-norris.png"),
          value: "Chuck Norris let the dogs out Chuck Norris wants some more",
          categories: [])]


class FactViewModelTests: XCTestCase {
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var sut_viewModel : FactListViewModel!
    fileprivate var workerSpy: FactListWorkerSpy!
    
    override func setUp() {
        super.setUp()
        
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.workerSpy = FactListWorkerSpy()
        self.sut_viewModel = FactListViewModel(worker: workerSpy)
        
    }
    
    override func tearDown() {
        self.sut_viewModel = nil
        self.workerSpy = nil
        
        super.tearDown()
    }
    
    func testFetchWithResponseValue() {
        
        let facts = scheduler.createObserver([Fact].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.facts = [Fact.mock()]
        
        sut_viewModel.input.textInput.accept("car")
        
        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.facts
            .drive(facts)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(facts.events, [.next(10, expectedfacts)])
    }
    
    func testFetchWithNoResponseValue() {
        
        let facts = scheduler.createObserver([Fact].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.facts = nil
        sut_viewModel.input.textInput.accept("car")
        
        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.facts
            .drive(facts)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(facts.events, [.next(10, []), .completed(10)])
    }
    
    func testFetchWithUnknownedError() {
        
        let facts = scheduler.createObserver([Fact].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.error = ApiError.unknownedError("Unknowned error.")
        sut_viewModel.input.textInput.accept("car")
        
        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.facts
            .drive(facts)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Unknowned error.")])
    }
    
    func testFetchWithError500() {
        
        let facts = scheduler.createObserver([Fact].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.error = ApiError.internalServerError
        sut_viewModel.input.textInput.accept("car")
        
        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.facts
            .drive(facts)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Internal server error.")])
    }
    
    func testFetchWithError409() {
        
        let facts = scheduler.createObserver([Fact].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.error = ApiError.conflict
        sut_viewModel.input.textInput.accept("car")
        
        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.facts
            .drive(facts)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Conflict error.")])
    }
    
    func testFetchWithError404() {
        
        let facts = scheduler.createObserver([Fact].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.error = ApiError.notFound
        sut_viewModel.input.textInput.accept("car")
        
        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.facts
            .drive(facts)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "The not found failed.")])
    }
    
    func testFetchWithError403() {
        
        let facts = scheduler.createObserver([Fact].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.error = ApiError.forbidden
        sut_viewModel.input.textInput.accept("car")
        
        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.facts
            .drive(facts)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Forbidden error.")])
    }
}

private class FactListWorkerSpy: FactListWorkerDataSource {
    
    var facts: [Fact]?
    var error: ApiError = ApiError.forbidden
    
    func fetch(term: String) -> Observable<[Fact]> {
        if let facts = facts {
            return Observable.just(facts)
        } else {
            return Observable.error(error)
        }
    }
}
