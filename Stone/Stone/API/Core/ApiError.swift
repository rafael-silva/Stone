enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
    case unknownedError(String)    //Status code 500

    var description: String {
        switch self {
        case .forbidden:
            return "Forbidden error."
        case .notFound:
            return "The not found failed."
        case .conflict:
            return "Conflict error."
        case .internalServerError:
            return "Internal server error."
        case .unknownedError(let error):
            return error
        }
    }
}

extension ApiError: Equatable {
    static func ==(lhs: ApiError, rhs: ApiError) -> Bool {
        return (lhs.description.isEqual(rhs.description))
    }
}
