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
