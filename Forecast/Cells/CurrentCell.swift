//
//  CurrentCell.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

import UIKit

class CurrentCell: UICollectionViewCell, SelfConfiguringCell {

    static var reusedId = CurrentCell.identifier

    private let customView: UIView = {
        let customView = UIView()
        customView.backgroundColor = Color.blueColor
        customView.layer.cornerRadius = 5
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()

    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Rubik-Medium", size: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.yellow
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
        guard let value: CurrentModel = value as? CurrentModel else { return }

        windSpeedLabel.text = "Скорость ветра \(value.windspeed)м/с"

        let temperature = SettingsApp.temperatureUnit ? value.temperature.fahrenheit + "° F" : String(Int(value.temperature)) + "° C"
        temperatureLabel.text = temperature

        descriptionLabel.text = "\(value.descriptionCode)"

        let formatter = DateFormatter()
        let timeFormat = SettingsApp.timeformatUnit ? "HH:mm, EE d MMMM" : "h:mm a, EE d MMMM"
        formatter.dateFormat = timeFormat
        dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value.time)))
    }

    private func setupView() {
        addSubview(customView)
        addSubview(windSpeedLabel)
        addSubview(temperatureLabel)
        addSubview(descriptionLabel)
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: topAnchor),
            customView.bottomAnchor.constraint(equalTo: bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: trailingAnchor),

            windSpeedLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 30),
            windSpeedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: 10),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
