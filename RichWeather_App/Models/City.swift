//import Foundation
//import SwiftData
//
//@Model
//class City {
//    var id: UUID
//    var cityId: Int
//    var name: String
//    var timezone: Int
//
//    
//    var localTime: String {
//        let date = Date(timeIntervalSince1970: TimeInterval(dt))
//        let timeZoneOffset = TimeInterval(timezone)
//        let localDate = date.addingTimeInterval(timeZoneOffset)
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm a" // Changed to 12-hour format with AM/PM
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        
//        return dateFormatter.string(from: localDate)
//    }
//    
//    // Coordinates
//    var longitude: Double
//    var latitude: Double
//
//    // Weather conditions
//    var temperature: Double
//    var feelsLike: Double
//    var tempMin: Double
//    var tempMax: Double
//    var pressure: Int
//    var humidity: Int
//    var weatherId: Int
//    var weatherMain: String
//    var weatherDescription: String
//    var weatherIcon: String
//
//    // Wind information
//    var windSpeed: Double
//    var windDegree: Int
//    var windGust: Double?
//
//    // Cloud coverage
//    var cloudiness: Int
//
//    // System information
//    var country: String
//    var sunrise: Int
//    var sunset: Int
//
//    // Additional info
//    var visibility: Int
//    var dt: Int
//
//    var weatherIconSFSymbol: String {
//            switch weatherIcon {
//            case "01d":
//                return "sun.max"
//            case "01n":
//                return "moon"
//            case "02d":
//                return "cloud.sun"
//            case "02n":
//                return "cloud.moon"
//            case "03d", "03n", "04d", "04n", "50d", "50n":
//                return "cloud"
//            case "09d", "09n":
//                return "cloud.heavyrain"
//            case "10d":
//                return "cloud.rain"
//            case "10n":
//                return "cloud.moon.rain"
//            case "11d", "11n":
//                return "cloud.bolt"
//            case "13d", "13n":
//                return "cloud.snow"
//            default:
//                return "questionmark.circle" // Default icon for unknown weather conditions
//            }
//        }
//
//    init() {
//        self.id = UUID()
//        self.cityId = 0
//        self.name = ""
//        self.timezone = 0
//        self.longitude = 0.0
//        self.latitude = 0.0
//        self.temperature = 0.0
//        self.feelsLike = 0.0
//        self.tempMin = 0.0
//        self.tempMax = 0.0
//        self.pressure = 0
//        self.humidity = 0
//        self.weatherId = 0
//        self.weatherMain = ""
//        self.weatherDescription = ""
//        self.weatherIcon = ""
//        self.windSpeed = 0.0
//        self.windDegree = 0
//        self.windGust = 0.0
//        self.cloudiness = 0
//        self.country = ""
//        self.sunrise = 0
//        self.sunset = 0
//        self.visibility = 0
//        self.dt = 0
//    }
//}
//
////import Foundation
////import SwiftData
////
////@Model
////class City {
////    var id: UUID
////    var cityId: Int
////    var name: String
////    var timezone: Int
////    
////    // Coordinates
////    var longitude: Double
////    var latitude: Double
////    
////    // Weather conditions
////    var temperature: Double
////    var feelsLike: Double
////    var tempMin: Double
////    var tempMax: Double
////    var pressure: Int
////    var humidity: Int
////    var weatherId: Int
////    var weatherMain: String
////    var weatherDescription: String
////    var weatherIcon: String
////    
////    // Wind information
////    var windSpeed: Double
////    var windDegree: Int
////    var windGust: Double?
////    
////    // Cloud coverage
////    var cloudiness: Int
////    
////    // System information
////    var country: String
////    var sunrise: Int
////    var sunset: Int
////    
////    // Additional info
////    var visibility: Int
////    var dt: Int
////    
////    var temperatureCelsius: String {
////        return String(format: "%.1f", temperature - 273.15)
////    }
////    
////    var temperatureFahrenheit: String {
////        return String(format: "%.1f", (temperature - 273.15) * 9/5 + 32)
////    }
////    
////    var localTime: String {
////        let date = Date(timeIntervalSince1970: TimeInterval(dt))
////        let timeZoneOffset = TimeInterval(timezone)
////        let localDate = date.addingTimeInterval(timeZoneOffset)
////        
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "h:mm a" // Changed to 12-hour format with AM/PM
////        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
////        
////        return dateFormatter.string(from: localDate)
////    }
////
////    var localDateTime: String {
////        let date = Date(timeIntervalSince1970: TimeInterval(dt))
////        let timeZoneOffset = TimeInterval(timezone)
////        let localDate = date.addingTimeInterval(timeZoneOffset)
////        
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateStyle = .medium
////        dateFormatter.timeStyle = .short
////        dateFormatter.amSymbol = "AM"  // Explicitly set AM symbol
////        dateFormatter.pmSymbol = "PM"  // Explicitly set PM symbol
////        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
////        
////        return dateFormatter.string(from: localDate)
////    }
////
////    var sunriseTime: String {
////        let date = Date(timeIntervalSince1970: TimeInterval(sunrise))
////        let timeZoneOffset = TimeInterval(timezone)
////        let localDate = date.addingTimeInterval(timeZoneOffset)
////        
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "h:mm a" // Changed to 12-hour format with AM/PM
////        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
////        return dateFormatter.string(from: localDate)
////    }
////
////    var sunsetTime: String {
////        let date = Date(timeIntervalSince1970: TimeInterval(sunset))
////        let timeZoneOffset = TimeInterval(timezone)
////        let localDate = date.addingTimeInterval(timeZoneOffset)
////        
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "h:mm a" // Changed to 12-hour format with AM/PM
////        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
////        return dateFormatter.string(from: localDate)
////    }
////    
////    var weatherIconSFSymbol: String {
////        switch weatherIcon {
////        case "01d":
////            return "sun.max"
////        case "01n":
////            return "moon"
////        case "02d":
////            return "cloud.sun"
////        case "02n":
////            return "cloud.moon"
////        case "03d", "03n", "04d", "04n", "50d", "50n":
////            return "cloud"
////        case "09d", "09n":
////            return "cloud.heavyrain"
////        case "10d":
////            return "cloud.rain"
////        case "10n":
////            return "cloud.moon.rain"
////        case "11d", "11n":
////            return "cloud.bolt"
////        case "13d", "13n":
////            return "cloud.snow"
////        default:
////            return "questionmark.circle" // Default icon for unknown weather conditions
////        }
////    }
////    
////    init(
////        cityId: Int,
////        name: String,
////        timezone: Int,
////        longitude: Double,
////        latitude: Double,
////        temperature: Double,
////        feelsLike: Double,
////        tempMin: Double,
////        tempMax: Double,
////        pressure: Int,
////        humidity: Int,
////        weatherId: Int,
////        weatherMain: String,
////        weatherDescription: String,
////        weatherIcon: String,
////        windSpeed: Double,
////        windDegree: Int,
////        windGust: Double?,
////        cloudiness: Int,
////        country: String,
////        sunrise: Int,
////        sunset: Int,
////        visibility: Int,
////        dt: Int
////    ) {
////        self.id = UUID()
////        self.cityId = cityId
////        self.name = name
////        self.timezone = timezone
////        self.longitude = longitude
////        self.latitude = latitude
////        self.temperature = temperature
////        self.feelsLike = feelsLike
////        self.tempMin = tempMin
////        self.tempMax = tempMax
////        self.pressure = pressure
////        self.humidity = humidity
////        self.weatherId = weatherId
////        self.weatherMain = weatherMain
////        self.weatherDescription = weatherDescription
////        self.weatherIcon = weatherIcon
////        self.windSpeed = windSpeed
////        self.windDegree = windDegree
////        self.windGust = windGust
////        self.cloudiness = cloudiness
////        self.country = country
////        self.sunrise = sunrise
////        self.sunset = sunset
////        self.visibility = visibility
////        self.dt = dt
////    }
////    
////    static var samples: [City] {
////        [
////            City(
////                cityId: 2643743,
////                name: "London",
////                timezone: 0,
////                longitude: -0.1257,
////                latitude: 51.5085,
////                temperature: 283.15,
////                feelsLike: 282.04,
////                tempMin: 282.59,
////                tempMax: 283.71,
////                pressure: 1013,
////                humidity: 87,
////                weatherId: 300,
////                weatherMain: "Drizzle",
////                weatherDescription: "light intensity drizzle",
////                weatherIcon: "09d",
////                windSpeed: 4.63,
////                windDegree: 250,
////                windGust: 8.23,
////                cloudiness: 75,
////                country: "GB",
////                sunrise: 1734046755,
////                sunset: 1734079793,
////                visibility: 10000,
////                dt: 1734046755
////            )
////        ]
////    }
////}
