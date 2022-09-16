//
//  Extensions.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

import UIKit

extension UIView {
    static var identifier: String {
        String(describing: self)
    }
}

extension Weathercode {
    var iconImage: String {
        switch weathercode {
        case 0: return "sun.max"
        case 1, 2, 3: return "cloud.sun"
        case 45, 48: return "smoke"
        case 51, 53, 55: return "cloud.drizzle"
        case 56, 57: return "cloud.drizzle"
        case 61, 63, 65: return "cloud.rain"
        case 66, 67: return "cloud.sleet"
        case 71, 73, 75: return "cloud.snow"
        case 77: return "cloud.hail"
        case 80, 81, 82: return "cloud.heavyrain"
        case 85, 86: return "cloud.snow"
        case 95: return "cloud.bolt"
        case 96, 99: return "cloud.bolt.rain"
        default: return "window.vertical.closed"
        }
    }

    var descriptionCode: String {
        switch weathercode {
        case 0: return "Чистое небо"
        case 1, 2, 3: return "Преимущественно ясно, переменная облачность и пасмурно"
        case 45, 48: return "Туман и осаждающийся инейный туман"
        case 51, 53, 55: return "Морось: Легкая, умеренная и плотная интенсивность"
        case 56, 57: return "Моросящий дождь: Легкая и плотная интенсивность"
        case 61, 63, 65: return "Дождь: Небольшой, умеренной и сильной интенсивности"
        case 66, 67: return "Ледяной дождь: Легкая и сильная интенсивность"
        case 71, 73, 75: return "Снегопад: Небольшой, умеренной и сильной интенсивности"
        case 77: return "Град"
        case 80, 81, 82: return "Ливневые дожди: Слабые, умеренные и сильные"
        case 85, 86: return "Снегопады легкие и обильные"
        case 95: return "Гроза: Слабая или умеренная"
        case 96, 99: return "Гроза с легким и сильным градом"
        default: return "Смотри в окно"
        }
    }
}
