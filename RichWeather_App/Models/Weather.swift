//
//  Weather.swift
//  RichWeather_App
//
//  Created by Eason Lin on 12/12/2024.
//

import SwiftUI
import CoreLocation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let timezone: Int
    let wind: Wind
    let coord: Coord

    struct Main: Decodable {
        let temp: Double
        let humidity: Int
    }

    struct Weather: Decodable {
        let description: String
        let icon: String
    }

    struct Wind: Decodable {
        let speed: Double
    }
    
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }
}

struct City: Identifiable, Codable {
    let id: UUID
    let name: String
    let temperature: Int
    let date: String
    let weatherCondition: String
    let weatherIcon: String
    var timezone: Int?
    var windSpeed: Double?
    var humidity: Int?
    var coordinate: CLLocationCoordinate2D?
    var hourlyForecast: [HourlyForecast]?
    
    // Manually define CodingKeys to handle UUID and custom encoding/decoding
    enum CodingKeys: String, CodingKey {
            case id, name, temperature, date, weatherCondition, weatherIcon, timezone, windSpeed, humidity, coordinate, hourlyForecast
        }

    init(id: UUID = UUID(), name: String, temperature: Int, date: String, weatherCondition: String, weatherIcon: String, timezone: Int? = nil, windSpeed: Double? = nil, humidity: Int? = nil, coordinate: CLLocationCoordinate2D? = nil, hourlyForecast: [HourlyForecast]?) {
        self.id = id
        self.name = name
        self.temperature = temperature
        self.date = date
        self.weatherCondition = weatherCondition
        self.weatherIcon = weatherIcon
        self.timezone = timezone
        self.windSpeed = windSpeed
        self.humidity = humidity
        self.coordinate = coordinate
        self.hourlyForecast = hourlyForecast
    }

    // Decoder initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        temperature = try container.decode(Int.self, forKey: .temperature)
        date = try container.decode(String.self, forKey: .date)
        weatherCondition = try container.decode(String.self, forKey: .weatherCondition)
        weatherIcon = try container.decode(String.self, forKey: .weatherIcon)
        timezone = try container.decodeIfPresent(Int.self, forKey: .timezone)
        windSpeed = try container.decodeIfPresent(Double.self, forKey: .windSpeed)
        humidity = try container.decodeIfPresent(Int.self, forKey: .humidity)
        
        // Decode coordinate
        if let coordinateDict = try container.decodeIfPresent([String: Double].self, forKey: .coordinate) {
            if let latitude = coordinateDict["latitude"], let longitude = coordinateDict["longitude"] {
                coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                coordinate = nil
            }
        } else {
            coordinate = nil
        }
        
        // Decode hourlyForecast
        hourlyForecast = try container.decodeIfPresent([HourlyForecast].self, forKey: .hourlyForecast)
    }

    // Encoder function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(temperature, forKey: .temperature)
        try container.encode(date, forKey: .date)
        try container.encode(weatherCondition, forKey: .weatherCondition)
        try container.encode(weatherIcon, forKey: .weatherIcon)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(windSpeed, forKey: .windSpeed)
        try container.encode(humidity, forKey: .humidity)
        
        // Encode coordinate
        if let coordinate = coordinate {
            var coordinateDict = [String: Double]()
            coordinateDict["latitude"] = coordinate.latitude
            coordinateDict["longitude"] = coordinate.longitude
            try container.encode(coordinateDict, forKey: .coordinate)
        }
        
        // Encode hourlyForecast
        try container.encode(hourlyForecast, forKey: .hourlyForecast)
    }
}
