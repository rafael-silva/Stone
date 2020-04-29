protocol FactListWorkerInput: class {
    var output: FactListWorkerOutput? { get set }
    func fetchFacts(term: String)
}

protocol FactListWorkerOutput: class {
    func workerFailed(error: String)
    func workerSucceeded(factList: [Fact])
}
