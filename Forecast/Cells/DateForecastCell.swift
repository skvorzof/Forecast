//
//  DateForecastCell.swift
//  Forecast
//
//  Created by Dima Skvortsov on 19.09.2022.
//

import UIKit

class DateForecastCell: UICollectionViewCell, SelfConfiguringCell {

    static var reusedId = DateForecastCell.identifier

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.grayColor
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure<U>(with value: U) where U: Hashable {
        guard let value: DailyModel = value as? DailyModel else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM EE"
        dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value.time)))

    }

    private func setupView() {
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
