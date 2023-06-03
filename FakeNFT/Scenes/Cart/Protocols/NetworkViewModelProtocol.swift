//
// Created by Сергей Махленко on 03.06.2023.
//

import Foundation

protocol NetworkViewModelProtocol {
    var networkClient: DefaultNetworkClient { get }

    var showAlertClosure: (() -> Void)? { get }
    var errorMessage: String? { get }

    var updateLoadingStatus: (() -> Void)? { get }
    var isLoading: Bool { get }
}
