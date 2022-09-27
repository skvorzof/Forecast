//
//  HourlyCell.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

import UIKit

class HourlyCell: UICollectionViewCell, SelfConfiguringCell {

    static var reusedId = HourlyCell.identifier

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Rubik-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconWeather: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
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
        guard let value: HourlyModel = value as? HourlyModel else { return }

        let formatter = DateFormatter()
        let timeFormat = SettingsApp.timeformatUnit ? "HH:mm" : "h:mm a"
        formatter.dateFormat = timeFormat
        timeLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value.time)))

        iconWeather.image = UIImage(systemName: value.iconImage)
        
        let temperature = SettingsApp.temperatureUnit ? value.temperature.fahrenheit + "°" : String(Int(value.temperature)) + "°"
        temperatureLabel.text = temperature
    }

    private func setupView() {
        addSubview(timeLabel)
        addSubview(iconWeather)
        addSubview(temperatureLabel)

        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            iconWeather.widthAnchor.constraint(equalToConstant: 20),
            iconWeather.heightAnchor.constraint(equalToConstant: 20),
            iconWeather.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            iconWeather.centerXAnchor.constraint(equalTo: centerXAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: iconWeather.bottomAnchor, constant: 10),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
