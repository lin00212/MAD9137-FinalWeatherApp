//
//  HourlyForecast.swift
//  RichWeather_App
//
//  Created by Eason Lin on 13/12/2024.
//

import Foundation

struct HourlyForecast: Identifiable, Decodable {
    let id = UUID()
    let dt: Int
    let main: MainData
    let weather: [WeatherInfo]
    
    struct MainData: Decodable {
        let temp: Double
    }
    
    struct WeatherInfo: Decodable {
        let description: String
        let icon: String
    }
    
    var time: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a" // e.g., "3 PM"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: date)
    }
    
    var temperatureCelsius: String {
        return String(format: "%.0f°C", main.temp)
    }
    
    var weatherIcon: String {
        return Utility.getIconName(for: weather.first?.icon ?? "")
    }
    
    // CodingKeys to match the API response structure
    private enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
    }
}

// This can be in the same file or separate, depending on your preference
extension HourlyForecast {
    // Sample data for previews
    static var samples: [HourlyForecast] {
        [
            HourlyForecast(
                dt: 1734091200,
                main: MainData(temp: 25.5),
                weather: [WeatherInfo(description: "clear sky", icon: "01d")]
            ),
            HourlyForecast(
                dt: 1734102000,
                main: MainData(temp: 26.2),
                weather: [WeatherInfo(description: "few clouds", icon: "02d")]
            ),
            HourlyForecast(
                dt: 1734112800,
                main: MainData(temp: 24.8),
                weather: [WeatherInfo(description: "scattered clouds", icon: "03d")]
            ),
            // Add more sample data as needed
        ]
    }
}
