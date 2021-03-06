import Quick
import Nimble
import RxTest
import RxSwift
import RxBlocking

@testable import Stone

private let expectedCategories = [FactCategory(category: "Category 1")]

class CategoryListWorkerTests: QuickSpec {
    
    override func spec() {
        
        var scheduler: TestScheduler!
        var sut_worker : CategoryListWorker!
        var apiSpy: ApiCategorySpy!
        
        describe("CategoriesWorker") {
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                apiSpy = ApiCategorySpy()
                sut_worker = CategoryListWorker(api: apiSpy)
            }
            
            describe("when 'fetcCategory' was called") {
                
                context("and the request was completed with a valid response") {
                    
                    it("then should return a response") {
                        apiSpy.response = CategoryPayload.mock()
                        
                        let observer = scheduler.createObserver([FactCategory].self)
                        
                        let disposable = sut_worker.fetch()
                            .asObservable()
                            .subscribe(observer)
                        
                        scheduler.scheduleAt(TestScheduler.Defaults.disposed, action: disposable.dispose)
                        scheduler.start()
                        
                        let newResponse = observer.events.first?.value.element
                        
                        expect(newResponse).to(equal(expectedCategories))
                    }
                }
                
                context("and the request was completed with error 500") {
                    
                    it("then should return error message") {
                        apiSpy.error = ApiError.internalServerError
                        
                        let errorMessage = scheduler.createObserver(String.self)
                        
                        let disposable = sut_worker.fetch()
                            .asObservable()
                            .subscribe(onNext: { _ in
                            }, onError: { error in
                                errorMessage.onError(error)
                            }
                        )
                        
                        scheduler.scheduleAt(TestScheduler.Defaults.disposed, action: disposable.dispose)
                        scheduler.start()
                        
                        let responseError = errorMessage.events.map { $0.value.error! as! ApiError}.first!
                        expect(responseError.description).to(equal("Internal server error."))
                        
                        expect(errorMessage.events.map { $0.value.error! as! ApiError}.first!) == ApiError.internalServerError
                    }
                }
                
                context("and the request was completed with error 409") {
                    
                    it("then should return error message") {
                        apiSpy.error = ApiError.conflict
                        
                        let errorMessage = scheduler.createObserver(String.self)
                        
                        let disposable = sut_worker.fetch()
                            .asObservable()
                            .subscribe(onNext: { _ in
                            }, onError: { error in
                                errorMessage.onError(error)
                            }
                        )
                        
                        scheduler.scheduleAt(TestScheduler.Defaults.disposed, action: disposable.dispose)
                        scheduler.start()
                        
                        let responseError = errorMessage.events.map { $0.value.error! as! ApiError}.first!
                        expect(responseError.description).to(equal("Conflict error."))
                    }
                }
                
                context("and the request was completed with error 404") {
                    
                    it("then should return error message") {
                        apiSpy.error = ApiError.notFound
                        
                        let errorMessage = scheduler.createObserver(String.self)
                        
                        let disposable = sut_worker.fetch()
                            .asObservable()
                            .subscribe(onNext: { _ in
                            }, onError: { error in
                                errorMessage.onError(error)
                            }
                        )
                        
                        scheduler.scheduleAt(TestScheduler.Defaults.disposed, action: disposable.dispose)
                        scheduler.start()
                        
                        let responseError = errorMessage.events.map { $0.value.error! as! ApiError}.first!
                        expect(responseError.description).to(equal("The not found failed."))
                    }
                }
                
                context("and the request was completed with error 403") {
                    
                    it("then should return error message") {
                        apiSpy.error = ApiError.forbidden
                        
                        let errorMessage = scheduler.createObserver(String.self)
                        
                        let disposable = sut_worker.fetch()
                            .asObservable()
                            .subscribe(onNext: { _ in
                            }, onError: { error in
                                errorMessage.onError(error)
                            }
                        )
                        
                        scheduler.scheduleAt(TestScheduler.Defaults.disposed, action: disposable.dispose)
                        scheduler.start()
                        
                        let responseError = errorMessage.events.map { $0.value.error! as! ApiError}.first!
                        expect(responseError.description).to(equal("Forbidden error."))
                    }
                }
                
                context("and the request was completed with a error") {
                    
                    it("then should return error message") {
                        apiSpy.error = ApiError.unknownedError("Unknowned error.")
                        
                        let errorMessage = scheduler.createObserver(String.self)
                        
                        let disposable = sut_worker.fetch()
                            .asObservable()
                            .subscribe(onNext: { _ in
                            }, onError: { error in
                                errorMessage.onError(error)
                            }
                        )
                        
                        scheduler.scheduleAt(TestScheduler.Defaults.disposed, action: disposable.dispose)
                        scheduler.start()
                        
                        let responseError = errorMessage.events.map { $0.value.error! as! ApiError}.first!
                        expect(responseError.description).to(equal("Unknowned error."))
                    }
                }
                
            }
        }
    }
    
}

final class ApiCategorySpy: APICategoryProtocol {
    
    var response: CategoryPayload? = nil
    var error: ApiError = ApiError.unknownedError("Unknowned error.")
    
    func getCategories() -> Observable<CategoryPayload> {
        if let response = response {
            return Observable.just(response)
        } else {
            return Observable.error(error)
        }
    }
    
}
