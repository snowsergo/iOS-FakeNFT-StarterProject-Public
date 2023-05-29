import Foundation

enum SortType: String {
    case byName = "BYNAME"
    case byCount = "BYCOUNT"
}

final class StatisticsPageViewModel {
    var onChange: (() -> Void)?

    private(set) var users: [User] = [] {
        didSet {
            onChange?()
        }
    }
    var sortType: SortType? {
        didSet {
            users = getSorted(users: users)
            onChange?()
        }
    }

    let defaultNetworkClient = DefaultNetworkClient()
    func getUsers(showLoader: @escaping (_ active: Bool) -> Void ) {
        showLoader(true)
        let request = Request(endpoint: URL(string: defaultBaseUrl + "/users"), httpMethod: .get)

        let fulfillCompletionOnMainThread: (Result<[User], Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            showLoader(false)
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = self.getSorted(users: users)
                case .failure:
                    print("___failure")
                }
            }
        }
        defaultNetworkClient.send(request: request, type: [User].self, onResponse: fulfillCompletionOnMainThread)
    }

    private func getSorted(users: [User]) -> [User] {
        guard let sortType = sortType else {
            return users
        }
        switch sortType {
        case .byName:
            return users.sorted { $0.name < $1.name }
        case .byCount:
            return users.sorted { $0.nfts.count > $1.nfts.count }
        }
    }

    func setSortedByName() {
        sortType = .byName
    }

    func setSortedByCount() {
        sortType = .byCount
    }
}
