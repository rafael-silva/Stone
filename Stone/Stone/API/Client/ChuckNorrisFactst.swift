import RxSwift

protocol APIFactsProtocol: class {
    func getFacts(term: String) -> Observable<ResponsePayload>
    func getCategories() -> Observable<ResponsePayload>
}

extension API: APIFactsProtocol {

    func getFacts(term: String) -> Observable<ResponsePayload> {
        return API().request(ApiRouter.getFacts(term: term))
    }
    
    func getCategories() -> Observable<ResponsePayload> {
         return API().request(ApiRouter.getCategories)
     }
    
}
