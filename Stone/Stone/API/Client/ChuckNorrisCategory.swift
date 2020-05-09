import RxSwift

protocol APICategoryProtocol: class {
    func getCategories() -> Observable<CategoryPayload>
}

extension API: APICategoryProtocol {
    
    func getCategories() -> Observable<CategoryPayload> {
        return API().request(ApiRouter.getCategories)
     }
    
}
