////
////  WeatherService.swift
////  RichWeather_App
////
////  Created by Eason Lin on 12/12/2024.
////

//import Foundation
//import SwiftUI
//import SwiftData
//
//class WeatherService: ObservableObject {
//    @Published var isLoading = false
//    @Published var error: String?
//
//        private let apiKey = "YOUR_API_KEY" // Replace with your actual API key
//        private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
//    
//    // Modify fetchWeatherDataForCities to accept a ModelContext
//    func fetchWeatherDataForCities(cityNames: [String], context: ModelContext) {
//        isLoading = true
//        error = nil
//
//        let dispatchGroup = DispatchGroup()
//
//        for cityName in cityNames {
//            dispatchGroup.enter()
//            fetchWeather(for: cityName) { cityData in
//                if let cityData = cityData {
//                    // Use the ModelContext to insert the new City
//                    context.insert(cityData)
//                }
//                dispatchGroup.leave()
//            }
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            self.isLoading = false
//            // No need to update weatherData here since @Query will handle it
//        }
//    }
//    
//    // Modify the existing fetchWeather function to call the completion handler
//    func fetchWeather(for city: String, completion: @escaping (City?) -> Void) {
//        guard let url = URL(string: "\(baseURL)?q=\(city)&appid=\(apiKey)") else {
//            completion(nil)
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("Error fetching weather data: \(error)")
//                    completion(nil)
//                    return
//                }
//                
//                guard let data = data else {
//                    print("No data received")
//                    completion(nil)
//                    return
//                }
//                
//                do {
//                    let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
//                    // Create a new City instance using the default initializer
//                    let city = City()
//                    self.updateCity(city, from: decodedData)
//                    completion(city)
//                } catch {
//                    print("Error decoding weather data: \(error)")
//                    completion(nil)
//                }
//            }
//        }.resume()
//    }
//    
//    private func updateCity(_ city: City, from data: WeatherResponse) {
//            city.cityId = data.id
//            city.name = data.name
//            city.timezone = data.timezone
//            city.longitude = data.coord.lon
//            city.latitude = data.coord.lat
//            city.temperature = data.main.temp
//            city.feelsLike = data.main.feels_like
//            city.tempMin = data.main.temp_min
//            city.tempMax = data.main.temp_max
//            city.pressure = data.main.pressure
//            city.humidity = data.main.humidity
//            city.weatherId = data.weather.first?.id ?? 0
//            city.weatherMain = data.weather.first?.main ?? ""
//            city.weatherDescription = data.weather.first?.description ?? ""
//            city.weatherIcon = data.weather.first?.icon ?? ""
//            city.windSpeed = data.wind.speed
//            city.windDegree = data.wind.deg
//            city.windGust = data.wind.gust
//            city.cloudiness = data.clouds.all
//            city.country = data.sys.country
//            city.sunrise = data.sys.sunrise
//            city.sunset = data.sys.sunset
//            city.visibility = data.visibility
//            city.dt = data.dt
//        }
//    }
//    
//    
//    struct WeatherResponse: Decodable {
//        let coord: Coord
//        let weather: [Weather]
//        let main: Main
//        let wind: Wind
//        let clouds: Clouds
//        let sys: Sys
//        let timezone: Int
//        let id: Int
//        let name: String
//        let dt: Int
//        let visibility: Int
//    }
//    
//    struct Coord: Decodable {
//        let lon: Double
//        let lat: Double
//    }
//    
//    struct Weather: Decodable {
//        let id: Int
//        let main: String
//        let description: String
//        let icon: String
//    }
//    
//    struct Main: Decodable {
//        let temp: Double
//        let feels_like: Double
//        let temp_min: Double
//        let temp_max: Double
//        let pressure: Int
//        let humidity: Int
//    }
//    
//    struct Wind: Decodable {
//        let speed: Double
//        let deg: Int
//        let gust: Double?
//    }
//    
//    struct Clouds: Decodable {
//        let all: Int
//    }
//    
//    struct Sys: Decodable {
//        let country: String
//        let sunrise: Int
//        let sunset: Int
//    }
//


import Foundation
import SwiftUI
import CoreLocation 

class NetworkManager: ObservableObject {
    @Published var cities: [City] = []
    let apiKey = "33e00aaafea73378ee1d6f859b0d733f"
    
    init() {
        Task {
            await loadCities()
        }
    }
    
    func fetchWeatherForCity(cityName: String) async {
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCityName)&appid=\(apiKey)&units=metric") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                return
            }

            let decodedResponse = try JSONDecoder().decode(WeatherData.self, from: data)
            
            // Extract coordinate data
            let coordinate = CLLocationCoordinate2D(latitude: decodedResponse.coord.lat, longitude: decodedResponse.coord.lon)

            
            let city = City(name: decodedResponse.name,
                            temperature: Int(decodedResponse.main.temp),
                            date: Utility.getCurrentTime(timezoneOffset: decodedResponse.timezone),
                            weatherCondition: decodedResponse.weather[0].description,
                            weatherIcon: Utility.getIconName(for: decodedResponse.weather[0].icon),
                            timezone: decodedResponse.timezone,
                            windSpeed: decodedResponse.wind.speed,
                            humidity: decodedResponse.main.humidity,
                            coordinate: coordinate)
            await MainActor.run {
                cities.append(city)
                saveCities()
            }
        } catch {
            print("Error fetching or decoding data: \(error.localizedDescription)")
        }
    }
    
    func deleteCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
        saveCities()
    }
    
    func moveCity(from source: IndexSet, to destination: Int) {
        cities.move(fromOffsets: source, toOffset: destination)
        saveCities()
    }
    
    private func saveCities() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(cities)
            UserDefaults.standard.set(data, forKey: "cities")
        } catch {
            print("Unable to encode cities array: \(error)")
        }
    }
    
    private func loadCities() async {
        guard let data = UserDefaults.standard.data(forKey: "cities") else { return }
        do {
            let decoder = JSONDecoder()
            let loadedCities = try decoder.decode([City].self, from: data)
            await MainActor.run {
                self.cities = loadedCities
            }
        } catch {
            print("Unable to decode cities array: \(error)")
        }
    }
}
