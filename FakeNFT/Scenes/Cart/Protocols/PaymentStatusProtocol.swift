//
// Created by Сергей Махленко on 03.06.2023.
//

import Foundation

protocol PaymentStatusProtocol {
    var didComplete: (() -> Void)? { get set }
}
