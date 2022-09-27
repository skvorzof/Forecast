//
//  SettingsViewController.swift
//  Forecast
//
//  Created by Dima Skvortsov on 16.09.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    private let shapeView: UIView = {
        let shapeView = UIView()
        shapeView.backgroundColor = Color.backgroundColor
        shapeView.layer.cornerRadius = 10
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        return shapeView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.blackColor
        label.font = UIFont(name: "Rubik-Medium", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Настройки"
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.grayColor
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Температура"
        return label
    }()

    private lazy var temperatureSwitch: CustomSegmentedControl = {
        let control = CustomSegmentedControl(segments: ["C", "F"])
        control.selectedSegmentIndex = SettingsApp.temperatureUnit.intValue
        return control
    }()

    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.grayColor
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Скорость ветра"
        return label
    }()

    private lazy var windSpeedSwitch: CustomSegmentedControl = {
        let control = CustomSegmentedControl(segments: ["Mi", "Km"])
        control.selectedSegmentIndex = SettingsApp.windspeedUnit.intValue
        return control
    }()

    private let timeFormatLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.grayColor
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Формат времени"
        return label
    }()

    private lazy var timeFormatSwitch: CustomSegmentedControl = {
        let control = CustomSegmentedControl(segments: ["12", "24"])
        control.selectedSegmentIndex = SettingsApp.timeformatUnit.intValue
        return control
    }()

    private let notificationsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.grayColor
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Уведомления"
        return label
    }()

    private lazy var notificationsSwitch: CustomSegmentedControl = {
        let control = CustomSegmentedControl(segments: ["On", "Off"])
        control.selectedSegmentIndex = SettingsApp.notificationUnit.intValue
        return control
    }()

    private lazy var setupButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 16)
        button.backgroundColor = Color.accentColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Установить ", for: .normal)
        button.addTarget(self, action: #selector(didTapSetupButton), for: .touchUpInside)
        return button
    }()

    private let cloudElementOne: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cloud-one")
        imageView.alpha = 0.3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let cloudElementTwo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cloud-two")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let cloudElementThree: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cloud-three")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        changedSegmentedControls()
    }

    @objc
    private func didTapSetupButton() {
        dismiss(animated: true)
    }

    private func changedSegmentedControls() {
        temperatureSwitch.segmentedDidChanged = { sender in
            switch sender.selectedSegmentIndex {
            case 0:
                SettingsApp.temperatureUnit = false
            case 1:
                SettingsApp.temperatureUnit = true
            default:
                break
            }
        }

        windSpeedSwitch.segmentedDidChanged = { sender in
            if sender.selectedSegmentIndex == 0 {
                SettingsApp.windspeedUnit = false
            } else {
                SettingsApp.windspeedUnit = true
            }
        }
        
        timeFormatSwitch.segmentedDidChanged = { sender in
            if sender.selectedSegmentIndex == 0 {
                SettingsApp.timeformatUnit = false
            } else {
                SettingsApp.timeformatUnit = true
            }
        }
        
        notificationsSwitch.segmentedDidChanged = { sender in
            if sender.selectedSegmentIndex == 0 {
                SettingsApp.notificationUnit = false
            } else {
                SettingsApp.notificationUnit = true
            }
        }
    }

    private func setupView() {
        view.backgroundColor = Color.blueColor

        view.addSubview(shapeView)
        view.addSubview(titleLabel)

        view.addSubview(temperatureLabel)
        view.addSubview(temperatureSwitch)

        view.addSubview(windSpeedLabel)
        view.addSubview(windSpeedSwitch)

        view.addSubview(timeFormatLabel)
        view.addSubview(timeFormatSwitch)

        view.addSubview(notificationsLabel)
        view.addSubview(notificationsSwitch)

        view.addSubview(setupButton)

        view.addSubview(cloudElementOne)
        view.addSubview(cloudElementTwo)
        view.addSubview(cloudElementThree)

        NSLayoutConstraint.activate([
            shapeView.widthAnchor.constraint(equalToConstant: 320),
            shapeView.heightAnchor.constraint(equalToConstant: 320),
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: shapeView.topAnchor, constant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: shapeView.leadingAnchor, constant: 20),

            temperatureLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            temperatureLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            temperatureSwitch.widthAnchor.constraint(equalToConstant: 80),
            temperatureSwitch.topAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -6),
            temperatureSwitch.trailingAnchor.constraint(equalTo: shapeView.trailingAnchor, constant: -30),

            windSpeedLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 30),
            windSpeedLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            windSpeedSwitch.widthAnchor.constraint(equalToConstant: 80),
            windSpeedSwitch.topAnchor.constraint(equalTo: windSpeedLabel.topAnchor, constant: -6),
            windSpeedSwitch.trailingAnchor.constraint(equalTo: shapeView.trailingAnchor, constant: -30),

            timeFormatLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: 30),
            timeFormatLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            timeFormatSwitch.widthAnchor.constraint(equalToConstant: 80),
            timeFormatSwitch.topAnchor.constraint(equalTo: timeFormatLabel.topAnchor, constant: -6),
            timeFormatSwitch.trailingAnchor.constraint(equalTo: shapeView.trailingAnchor, constant: -30),

            notificationsLabel.topAnchor.constraint(equalTo: timeFormatLabel.bottomAnchor, constant: 30),
            notificationsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            notificationsSwitch.widthAnchor.constraint(equalToConstant: 80),
            notificationsSwitch.topAnchor.constraint(equalTo: notificationsLabel.topAnchor, constant: -6),
            notificationsSwitch.trailingAnchor.constraint(equalTo: shapeView.trailingAnchor, constant: -30),

            setupButton.heightAnchor.constraint(equalToConstant: 40),
            setupButton.bottomAnchor.constraint(equalTo: shapeView.bottomAnchor, constant: -16),
            setupButton.leadingAnchor.constraint(equalTo: shapeView.leadingAnchor, constant: 35),
            setupButton.trailingAnchor.constraint(equalTo: shapeView.trailingAnchor, constant: -35),

            cloudElementOne.widthAnchor.constraint(equalToConstant: 250),
            cloudElementOne.heightAnchor.constraint(equalToConstant: 58),
            cloudElementOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            cloudElementOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),

            cloudElementTwo.widthAnchor.constraint(equalToConstant: 182),
            cloudElementTwo.heightAnchor.constraint(equalToConstant: 94),
            cloudElementTwo.topAnchor.constraint(equalTo: cloudElementOne.bottomAnchor, constant: 25),
            cloudElementTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),

            cloudElementThree.widthAnchor.constraint(equalToConstant: 216),
            cloudElementThree.heightAnchor.constraint(equalToConstant: 65),
            cloudElementThree.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -94),
            cloudElementThree.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
