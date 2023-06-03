//
// Created by Сергей Махленко on 03.06.2023.
//

import Foundation

protocol PaymentStatusProtocol {
    var didTapComplete: (() -> Void)? { get set }
}
