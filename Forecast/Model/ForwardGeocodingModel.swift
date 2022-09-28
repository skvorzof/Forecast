//
//  ForwardGeocodingModel.swift
//  Forecast
//
//  Created by Dima Skvortsov on 27.09.2022.
//

import Foundation

struct ForwardGeocodingModel: Codable {
    let results: [Results]
    
    struct Results: Codable {
        let geometry: Geometry
    }

    struct Geometry: Codable {
        let lat: Double
        let lng: Double
    }
}


