//
//  CustomSegmentedControl.swift
//  Forecast
//
//  Created by Dima Skvortsov on 16.09.2022.
//

import UIKit

final class CustomSegmentedControl: UISegmentedControl {

    var segmentedDidChanged: ((_ sender: UISegmentedControl) -> Void)?
    
    private let segments: [String]

    init(segments: [String]) {
        self.segments = segments
        super.init(items: segments)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        selectedSegmentIndex = 0
        backgroundColor = Color.switcherColor
        layer.borderWidth = 1
        layer.borderColor = Color.backgroundColor.cgColor
        selectedSegmentTintColor = Color.blueColor
        addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        translatesAutoresizingMaskIntoConstraints = false
        setTitleTextAttributes(titleTextAttributes, for: .selected)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func didChangeValue(_ sender: UISegmentedControl) {
        segmentedDidChanged?(sender)
    }
}
