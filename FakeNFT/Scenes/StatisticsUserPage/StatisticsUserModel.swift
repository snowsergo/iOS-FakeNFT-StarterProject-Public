import Foundation

final class StatisticsUserPageModel {

    let defaultNetworkClient = DefaultNetworkClient()

    func getUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        let request = Request(endpoint: URL(string: defaultBaseUrl + "/users" + "/\(userId)"), httpMethod: .get)
        defaultNetworkClient.send(request: request, type: User.self, onResponse: completion)
    }
}
