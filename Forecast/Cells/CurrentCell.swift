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

    private let minMaxTemperatureLabel: UILabel = {
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

    func configure(with value: CurrentModel) {
        minMaxTemperatureLabel.text = "Скорость ветра \(value.windspeed)м/с"

        temperatureLabel.text = "\(Int(value.temperature))°"
        descriptionLabel.text = "\(value.descriptionCode)"

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, EE d MMMM"
        dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value.time)))
    }

    private func setupView() {
        addSubview(customView)
        addSubview(minMaxTemperatureLabel)
        addSubview(temperatureLabel)
        addSubview(descriptionLabel)
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: topAnchor),
            customView.bottomAnchor.constraint(equalTo: bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: trailingAnchor),

            minMaxTemperatureLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 30),
            minMaxTemperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: minMaxTemperatureLabel.bottomAnchor, constant: 10),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
