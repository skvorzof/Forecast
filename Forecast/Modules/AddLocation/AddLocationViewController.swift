//
//  AddLocationViewController.swift
//  Forecast
//
//  Created by Dima Skvortsov on 16.09.2022.
//

import UIKit

class AddLocationViewController: UIViewController {

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 60), forImageIn: .normal)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    @objc
    private func didTapAddButton() {
        let alertController = UIAlertController(title: "Добавте локацию", message: nil, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Добавить", style: .default) { (_) in
            if let textField = alertController.textFields?.first, let text = textField.text {

                GeocodingManager.shared.fetchForwardGeocoding(city: text) { location in
                    print("AddLocationViewController: \(location)")
                }
                
                self.dismiss(animated: false)
            }
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in
            self.dismiss(animated: false)
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Например Санкт-Петербург"
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
