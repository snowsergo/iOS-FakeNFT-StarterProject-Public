import Foundation

final class StatisticsUserPageViewModel {
    private let model: StatisticsUserPageModel

    var onChange: (() -> Void)?

    private(set) var user: User? {
        didSet {
            onChange?()
        }
    }

    init(model: StatisticsUserPageModel) {
        self.model = model
    }

    func getUser(userId: String) {
        model.getUser(userId: userId) { [weak self] result in
              guard let self = self else { return }
              DispatchQueue.main.async {
                  switch result {
                  case .success(let user):
                      self.user = user
                  case .failure(let error):
                      print("Error: \(error)")
                      self.user = nil
                  }
              }
          }
    }
}
