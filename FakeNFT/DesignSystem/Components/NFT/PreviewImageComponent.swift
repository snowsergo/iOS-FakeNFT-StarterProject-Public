//
// Created by Сергей Махленко on 25.05.2023.
//

import UIKit

class PreviewImageComponent: UIImageView {

    let loadingAnimation = UIView()

    init(url: URL?) {
        super.init(image: nil)

        backgroundColor = .asset(.lightGrey)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
        layer.masksToBounds = true

        showLoadingBackground()

        load(url: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func load(url: URL?) {
        if url != nil {
            image = nil
            kf.setImage(with: url) { [weak self] _ in
                guard let self else { return }
                self.stopAnimating()
                self.alpha = 1.0
            }
        }
    }

    func showLoadingBackground() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse]) { [weak self] in
            guard let self else { return }
            self.alpha = 0.4
        }
    }
}
