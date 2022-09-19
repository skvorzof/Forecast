//
//  GeocodingManager.swift
//  Forecast
//
//  Created by Dima Skvortsov on 19.09.2022.
//

import CoreLocation
import Foundation

final class GeocodingManager {

    static let shared = GeocodingManager()
    private init() {}

    private let apiKey = "9a305245d3434cafa151606aa36d561a"
    private let mock = "https://forecast.dmtri.ru/geo.json"

    func fetchGeolocation(location: CLLocation, completion: @escaping (String) -> Void) {

        let apiUrl = "https://api.opencagedata.com/geocode/v1/json?q=\(location.coordinate.latitude)+\(location.coordinate.longitude)&key=\(apiKey)"

        guard let url = URL(string: mock) else {
            fatalError()
        }

        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(GeocodingModel.self, from: data)
                let city = "\(result.results[0].components.city), \(result.results[0].components.country) \(result.results[0].annotations.flag)"
                completion(city)
            } catch {
                print(error)
            }
        }.resume()
    }
}
