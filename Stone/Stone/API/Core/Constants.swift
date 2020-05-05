struct Constants {
    
    static let baseUrl = "https://api.chucknorris.io/jokes"
    
    struct Parameters {
        static let query = "query"
    }
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
}
