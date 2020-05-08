import Quick
import Nimble
import RxTest
import RxSwift
import RxBlocking

@testable import Stone

private let expectedfacts: [Fact] = [Fact(createdAt: "2020-01-05 13:42:18.823766",
      iconUrl: URL(fileURLWithPath: "https://assets.chucknorris.host/img/avatar/chuck-norris.png"),
      id: "13dfd2342352d",
      updatedAt: "2020-01-05 13:42:18.823766",
      url: URL(fileURLWithPath: "https://assets.chucknorris.host/img/avatar/chuck-norris.png"),
      value: "Chuck Norris let the dogs out Chuck Norris wants some more",
      categories: [])]

class FactListWorkerTest: QuickSpec {
    
    override func spec() {
        
        var scheduler: TestScheduler!
        var sut_worker : FactListWorker!
        var apiSpy: ApiFactsSpy!
        
        describe("FactListWorker") {
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                apiSpy = ApiFactsSpy()
                sut_worker = FactListWorker(api: apiSpy)
            }
            
            describe("when 'fetcFacts' was called") {
                
                context("and the request was completed with a valid response") {
                    
                    it("then should return a response") {
                        apiSpy.response = ResponsePayload.mock()
                        
                        let observer = scheduler.createObserver([Fact].self)
                        
                        let disposable = sut_worker.fetch(term: "Car")
                            .asObservable()
                            .subscribe(observer)
                        
                        scheduler.scheduleAt(TestScheduler.Defaults.disposed, action: disposable.dispose)
                        scheduler.start()
                        
                        let newResponse = observer.events.first?.value.element
                        
                        expect(newResponse).to(equal(expectedfacts))
                    }
                }
                
            }
            
            context("and the request was completed with error 500") {
                
                it("then should return error message") {
                    apiSpy.error = ApiError.internalServerError
                    
                    let errorMessage = scheduler.createObserver(String.self)
                    
                    let disposable = sut_worker.fetch(term: "Car")
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
                    
                    let disposable = sut_worker.fetch(term: "Car")
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
                    
                    let disposable = sut_worker.fetch(term: "Car")
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
                    
                    let disposable = sut_worker.fetch(term: "Car")
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
                    
                    let disposable = sut_worker.fetch(term: "Car")
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

final class ApiFactsSpy: APIFactsProtocol {
    
    var response: ResponsePayload? = nil
    var error: ApiError = ApiError.unknownedError("Unknowned error.")
    var getFactsCalled: Bool?
    
    func getFacts(term: String) -> Observable<ResponsePayload> {
        getFactsCalled = true
        if let response = response {
            return Observable.just(response)
        } else {
            return Observable.error(error)
        }
    }
    
}
