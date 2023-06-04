import Foundation

enum SortType: String {
    case byName = "BYNAME"
    case byCount = "BYCOUNT"
}

final class StatisticsPageViewModel {
    private let model: StatisticsPageModel

    var onChange: (() -> Void)?

    private(set) var users: [User] = [] {
        didSet {
            onChange?()
        }
    }
    var sortType: SortType? {
        didSet {
            sortUsers()
            onChange?()
        }
    }

    init(model: StatisticsPageModel) {
        self.model = model
    }

    func getUsers(showLoader: @escaping (_ active: Bool) -> Void) {
        showLoader(true)

        model.getUsers { [weak self] result in
            guard let self = self else { return }
            showLoader(false)
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                    self.sortUsers()
                case .failure(let error):
                    print("Error: \(error)")
                    self.users = []
                }
            }
        }
    }

    private func getSorted(users: [User], by sortType: SortType) -> [User] {
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

    private func sortUsers() {
        guard let sortType = sortType else {
            return
        }
        users = getSorted(users: users, by: sortType)
    }
}
