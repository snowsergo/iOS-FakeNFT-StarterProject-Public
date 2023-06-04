//
// Created by Сергей Махленко on 03.06.2023.
//

import Foundation

protocol NetworkViewModelProtocol {
    var networkClient: DefaultNetworkClient { get }

    /// показ ошибок
    var showAlertClosure: (() -> Void)? { get }
    var errorMessage: String? { get }

    /// показ лоадера
    var updateLoadingStatus: (() -> Void)? { get }
    var isLoading: Bool { get }
}



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
