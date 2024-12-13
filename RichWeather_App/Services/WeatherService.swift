//
//  WeatherService.swift
//  RichWeather_App
//
//  Created by Eason Lin on 12/12/2024.
//

import Foundation
import SwiftUI
import CoreLocation

class NetworkManager: ObservableObject {
    @Published var cities: [City] = []
    let apiKey = "33e00aaafea73378ee1d6f859b0d733f"
    
    @AppStorage("refreshInterval") private var refreshInterval: SettingsView.RefreshInterval = .fifteenMinutes
    private var timer: Timer?

    init() {
        Task {
            await loadCities()
        }
        startPeriodicUpdates()
    }
    
    func startPeriodicUpdates() {
        timer?.invalidate() // Invalidate any existing timer

        timer = Timer.scheduledTimer(withTimeInterval: refreshInterval.timeInterval, repeats: true) { [weak self] _ in
            Task {
                await self?.refreshWeatherData()
            }
        }
    }

    func refreshWeatherData() async {
        // Refresh data for each city
        for city in cities {
            await fetchWeatherForCity(cityName: city.name)
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
            print("Unable to encode cities array: \(error)") // Fixed the error message syntax
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
            print("Unable to decode cities array: \(error)") // Fixed the error message syntax
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
            let coordinate = CLLocationCoordinate2D(latitude: decodedResponse.coord.lat, longitude: decodedResponse.coord.lon)
            let forecast = await fetchHourlyForecast(lat: decodedResponse.coord.lat, lon: decodedResponse.coord.lon)
            
            let city = City(
                name: decodedResponse.name,
                temperature: Int(decodedResponse.main.temp),
                date: Utility.getCurrentTime(timezoneOffset: decodedResponse.timezone),
                weatherCondition: decodedResponse.weather.first?.description ?? "",
                weatherIcon: Utility.getIconName(for: decodedResponse.weather.first?.icon ?? ""),
                timezone: decodedResponse.timezone,
                windSpeed: decodedResponse.wind.speed,
                humidity: decodedResponse.main.humidity,
                coordinate: coordinate,
                hourlyForecast: forecast
            )
            
            await MainActor.run {
                cities.append(city)
                saveCities()
            }
        } catch {
            print("Error fetching or decoding data: \(error.localizedDescription)")
        }
    }
    
    func fetchHourlyForecast(lat: Double, lon: Double) async -> [HourlyForecast]? {
        print("checkpoint 0.7")
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric") else {
            print("Invalid Forecast URL")
            return nil
        }
        
        do {
            print("checkpoint 0.8")
            let (data, response) = try await URLSession.shared.data(from: url)
            
            print("checkpoint 0.9")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid Forecast response from server")
                return nil
            }
            
            print("checkpoint 1")
            
            let decodedForecast = try JSONDecoder().decode(OneCallResponse.self, from: data)
            
            print("checkpoint 1.1")
            return Array(decodedForecast.list.prefix(24)) // Get next 24 hours
        
        } catch {
            print("Error fetching or decoding forecast data: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Response structure definitions
    struct OneCallResponse: Decodable {
        let list: [HourlyForecast]
    }
    
    struct WeatherData: Decodable {
        let name: String
        let main: Main
        let weather: [WeatherInfo]
        let timezone: Int
        let wind: Wind
        let coord: Coord

        struct Main: Decodable {
            let temp: Double
            let humidity: Int
        }

        struct WeatherInfo: Decodable {
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
}
