//
//  OnboardingViewController.swift
//  Forecast
//
//  Created by Dima Skvortsov on 16.09.2022.
//

import UIKit

// MARK: - OnboardingViewController
class OnboardingViewController: UIViewController {
    
    private let womanumbrellaElement: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "womanumbrella")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Rubik-SemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Разрешить приложению  Weather использовать данные о местоположении вашего устройства"
        return label
    }()
    
    private let descriptionPartOne: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Rubik-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Чтобы получить более точные прогнозы погоды во время движения или путешествия"
        return label
    }()
    
    private let descriptionPartTwo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Rubik-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Вы можете изменить свой выбор в любое время из меню приложения"
        return label
    }()
    
    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 12)
        button.backgroundColor = Color.accentColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Использовать местоположение устройства".uppercased(), for: .normal)
        return button
    }()
    
    private lazy var notButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Нет, я буду добавлять локации".uppercased(), for: .normal)
        button.addTarget(self, action: #selector(didTapNotButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @objc
    private func didTapNotButton() {
        let vc = AddLocationViewController()
        present(vc, animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = Color.blueColor
        
        view.addSubview(womanumbrellaElement)
        view.addSubview(titleLabel)
        view.addSubview(descriptionPartOne)
        view.addSubview(descriptionPartTwo)
        view.addSubview(yesButton)
        view.addSubview(notButton)
        
        NSLayoutConstraint.activate([
            womanumbrellaElement.widthAnchor.constraint(equalToConstant: 180),
            womanumbrellaElement.heightAnchor.constraint(equalToConstant: 196),
            womanumbrellaElement.topAnchor.constraint(equalTo: view.topAnchor, constant: 148),
            womanumbrellaElement.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: womanumbrellaElement.bottomAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            
            descriptionPartOne.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 56),
            descriptionPartOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            descriptionPartOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            
            descriptionPartTwo.topAnchor.constraint(equalTo: descriptionPartOne.bottomAnchor, constant: 14),
            descriptionPartTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            descriptionPartTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            
            yesButton.heightAnchor.constraint(equalToConstant: 40),
            yesButton.topAnchor.constraint(equalTo: descriptionPartTwo.bottomAnchor, constant: 44),
            yesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            yesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            notButton.heightAnchor.constraint(equalToConstant: 40),
            notButton.topAnchor.constraint(equalTo: yesButton.bottomAnchor, constant: 25),
            notButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
