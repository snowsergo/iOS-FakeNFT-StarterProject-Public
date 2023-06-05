//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit

final class ButtonComponent: UIButton {
    var style: ButtonStyle = .primary {
        didSet {
            applyStyle()
        }
    }
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.3
        }
    }
    var size: ButtonSize = .normal

    override var isHighlighted: Bool {
        didSet {
            if style == .secondary {
                layer.borderColor = isHighlighted
                    ? style.backgroundColorPressed?.cgColor
                    : style.backgroundColor?.cgColor
            }

            backgroundColor = isHighlighted ? style.backgroundColorPressed : style.backgroundColor
            setTitleColor(isHighlighted ? style.textColorPressed : style.textColor, for: .normal)
        }
    }

    init(_ style: ButtonStyle = .standard, size: ButtonSize = .normal) {
        super.init(frame: .zero)

        self.style = style
        self.size = size

        applyStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func applyStyle() {
        layer.masksToBounds = true

        layer.borderWidth = style.borderWidth
        layer.borderColor = style.borderColor?.cgColor ?? .none
        layer.cornerRadius = 16
        contentEdgeInsets = size.edgeInsets
        backgroundColor = style.backgroundColor
        setTitleColor(style.textColor, for: .normal)
        titleLabel?.font = style.fontStyle
    }
}
