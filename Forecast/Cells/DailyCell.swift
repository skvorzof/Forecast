//
//  DailyCell.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

import UIKit

class DailyCell: UICollectionViewCell, SelfConfiguringCell {

    static var reusedId = DailyCell.identifier

    private let customView: UIView = {
        let customView = UIView()
        customView.backgroundColor = Color.backgroundColor
        customView.layer.cornerRadius = 5
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.grayColor
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconWeather: UIImageView = {
        let icon = UIImageView()
        //        icon.image = UIImage(systemName: "cloud.rain")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Rubik-Regular", size: 18)
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
        formatter.dateFormat = "dd/MM"
        dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value.time)))

        iconWeather.image = UIImage(systemName: value.iconImage)

        descriptionLabel.text = value.descriptionCode

        temperatureLabel.text = "\(Int(value.temperatureMin))°/\(Int(value.temperatureMax))°"

    }

    private func setupView() {
        addSubview(customView)
        addSubview(dateLabel)
        addSubview(iconWeather)
        addSubview(descriptionLabel)
        addSubview(temperatureLabel)

        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: topAnchor),
            customView.bottomAnchor.constraint(equalTo: bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: trailingAnchor),

            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),

            iconWeather.widthAnchor.constraint(equalToConstant: 20),
            iconWeather.heightAnchor.constraint(equalToConstant: 20),
            iconWeather.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 7),
            iconWeather.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: 10),

            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -80),

            temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}
