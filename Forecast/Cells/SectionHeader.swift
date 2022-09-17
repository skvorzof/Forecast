//
//  SectionHeader.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

import UIKit

class SectionHeader: UICollectionReusableView {

    private let titleHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Rubik-Medium", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dayButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Color.blackColor, for: .normal)
        button.addAction(
            UIAction(handler: { [unowned self] (_) in
                self.didTapButtonCallback?()
            }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var didTapButtonCallback: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dayButton.setAttributedTitle("".underLined, for: .normal)
    }

    private func setupView() {
        addSubview(titleHeader)
        addSubview(dayButton)

        NSLayoutConstraint.activate([
            titleHeader.centerYAnchor.constraint(equalTo: centerYAnchor),

            dayButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            dayButton.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    func configure(title: String, _ section: Int) {
        titleHeader.text = title

        if section == 1 {
            dayButton.setAttributedTitle("24 часа".underLined, for: .normal)
        } else if section == 2 {
            dayButton.setAttributedTitle("25 суток".underLined, for: .normal)
        }
    }
}
