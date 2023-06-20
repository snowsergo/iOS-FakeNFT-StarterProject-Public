//
//  ErrorAlertPresenter.swift
//  FakeNFT
//

import UIKit

final class ErrorAlertPresenter {

    weak var viewController: UIViewController?

    /// Presents an alert controller modally.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: Descriptive text that provides additional details about the reason for the alert.
    ///   - firstActionTitle: The text to use for the first button title.
    ///   - secondActionTitle: The text to use for the second button title.
    ///   - firstAction: A block to execute when the user select the first action.
    ///   - secondAction: A block to execute when the user select the second action.
    func showAlert(title: String,
                   message: String,
                   firstActionTitle: String,
                   secondActionTitle: String,
                   firstAction: @escaping () -> Void,
                   secondAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let firstAction = UIAlertAction(title: firstActionTitle, style: .default) { _ in firstAction() }
        let secondAction = UIAlertAction(title: secondActionTitle, style: .cancel) { _ in secondAction?() }
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        viewController?.present(alert, animated: true)
    }
}

