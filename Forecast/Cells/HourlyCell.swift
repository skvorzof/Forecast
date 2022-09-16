//
//  HourlyCell.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

import UIKit

class HourlyCell: UICollectionViewCell {

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

    func configureCell(with value: HourlyModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value.time)))

        iconWeather.image = UIImage(systemName: value.iconImage)
        temperatureLabel.text = "\(Int(value.temperature))°"
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
