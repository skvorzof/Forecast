//
//  Protocols.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

protocol SelfConfiguringCell {
    static var reusedId: String { get }
    func configure<U: Hashable>(with value: U)
}

protocol Weathercode {
    var weathercode: Int { get }
}
