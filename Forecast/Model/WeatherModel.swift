//
//  WeatherModel.swift
//  Forecast
//
//  Created by Dima Skvortsov on 14.09.2022.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let current: Current
    let hourly: Hourly
    let daily: Daily

    enum CodingKeys: String, CodingKey {
        case current = "current_weather"
        case hourly
        case daily
    }
}

// MARK: - WeatherCurrent
struct WeatherCurrent: Codable {
    let current: Current

    enum CodingKeys: String, CodingKey {
        case current = "current_weather"
    }
}

struct Current: Codable {
    let temperature: Double
    let windspeed: Double
    let winddirection: Int
    let weathercode: Int
    let time: Int
}

// MARK: - WeatherHourly
struct WeatherHourly: Codable {
    let hourly: Hourly
}

struct Hourly: Codable {
    let time: [Int]
    let temperature: [Double]
    let weathercode: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case weathercode
    }
}

// MARK: - WeatherDaily
struct WeatherDaily: Codable {
    let daily: Daily
}

struct Daily: Codable {
    let time: [Int]
    let temperatureMin: [Double]
    let temperatureMax: [Double]
    let weathercode: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperatureMin = "temperature_2m_min"
        case temperatureMax = "temperature_2m_max"
        case weathercode
    }
}
