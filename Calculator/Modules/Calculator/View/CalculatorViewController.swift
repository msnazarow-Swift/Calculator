//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by out-nazarov2-ms on 13.09.2021.
//  
//

import UIKit

class CalculatorViewController: UIViewController {

    // MARK: - Properties

    var presenter: ViewToPresenterCalculatorProtocol?

    lazy var gap = view.frame.height / 50

    var buttonNames = [
        ["AC", "+⁄−", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", " ", ",", "="]
    ]

    lazy var buttons = (0 ... 19).map { i -> UIButton in
        let button = CalculatorButton.generateButton(for: buttonNames[i / 4][i % 4])
        button.addTarget(self, action: #selector(buttonDidTapped(button:)), for: .touchUpInside)
        return button
    }

    lazy var grid: UIStackView = {
        let grid = UIStackView(arrangedSubviews: (0 ... 4).map { i in {
            let horisontalStack = UIStackView(arrangedSubviews: (0 ... 3).map { j in buttons[i * 4 + j]})
            horisontalStack.axis = .horizontal
            horisontalStack.alignment = .fill
            horisontalStack.spacing =  gap
            horisontalStack.distribution = .fillEqually
            return horisontalStack
        }()
        })
        grid.axis = .vertical
        grid.alignment = .fill
        grid.distribution = .fillEqually
        grid.spacing = gap
        return grid
    }()

    let displayLabel: UILabel = {
        let displayLabel = UILabel()
        displayLabel.text = "0"
        displayLabel.textColor = .white
        displayLabel.textAlignment = .right
        displayLabel.adjustsFontSizeToFitWidth = true
        displayLabel.minimumScaleFactor = 0.5
        displayLabel.numberOfLines = 1
        displayLabel.font = .systemFont(ofSize: (UIApplication.shared.statusBarOrientation.isPortrait ? 80 : 50) * verticalTranslation)
        return displayLabel
    }()

    let historyLabel: UILabel = {
        let historyLabel = UILabel()
        historyLabel.numberOfLines = 0
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        historyLabel.layer.masksToBounds = true
        historyLabel.textColor = .white
        return historyLabel
    }()

    lazy var mainView: UIStackView = {
        let mainView = UIStackView(arrangedSubviews: [displayLabel, grid])
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.axis = .vertical
        mainView.spacing = gap
        return mainView
    }()

    var optionalConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.frame)
        setupUI()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        optionalConstraint.isActive = false
//        NSLayoutConstraint.deactivate(historyLabel.constraints)
        if UIDevice.current.orientation.isLandscape {
            displayLabel.font = .systemFont(ofSize: 50 * verticalTranslation)
            historyLabel.isHidden = false
            optionalConstraint = mainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 4.0 / 6.0, constant: -gap)

        } else {
            displayLabel.font = .systemFont(ofSize: 80 * verticalTranslation)
            historyLabel.isHidden = true
//            NSLayoutConstraint.deactivate(historyLabel.constraints)
            if (view.bounds.height / view.bounds.width < 4.0 / 6.0) {
                optionalConstraint = mainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant:  -2 * gap)
            } else {
                optionalConstraint = mainView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -2 * gap)
            }
        }
        optionalConstraint.isActive = true
        let constraints = [
            historyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            historyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: gap),
            historyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -gap),
            historyLabel.trailingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: -gap),
        ]
        constraints.forEach{$0.priority = UILayoutPriority(rawValue: 999)}
        NSLayoutConstraint.activate(constraints)

    }
    // MARK: - SetupUI Methods

    private func setupUI() {
        view.addSubview(mainView)
        view.addSubview(historyLabel)
        let historyLabelLeftConstraint = historyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: gap)
        historyLabelLeftConstraint.priority = UILayoutPriority(rawValue: 998)
        if UIApplication.shared.statusBarOrientation.isPortrait {
            historyLabel.isHidden = true
        } else {
            NSLayoutConstraint.activate([
                historyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: gap),
                historyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -gap),
                historyLabel.trailingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: -gap),
//                historyLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -mainView.frame.width - 2 * gap)
                historyLabelLeftConstraint
            ])
        }
        buttons[17].backgroundColor = .clear

        setupConstraints()
    }

    private func setupConstraints() {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            optionalConstraint = mainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 4.0 / 6.0, constant: -gap)
        } else {
            if (view.frame.width / view.frame.height < 4.0 / 6.0) {
                optionalConstraint = mainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant:  -2 * gap)
            } else {
                optionalConstraint = mainView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant:  -2 * gap)
            }
        }

        //TODO не работает в landscape
        NSLayoutConstraint.activate([
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -gap),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -0.5 * gap),
            grid.widthAnchor.constraint(equalTo: grid.heightAnchor, multiplier: 0.8),
            displayLabel.heightAnchor.constraint(equalTo: grid.arrangedSubviews.first!.heightAnchor),
            optionalConstraint,
        ])
    }

    @objc private func buttonDidTapped(button: UIButton){
        presenter?.buttonDidTapped(button.titleLabel?.text)
    }
}

extension CalculatorViewController: PresenterToViewCalculatorProtocol{
    // TODO: Implement View Output Methods
    func setDisplayText(_ text: String) {
        displayLabel.text = text
    }

    func pushHistoryText(_ text: String) {
        historyLabel.text = (historyLabel.text ?? "") + text
    }
    func clearInput() {
        displayLabel.text = "0"
    }
    
    func getResult() -> Double? {
        return Double(displayLabel.text ?? "")
    }

    func bibError() {

    }

    func switchACButtonTitle(to title: String){
        buttons[0].setTitle(title, for: .normal)
    }

    func clearHistory() {
        historyLabel.text = ""
    }
}
