//
//  CircleButton.swift
//  SwiftPiscine.Day00
//
//  Created by out-nazarov2-ms on 16.09.2021.
//

import UIKit


class OpeationButton: CalculatorButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        titleLabel?.font = .boldSystemFont(ofSize: 40 * verticalTranslation)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if UIDevice.current.orientation.isLandscape {
            titleLabel?.font = .boldSystemFont(ofSize: 30 * verticalTranslation)
        } else {
            titleLabel?.font = .boldSystemFont(ofSize: 40 * verticalTranslation)
        }
    }
}

class DigitButton: CalculatorButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if UIDevice.current.orientation.isLandscape {
            titleLabel?.font = .systemFont(ofSize: 20 * verticalTranslation)
        } else {
            titleLabel?.font = .systemFont(ofSize: 40 * verticalTranslation)
        }
    }
}

class AdditionButton: CalculatorButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        titleLabel?.font = .systemFont(ofSize: 30 * verticalTranslation)
        setTitleColor(.black, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        if UIDevice.current.orientation.isLandscape {
            titleLabel?.font = .systemFont(ofSize: 20 * verticalTranslation)
        } else {
            titleLabel?.font = .systemFont(ofSize: 30 * verticalTranslation)
        }
    }
}
class CalculatorButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 40 * verticalTranslation)
        backgroundColor = .darkGray
        clipsToBounds = true
        //        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0.5 * bounds.size.width
    }

    static func generateButton(for key: String) -> CalculatorButton {
        if ("0"..."9").contains(key) || key == .comma {
            let button = DigitButton()
            button.setTitle(key, for: .normal)
            return button
        } else if operations.contains(key) {
            let button = OpeationButton()
            button.setTitle(key, for: .normal)
            return button
        } else if additions.contains(key) {
            let button = AdditionButton()
            button.setTitle(key, for: .normal)
            return button
        } else {
            let button =  CalculatorButton()
            button.setTitle(key, for: .normal)
            return button
        }
    }
}

