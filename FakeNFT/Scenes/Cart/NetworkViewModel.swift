//
// Created by Сергей Махленко on 03.06.2023.
//

import Foundation

class NetworkViewModel: NetworkViewModelProtocol {
    var networkClient: DefaultNetworkClient

    var showAlertClosure: (() -> Void)?
    var errorMessage: String? = nil {
        didSet {
            showAlertClosure?()
        }
    }

    var updateLoadingStatus: (() -> Void)?
    var isLoading: Bool = false {
        didSet {
            updateLoadingStatus?()
        }
    }

    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
}
