import Foundation

struct UpdateProfileRequest: NetworkRequest {
    var httpMethod: HttpMethod = .put
    var httpBody: Data?
    var endpoint: URL?

    init(profile: ProfileModel) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/profile/\(profile.id)") else { return }
        self.endpoint = endpoint

        let encoder = JSONEncoder()
        httpBody = try! encoder.encode(profile)
    }
}
