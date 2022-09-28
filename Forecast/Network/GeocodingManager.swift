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
    private let mockReverse = "https://forecast.dmtri.ru/geor.json"
    private let mockForvard = "https://forecast.dmtri.ru/geof.json"

    func fetchReverseGeocoding(location: CLLocation, completion: @escaping (String) -> Void) {

        let apiUrl = "https://api.opencagedata.com/geocode/v1/json?q=\(location.coordinate.latitude)+\(location.coordinate.longitude)&key=\(apiKey)"

        guard let url = URL(string: mockReverse) else {
            fatalError()
        }

        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(ReverseGeocodingModel.self, from: data)
                let city = "\(result.results[0].components.city), \(result.results[0].components.country) \(result.results[0].annotations.flag)"
                completion(city)
            } catch {
                print(error)
            }
        }.resume()
    }

    func fetchForwardGeocoding(city: String, completion: @escaping (String) -> Void) {
        let apiUrl = "https://api.opencagedata.com/geocode/v1/json?q=\(city)&key=\(apiKey)&language=ru&pretty=1&no_annotations=1"

        guard let url = URL(string: mockForvard) else { return }

        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(ForwardGeocodingModel.self, from: data)
                print("Result geo: \(result.results[0].geometry)")
            } catch {
                print(error)
            }
        }.resume()
    }
}
