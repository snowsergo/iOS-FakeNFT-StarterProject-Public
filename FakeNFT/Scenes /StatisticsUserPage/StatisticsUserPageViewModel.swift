import Foundation

final class StatisticsUserPageViewModel {
    var onChange: (() -> Void)?

    private(set) var user: User? {
        didSet {
            onChange?()
        }
    }

    let defaultNetworkClient = DefaultNetworkClient()
    func getUser(userId: String) {
        let request = Request(endpoint: URL(string: defaultBaseUrl + "/users" + "/\(userId)"), httpMethod: .get)
        let fulfillCompletionOnMainThread: (Result<User, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure:
                    print("___failure")
                }
            }
        }
        defaultNetworkClient.send(request: request, type: User.self, onResponse: fulfillCompletionOnMainThread)
    }
}
