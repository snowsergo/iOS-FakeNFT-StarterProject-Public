//
//  ProfileRequest.swift
//  FakeNFT
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL?

    init() {
        guard let endpoint = URL(string: "\(Config.baseUrl)/profile/1") else { return }
        self.endpoint = endpoint
    }
}
