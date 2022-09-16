//
//  SectionHeader.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    private let txt: UILabel = {
        let label = UILabel()
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

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupView() {
        addSubview(txt)
        
        NSLayoutConstraint.activate([
            txt.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(title: String) {
        txt.text = title
    }
}

