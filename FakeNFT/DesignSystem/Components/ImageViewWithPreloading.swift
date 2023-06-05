//
// Created by Сергей Махленко on 27.05.2023.
//

import UIKit
import Kingfisher

class ImageViewWithPreloading: UIImageView {
    init() {
        super.init(image: nil)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func load(url: URL?, completionHandle: (() -> Void)? = nil ) {
        image = nil

        kf.setImage(with: url) { [weak self] _ in
            guard let self else { return }
            self.stopAnimating()
            self.alpha = 1.0

            completionHandle?()
        }
    }

    private func setupView() {
        backgroundColor = .asset(.lightGray)
        showPreloadingBackground()
    }

    private func showPreloadingBackground() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse]) { [weak self] in
            guard let self else { return }
            self.alpha = 0.4
        }
    }
}
