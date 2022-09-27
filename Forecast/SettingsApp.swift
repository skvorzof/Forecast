//
//  SettingsApp.swift
//  Forecast
//
//  Created by Dima Skvortsov on 26.09.2022.
//

import Foundation

final class SettingsApp {

    static var temperatureUnit: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: "temperature")
        }
        set {
            let defaults = UserDefaults.standard
            if let value = newValue {
                defaults.set(value, forKey: "temperature")
            } else {
                defaults.removeObject(forKey: "temperature")
            }
        }
    }

    static var windspeedUnit: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: "windspeed")
        }
        set {
            let defaults = UserDefaults.standard
            if let value = newValue {
                defaults.set(value, forKey: "windspeed")
            } else {
                defaults.removeObject(forKey: "windspeed")
            }
        }
    }

    static var timeformatUnit: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: "timeformat")
        }
        set {
            let defaults = UserDefaults.standard
            if let value = newValue {
                defaults.set(value, forKey: "timeformat")
            } else {
                defaults.removeObject(forKey: "timeformat")
            }
        }
    }

    static var notificationUnit: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: "notification")
        }
        set {
            let defaults = UserDefaults.standard
            if let value = newValue {
                defaults.set(value, forKey: "notification")
            } else {
                defaults.removeObject(forKey: "notification")
            }
        }
    }
}
