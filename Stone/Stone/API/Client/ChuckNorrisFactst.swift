import RxSwift

protocol APIFactsProtocol: class {
    func getFacts(term: String) -> Observable<ResponsePayload>
}

extension API: APIFactsProtocol {

    func getFacts(term: String) -> Observable<ResponsePayload> {
        return API().request(ApiRouter.getFacts(term: term))
    }
    
}
