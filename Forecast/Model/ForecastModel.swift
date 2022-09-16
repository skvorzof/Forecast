//
//  ForecastModel.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

import Foundation

struct CurrentModel: Hashable, Weathercode {
    let time: Int
    let temperature: Double
    let windspeed: Double
    var weathercode: Int
}

struct HourlyModel: Hashable, Weathercode {
    let time: Int
    let temperature: Double
    var weathercode: Int
}

struct DailyModel: Hashable, Weathercode {
    let time: Int
    let temperatureMin: Double
    let temperatureMax: Double
    var weathercode: Int
}
