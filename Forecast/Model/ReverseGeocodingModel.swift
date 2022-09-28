//
//  ReverseGeocodingModel.swift
//  Forecast
//
//  Created by Dima Skvortsov on 19.09.2022.
//

import Foundation

struct ReverseGeocodingModel: Codable {
    let results: [Results]

    struct Results: Codable {
        let annotations: Annotations
        let components: Components
    }

    struct Annotations: Codable {
        let flag: String
    }

    struct Components: Codable {
        let city: String
        let country: String
    }
}
