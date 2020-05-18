import XCTest
import RxTest
import RxSwift
import RxBlocking

@testable import Stone

private let expectedCategories = [FactCategory(category: "Category")]

class CategoryListViewModelTests: XCTestCase {
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var sut_viewModel : CategoryListViewModel!
    fileprivate var workerSpy: CategoriesWorkerSpy!
    
    override func setUp() {
        super.setUp()
        
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.workerSpy = CategoriesWorkerSpy()
        self.sut_viewModel = CategoryListViewModel(worker: workerSpy)
        
    }
    
    override func tearDown() {
        self.sut_viewModel = nil
        self.workerSpy = nil
        
        super.tearDown()
    }
    
    func testFetchWithResponseValue() {
        
        let categories = scheduler.createObserver([FactCategory].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.categories = [FactCategory.mock()]
        
        sut_viewModel.input.reload.accept(())
        
        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.categories
            .drive(categories)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(categories.events, [.next(10, expectedCategories)])
    }
    
    func testFetchWithNoResponseValue() {
        
        let categories = scheduler.createObserver([FactCategory].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.categories = nil
        sut_viewModel.input.reload.accept(())
        
        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.categories
            .drive(categories)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(categories.events, [.next(10, []), .completed(10)])
    }
    
    func testFetchWithUnknownedError() {
        
        let categories = scheduler.createObserver([FactCategory].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.error = ApiError.unknownedError("Unknowned error.")
        sut_viewModel.input.reload.accept(())

        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.categories
            .drive(categories)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Unknowned error.")])
    }
    
    func testFetchWithError500() {
        
        let categories = scheduler.createObserver([FactCategory].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.error = ApiError.internalServerError
        sut_viewModel.input.reload.accept(())

        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.categories
            .drive(categories)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Internal server error.")])
    }
    
    func testFetchWithError409() {
        
        let categories = scheduler.createObserver([FactCategory].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.error = ApiError.conflict
        sut_viewModel.input.reload.accept(())
        
        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.categories
            .drive(categories)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Conflict error.")])
    }
    
    func testFetchWithError404() {
        
        let categories = scheduler.createObserver([FactCategory].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.error = ApiError.notFound
        sut_viewModel.input.reload.accept(())

        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.categories
            .drive(categories)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "The not found failed.")])
    }
    
    func testFetchWithError403() {
        
        let categories = scheduler.createObserver([FactCategory].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        workerSpy.error = ApiError.forbidden
        sut_viewModel.input.reload.accept(())

        sut_viewModel.output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        sut_viewModel.output.categories
            .drive(categories)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut_viewModel.input.reload)
            .disposed(by: disposeBag)
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [.next(10, "Forbidden error.")])
    }
}

private class CategoriesWorkerSpy: CategoryListWorkerRemoteDataSource {

    var categories: [FactCategory]?
    var error: ApiError = ApiError.unknownedError("")
    
    func fetch() -> Observable<[FactCategory]> {
        if let categories = categories {
            return Observable.just(categories)
        } else {
            return Observable.error(error)
        }
    }
}

