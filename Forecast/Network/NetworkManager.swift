//
//  NetworkManager.swift
//  Forecast
//
//  Created by Dima Skvortsov on 14.09.2022.
//

import Foundation

final class NetworkManager {

    static let share = NetworkManager()
    
    private let mock = "https://forecast.dmtri.ru/forecast_v1.json"

    //    private let current = "https://api.open-meteo.com/v1/forecast?latitude=55.7558&longitude=37.6176&current_weather=true&timezone=Europe%2FMoscow"
    //    private let hourly = "https://api.open-meteo.com/v1/forecast?latitude=55.7558&longitude=37.6176&hourly=temperature_2m,weathercode&timezone=Europe%2FMoscow"
    //    private let daily =
    //        "https://api.open-meteo.com/v1/forecast?latitude=55.7558&longitude=37.6176&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=Europe%2FMoscow"

    private init() {}

    // MARK: - fetchWeather
    func fetchWeather(lat: String, lon: String, completion: @escaping (WeatherModel) -> Void) {

//        let API_URL =
//            "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&hourly=temperature_2m,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min&current_weather=true&timezone=Europe%2FMoscow"

        guard let url = URL(string: mock) else {
            fatalError()
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }

            do {
                let forecast = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(forecast)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}